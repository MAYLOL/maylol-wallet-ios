// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import WebKit
import JavaScriptCore
import Result

protocol MLBrowserViewControllerDelegate: class {
//    func didCall(action: DappAction, callbackID: Int)
//    func didVisitURL(url: URL, title: String)
}

final class MLBrowserViewController: UIViewController {

    private var myContext = 0

    private struct Keys {
        static let estimatedProgress = "estimatedProgress"
        static let developerExtrasEnabled = "developerExtrasEnabled"
        static let URL = "URL"
        static let ClientName = "Trust"
        static let title = "title"
    }

    var navController: NavigationController?

    private lazy var userClient: String = {
        return Keys.ClientName + "/" + (Bundle.main.versionNumber ?? "")
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView(
            frame: .zero,
            configuration: self.config
        )
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        if isDebug {
            webView.configuration.preferences.setValue(true, forKey: Keys.developerExtrasEnabled)
        }
        return webView
    }()

    lazy var errorView: BrowserErrorView = {
        let errorView = BrowserErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.delegate = self
        return errorView
    }()

    weak var delegate: MLBrowserViewControllerDelegate?

//    var browserNavBar: BrowserNavigationBar? {
//        return navigationController?.navigationBar as? BrowserNavigationBar
//    }

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.tintColor = Colors.darkBlue
        progressView.trackTintColor = .clear
        return progressView
    }()

//    Take a look at this issue : https://stackoverflow.com/questions/26383031/wkwebview-causes-my-view-controller-to-leak
    lazy var config: WKWebViewConfiguration = {
        //TODO
//        let config = WKWebViewConfiguration.make(for: server, address: account.address, with: sessionConfig, in: ScriptMessageProxy(delegate: self))
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.default()
        return config
    }()

//    let server: RPCServer
    init(
        navigationController: NavigationController
         ) {
        super.init(nibName: nil, bundle: nil)
        self.navController = navigationController
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
         super.viewDidLoad()
        setup()
    }
    func setup() {
        view.addSubview(webView)
        injectUserAgent()

        webView.addSubview(progressView)
        webView.bringSubview(toFront: progressView)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),

            progressView.topAnchor.constraint(equalTo: view.layoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),

            errorView.topAnchor.constraint(equalTo: webView.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: webView.bottomAnchor),
            ])
        view.backgroundColor = .white
        webView.addObserver(self, forKeyPath: Keys.estimatedProgress, options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: Keys.URL, options: [.new, .initial], context: &myContext)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        browserNavBar?.browserDelegate = self
        refreshURL()
    }

    private func injectUserAgent() {
        webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, _ in
            guard let `self` = self, let currentUserAgent = result as? String else { return }
            self.webView.customUserAgent = currentUserAgent + " " + self.userClient
        }
    }

    func goTo(url: URL) {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        hideErrorView()
        webView.load(request)
    }

    func notifyFinish(callbackID: Int, value: Result<DappCallback, DAppError>) {
        let script: String = {
            switch value {
            case .success(let result):
                return "executeCallback(\(callbackID), null, \"\(result.value.object)\")"
            case .failure(let error):
                return "executeCallback(\(callbackID), \"\(error)\", null)"
            }
        }()
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

//    func goHome() {
////        guard let url = URL(string: Constants.dappsBrowserURL) else { return }
//        var request = URLRequest(url: url)
//        request.cachePolicy = .returnCacheDataElseLoad
//        hideErrorView()
//        webView.load(request)
////        browserNavBar?.textField.text = url.absoluteString
//    }

    func reload() {
        hideErrorView()
        webView.reload()
    }

    private func stopLoading() {
        webView.stopLoading()
    }

    private func refreshURL() {
//        browserNavBar?.textField.text = webView.url?.absoluteString
//        browserNavBar?.backButton.isHidden = !webView.canGoBack

    }

//    private func recordURL() {
//        guard let url = webView.url else {
//            return
//        }
//        delegate?.didVisitURL(url: url, title: webView.title ?? "")
//    }

//    private func changeURL(_ url: URL) {
//        delegate?.runAction(action: .changeURL(url))
//        refreshURL()
//    }

    private func hideErrorView() {
        errorView.isHidden = true
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == Keys.estimatedProgress {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress
                progressView.isHidden = progress == 1
            }
        } else if keyPath == Keys.URL {
            if let url = webView.url {
//                self.browserNavBar?.textField.text = url.absoluteString
//                changeURL(url)
            }
        } else if keyPath == Keys.title {
//            navController?.title = self.webView.title
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: Keys.estimatedProgress)
        webView.removeObserver(self, forKeyPath: Keys.URL)
    }

    func handleError(error: Error) {
        if error.code == NSURLErrorCancelled {
            return
        } else {
            if error.domain == NSURLErrorDomain,
                let failedURL = (error as NSError).userInfo[NSURLErrorFailingURLErrorKey] as? URL {
//                changeURL(failedURL)
            }
            errorView.show(error: error)
        }
    }
}

extension MLBrowserViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        recordURL()
        hideErrorView()
        refreshURL()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        hideErrorView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
}

//extension MLBrowserViewController: WKScriptMessageHandler {
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        guard let command = DappAction.fromMessage(message) else { return }
//        let requester = DAppRequester(title: webView.title, url: webView.url)
//        //TODO: Refactor
////        let token = TokensDataStore.token(for: server)
////        let transfer = Transfer(server: server, type: .dapp(token, requester))
//        let action = DappAction.fromCommand(command, transfer: transfer)
//
//        delegate?.didCall(action: action, callbackID: command.id)
//    }
//}

extension MLBrowserViewController: BrowserErrorViewDelegate {
    func didTapReload(_ sender: Button) {
        reload()
    }
}
