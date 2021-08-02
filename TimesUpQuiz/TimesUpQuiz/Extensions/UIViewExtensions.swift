import UIKit

extension UIView {
    
    func blinkBackground(_ color: UIColor, finished: @escaping () -> Void = {}) {
        self.alpha = 0.5
        UIView.animate(withDuration: 0.12, animations: {
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true, animations: {
                self.alpha = 1.0
                self.backgroundColor = color
            })
        }, completion: {_ in
            self.backgroundColor = UIColor(named: "CoverCardsColor")
            finished()
        })
    }
    
    func changeImageWithAnimation(_ image: UIImage) {
        let imageView = self as! UIImageView
        imageView.alpha = 0.1
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear], animations: {
                        imageView.alpha = 1.0
                        imageView.image = image
        }, completion: nil)
    }
}
