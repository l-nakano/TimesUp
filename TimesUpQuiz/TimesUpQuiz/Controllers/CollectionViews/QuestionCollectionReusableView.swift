import UIKit

class QuestionCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var questionLabel: UILabel!
    
    func configure(text: String) {
        questionLabel.text = text
        self.backgroundColor = UIColor.red
    }
}
