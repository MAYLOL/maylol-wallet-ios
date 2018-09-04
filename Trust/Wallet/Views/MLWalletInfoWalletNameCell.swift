// Copyright DApps Platform Inc. All rights reserved.

import Foundation

class MLWalletInfoWalletNameCell: UITableViewCell {
    static let identifier = "MLWalletInfoWalletNameCell"
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = Colors.f646464color
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 0
        titleLabel.font = AppStyle.PingFangSC12.font
        return titleLabel
    }()
    lazy var nameField: UnderLineTextFiled = {
        var nameField = UnderLineTextFiled(frame: .zero)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.isSecureTextEntry = false
        nameField.underLineColor = Colors.textgraycolor
        nameField.placeholder = "钱包名"
        nameField.font = UIFont.init(name: "PingFang SC", size: 12)
        nameField.delegate = self
        return nameField
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        addSubview(titleLabel)
        addSubview(nameField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            nameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 25),
            nameField.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            nameField.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

extension MLWalletInfoWalletNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        browserDelegate?.did(action: .enter(textField.text ?? ""))
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        browserDelegate?.did(action: .beginEditing)
    }
}
