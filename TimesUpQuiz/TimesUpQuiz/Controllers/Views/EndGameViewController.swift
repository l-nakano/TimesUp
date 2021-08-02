import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var endGameTitleLabel: UILabel!
    @IBOutlet weak var endGameScoreLabel: UILabel!
    @IBOutlet weak var endGameAnswersLabel: UILabel!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeButtonLayout(button: backToMenuButton, text: "Voltar ao Menu")
        preparePopUpView()
        prepareLabels()
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
    
    func preparePopUpView() {
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.layer.shadowColor = UIColor(named: "CardsShadowColor")?.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func prepareLabels() {
        endGameTitleLabel.font = UIFont(name: "Anton-Regular", size: 30)
        endGameScoreLabel.font = UIFont(name: "Anton-Regular", size: 20)
        endGameAnswersLabel.font = UIFont(name: "Anton-Regular", size: 20)
        
        if GameManager.shared.userWin {
            endGameTitleLabel.text = "Você venceu!"
            GameManager.shared.userScore += 100
        } else {
            endGameTitleLabel.text = "O tempo acabou!"
        }
        endGameScoreLabel.text = "Pontuação: \(GameManager.shared.userScore)"
        endGameAnswersLabel.text = "Questões certas: \(GameManager.shared.rightAnswersCounter)"
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
