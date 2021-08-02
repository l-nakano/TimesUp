import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configure(text: String, color: UIColor, disableCell: Bool = false) {
        answerLabel.text = text
        answerLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width * 0.9).isActive = true
        answerLabel.adjustsFontSizeToFitWidth = true
        isUserInteractionEnabled = disableCell ? false : true
        
        backgroundColor = color
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        layer.shadowColor = UIColor(named: "CardsShadowColor")?.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}
