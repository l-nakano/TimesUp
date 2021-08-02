import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var scoreboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeButtonLayout(button: startGameButton, text: "Iniciar")
        changeButtonLayout(button: howToPlayButton, text: "Como Jogar")
        changeButtonLayout(button: scoreboardButton, text: "Scoreboard")
    }
    
    func changeButtonLayout(button: UIButton, text: String) {
        button.titleLabel?.font = UIFont(name: "Anton-Regular", size: 25)
        button.titleLabel?.tintColor = UIColor.black
        button.setTitle(text, for: .normal)
        button.backgroundColor = UIColor(named: "HelpHudColor")
        
        button.layer.cornerRadius = 10.0
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        
        button.layer.shadowColor = UIColor(named: "CardsShadowColor")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        button.layer.shadowRadius = 1.0
        button.layer.shadowOpacity = 1.0
        button.layer.masksToBounds = false
        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: 0).cgPath
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
