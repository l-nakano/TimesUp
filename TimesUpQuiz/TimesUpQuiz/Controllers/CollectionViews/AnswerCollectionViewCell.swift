import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configure(text: String) {
        answerLabel.text = text
        answerLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width * 0.9).isActive = true
        answerLabel.adjustsFontSizeToFitWidth = true
        self.backgroundColor = UIColor.blue
    }
}
