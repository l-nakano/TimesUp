import UIKit

class QuestionCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var questionLabel: UILabel!
    
    func configure(text: String, color: UIColor, size: CGSize) {
        questionLabel.font = UIFont(name: "Anton-Regular", size: 25)
        questionLabel.text = text
        
        backgroundColor = color
        frame.size = size
        
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
