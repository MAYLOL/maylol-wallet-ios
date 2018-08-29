// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class ButtonsFooterView: UIView {

    lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: UIButtonType.custom)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = Colors.bf2537color
        sendButton.setTitle(NSLocalizedString("ML.Transaction.cell.tokenTransfer.title", value: "Transfer", comment: ""), for: .normal)
        sendButton.accessibilityIdentifier = "send-button"

        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return sendButton
    }()

    lazy var requestButton: UIButton = {
        let requestButton = UIButton(type: UIButtonType.custom)
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
       requestButton.backgroundColor = Colors.f346075color
    requestButton.setTitle(NSLocalizedString("ML.Transaction.cell.receivables.title", value: "Receivables", comment: ""), for: .normal)
        return requestButton
    }()

    init(
        frame: CGRect,
        bottomOffset: CGFloat = 0
    ) {
        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [
            sendButton,
            requestButton,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -bottomOffset),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
