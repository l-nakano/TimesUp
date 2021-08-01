import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configureNormalChoice(text: String) {
        answerLabel.text = text
        answerLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width * 0.9).isActive = true
        answerLabel.adjustsFontSizeToFitWidth = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.blue
    }
    
    func configureEliminatedChoice(text: String) {
        answerLabel.text = text
        answerLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width * 0.9).isActive = true
        answerLabel.adjustsFontSizeToFitWidth = true
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.gray
    }
}
