import UIKit

extension UIView {
    
    func blink(_ method: blinkMethod, finished: @escaping () -> Void = {}) {
        switch method {
        case .rightAnswer:
            self.alpha = 0.5
            self.backgroundColor = UIColor.blue
            UIView.animate(withDuration: 0.12, animations: {
                UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true, animations: {
                    self.alpha = 1.0
                    self.backgroundColor = UIColor.green
                })
            }, completion: {_ in
                self.backgroundColor = UIColor.blue
                finished()
            })
        case .wrongAnswer:
            self.alpha = 0.5
            self.backgroundColor = UIColor.blue
            UIView.animate(withDuration: 0.12, animations: {
                UIView.modifyAnimations(withRepeatCount: 3, autoreverses: true, animations: {
                    self.alpha = 1.0
                    self.backgroundColor = UIColor.red
                })
            }, completion: {_ in
                self.backgroundColor = UIColor.blue
                finished()
            })
        }
    }
}
