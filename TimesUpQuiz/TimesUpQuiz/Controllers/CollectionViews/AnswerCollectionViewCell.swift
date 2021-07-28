import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configure(text: String) {
        answerLabel.text = text
        self.backgroundColor = UIColor.blue
    }
}
