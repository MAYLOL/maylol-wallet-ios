// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit

final class MLTokenHeaderView: UIView {

    lazy var titleLabel: UILabel = {
        var titleLabel: UILabel
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.titleBlackcolor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.text = "         "
        return titleLabel
    }()
    lazy var underDynamicLine: UIView = {
        var underDynamicLine = UIView()
        underDynamicLine.translatesAutoresizingMaskIntoConstraints = false
        underDynamicLine.layer.cornerRadius = 2
        underDynamicLine.layer.masksToBounds = true
        underDynamicLine.backgroundColor = Colors.f02e44color
        return underDynamicLine
    }()
    lazy var amountLabel: UILabel = {
        let amountLabel = UILabel()
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.textAlignment = .right
        amountLabel.font = UIFont.boldSystemFont(ofSize: 24)
        amountLabel.textColor = Colors.f22222ecolor
        amountLabel.text = "0.0000"
        return amountLabel
    }()
    lazy var currencyAmountLabel: UILabel = {
        let currencyAmountLabel = UILabel()
        currencyAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyAmountLabel.textAlignment = .right
        currencyAmountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        currencyAmountLabel.textColor = Colors.f22222ecolor
        currencyAmountLabel.text = "0"
        return currencyAmountLabel
    }()
    lazy var chatView: ARLineChartView = {
        let chatView: ARLineChartView = ARLineChartView(frame: CGRect(x: 25, y: kAutoLayoutHeigth(60), width: kScreenW - kAutoLayoutWidth(50), height: 150), desc1: "数量", desc2: "资产")
        chatView.xColor = Colors.f22222ecolor
        chatView.yColor = Colors.detailTextgraycolor
        chatView.lineY1Color = UIColor(red: 122, green: 133, blue: 202)
        chatView.lineY2Color = UIColor(red: 97, green: 180, blue: 196)
        chatView.formColor = Colors.detailTextgraycolor
        chatView.translatesAutoresizingMaskIntoConstraints = false
//        chatView.backgroundColor = Colors.textgraycolor
        return chatView
    }()
//    lazy var chatView: UIView = {
//        let chatView = UIView()
//        chatView.translatesAutoresizingMaskIntoConstraints = false
//        chatView.backgroundColor = Colors.textgraycolor
//        return chatView
//    }()
    lazy var sessionView: MLTransactionSessionView = {
        let sessionView = MLTransactionSessionView()
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        return sessionView
    }()
//    lazy var grayLine: UIView = {
//        var grayLine = UIView()
//        grayLine.translatesAutoresizingMaskIntoConstraints = false
//        grayLine.backgroundColor = Colors.e6e6e6color
//        return grayLine
//    }()
//    lazy var sessionLabel: UILabel = {
//        var sessionLabel: UILabel
//        sessionLabel = UILabel()
//        sessionLabel.translatesAutoresizingMaskIntoConstraints = false
//        sessionLabel.textAlignment = .left
//        sessionLabel.textColor = Colors.titleBlackcolor
//        sessionLabel.font = UIFont.boldSystemFont(ofSize: 15)
//        sessionLabel.text = NSLocalizedString("ML.Transaction.Recentrecords", value: "Recent Transaction Records", comment: "")
//        return sessionLabel
//    }()

//    lazy var marketPriceLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

//    lazy var totalAmountLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var fiatAmountLabel: UILabel = {
//        let label = UILabel(frame: .zero)
//        label.textColor = Colors.black
//        label.textAlignment = .right
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

//    lazy var imageView: TokenImageView = {
//        let imageView = TokenImageView(frame: .zero)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()

//    lazy var buttonsView: ButtonsFooterView = {
//        let footerView = ButtonsFooterView(
//            frame: .zero,
//            bottomOffset: 5
//        )
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//        footerView.setBottomBorder()
//        return footerView
//    }()
    var viewModel: TokenViewModel? {
        didSet {
            var untStr = "≈ ¥"
            if Config().currency == .CNY {
            }else if Config().currency == .USD {
                untStr = "≈ $"
            }
            titleLabel.text = viewModel?.token.symbol
            amountLabel.text = viewModel?.amountCountString


            currencyAmountLabel.text = "\(untStr)" +  (viewModel?.feelPrise)!

            let dataArr1:[String] = NSDate().latelyEightTimeInt() as! [String]


            let dataArr:[String] = NSDate().latelyEightTime() as! [String]

            var y1AmountDouble = Double((viewModel?.amountCountString)!)
            var y2FreeDouble = Double((viewModel?.feelPrise)!)




//            var y1A: [Double] = [0,2,10,5,3]
//            var xA: [Double] = [18,19,20,21,22];
//            var y2A: [Double] = [0,6000,60000,9000,1000];

            var y1A: [Double] = getY1Arr(d: y1AmountDouble!)
            var xA: [Double] = getXArr(stringArr: dataArr1)
            var y2A: [Double] = getY2Arr(d: y2FreeDouble!)

            var mutableArr:[RLLineChartItem] = NSMutableArray() as! [RLLineChartItem]
            for i in 0..<8 {
                let item = RLLineChartItem()
                item.xValue = xA[i]
                item.y1Value = y1A[i]
                item.y2Value = y2A[i]
                mutableArr.append(item)
//                mutableArr.addObjects(from: item)
            }
            chatView.dataSource = mutableArr
            chatView.startDraw()
//            symbolImageView.kf.setImage(
//                with: viewModel.imageURL,
//                placeholder: viewModel.placeholderImage
//            )
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func getY1Arr(d: Double) -> [Double] {
        let y1: [Double] = [0,0,0,0,0,0,0,d/1]
        return y1
    }
    func getXArr(stringArr: [String]) -> [Double] {
        var arr:[Double] = []
        print(stringArr)
        let arrReversed: [String] = stringArr.reversed()
        for str in arrReversed {
            let date = Double(string: str)
            arr.append(date!)
        }
        return arr
    }
    func getY2Arr(d: Double) -> [Double] {
//        let y2: [Double] = [0,d/7,d/6,d/5,d/4,d/3,d/2,d/1]
        let y2: [Double] = [0,0,0,0,0,0,0,d/1]
        return y2
    }

    func setup() {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(underDynamicLine)
        addSubview(amountLabel)
        addSubview(currencyAmountLabel)
        addSubview(chatView)
        addSubview(sessionView)
//        addSubview(grayLine)
//        addSubview(sessionLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        kAutoLayoutHeigth
//        kAutoLayoutWidth
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: kAutoLayoutHeigth(0)),
            underDynamicLine.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            underDynamicLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: kAutoLayoutHeigth(7)),
            underDynamicLine.widthAnchor.constraint(equalToConstant: kAutoLayoutWidth(44)),
            underDynamicLine.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(4)),
            amountLabel.topAnchor.constraint(equalTo: underDynamicLine.bottomAnchor, constant: kAutoLayoutHeigth(20)),
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            currencyAmountLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: kAutoLayoutHeigth(9)),
            currencyAmountLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            chatView.rightAnchor.constraint(equalTo: rightAnchor, constant: kAutoLayoutWidth(-25)),
            chatView.leftAnchor.constraint(equalTo: leftAnchor, constant: kAutoLayoutWidth(25)),
            chatView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(150)),
            chatView.topAnchor.constraint(equalTo: currencyAmountLabel.bottomAnchor, constant: kAutoLayoutHeigth(10)),
            sessionView.topAnchor.constraint(equalTo: chatView.bottomAnchor, constant: kAutoLayoutHeigth(25)),
            sessionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            sessionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            sessionView.heightAnchor.constraint(equalToConstant: 70),

//            grayLine.topAnchor.constraint(equalTo: chatView.bottomAnchor, constant: 25),
//            grayLine.rightAnchor.constraint(equalTo: rightAnchor, constant: 25),
//            grayLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
//            grayLine.heightAnchor.constraint(equalToConstant: 1),
//            sessionLabel.topAnchor.constraint(equalTo: grayLine.bottomAnchor, constant: 25),
//            sessionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

