import UIKit

extension UIView {
    
    func blinkBackground(_ color: UIColor, finished: @escaping () -> Void = {}) {
        self.alpha = 0.5
        self.backgroundColor = UIColor.blue
        UIView.animate(withDuration: 0.12, animations: {
            UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true, animations: {
                self.alpha = 1.0
                self.backgroundColor = color
            })
        }, completion: {_ in
            self.backgroundColor = UIColor.blue
            finished()
        })
    }
}
