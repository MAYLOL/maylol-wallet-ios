// Copyright DApps Platform Inc. All rights reserved.

import UIKit

final class WordCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var wordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        layer.borderColor = UIColor(hex: "C6C6C6").cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
    }
}
