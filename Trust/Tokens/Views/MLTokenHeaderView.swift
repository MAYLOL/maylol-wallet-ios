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
        let chatView: ARLineChartView = ARLineChartView(frame: CGRect(x: 25, y: kAutoLayoutHeigth(60), width: kScreenW - kAutoLayoutWidth(50), height: 150), desc1: "ML.Transaction.Count".localized(), desc2: "ML.Transaction.Assets".localized())
        chatView.xColor = Colors.f22222ecolor
        chatView.yColor = Colors.detailTextgraycolor
        chatView.lineY1Color = UIColor(red: 122, green: 133, blue: 202)
        chatView.lineY2Color = UIColor(red: 97, green: 180, blue: 196)
        chatView.formColor = Colors.detailTextgraycolor
        chatView.translatesAutoresizingMaskIntoConstraints = false
        return chatView
    }()
    lazy var sessionView: MLTransactionSessionView = {
        let sessionView = MLTransactionSessionView()
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        return sessionView
    }()
    var viewModel: TokenViewModel? {
        didSet {
            var untStr = "≈ ¥"
            if Config().currency == .CNY {
            } else if Config().currency == .USD {
                untStr = "≈ $"
            }
            titleLabel.text = viewModel?.token.symbol
            amountLabel.text = viewModel?.amountCountString
            currencyAmountLabel.text = "\(untStr)" +  (viewModel?.feelPrise)!
            let dataArr1: [String] = NSDate().latelyEightTimeInt() as! [String]
            let dataArr: [String] = NSDate().latelyEightTime() as! [String]
            let y1AmountDouble = viewModel?.amoutDouble
            let y2FreeDouble = Double((viewModel?.feelPrise)!)
            var y1A: [Double] = getY1Arr(d: y1AmountDouble ?? 0)
            var xA: [Double] = getXArr(stringArr: dataArr1)
            var y2A: [Double] = getY2Arr(d: y2FreeDouble ?? 0)

            var mutableArr: [RLLineChartItem] = NSMutableArray() as! [RLLineChartItem]
            for i in 0..<5 {
                let item = RLLineChartItem()
                item.xValue = xA[i]
                item.y1Value = y1A[i]
                item.y2Value = y2A[i]
                item.xString = dataArr[i]
                mutableArr.append(item)
            }
            chatView.dataSource = mutableArr
            chatView.startDraw()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func getY1Arr(d: Double) -> [Double] {
        let y1: [Double] = [0, 0, 0, 0, d/1]
        return y1
    }
    func getXArr(stringArr: [String]) -> [Double] {
        var arr: [Double] = []
        print(stringArr)
        let arrReversed: [String] = stringArr.reversed()
        for str in arrReversed {
            let date = Double(string: str)
            arr.append(date!)
        }
        return arr
    }
    func getY2Arr(d: Double) -> [Double] {
        let y2: [Double] = [0, 0, 0, 0, d/1]
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
    }
    override func layoutSubviews() {
        super.layoutSubviews()
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
            sessionView.heightAnchor.constraint(equalToConstant: kAutoLayoutHeigth(55)),
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
