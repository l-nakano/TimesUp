import UIKit

let reuseAnswerIdentifier = "Answer"
let reuseQuestionIdentifier = "Question"

class QuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var answerCollection: UICollectionView!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var userRights: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var testeCount = 0 // Mudar para a variável aleatória
    var testeFreeze = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        answerCollection.dataSource = self
        answerCollection.delegate = self
        
        timerLabel.text = String(GameManager.shared.timeLeft)
        
        userRights.text = String(GameManager.shared.rightAnswersCounter)
        userScore.text = String(GameManager.shared.userScore)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    // Change Header and Cell content
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAnswerIdentifier, for: indexPath) as? AnswerCollectionViewCell {
            
            let currentText = GameManager.shared.questionsList[testeCount].answersList[indexPath.item].answerText
            if !GameManager.shared.halfChoicesInUse {
                answerCell.configureNormalChoice(text: currentText)
            } else if GameManager.shared.checkIfPicked(testeCount, indexPath.item) {
                answerCell.configureEliminatedChoice(text: currentText)
            } else {
                answerCell.configureNormalChoice(text: currentText)
            }
            
            cell = answerCell
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = UICollectionReusableView()
        
        if let questionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseQuestionIdentifier, for: indexPath) as? QuestionCollectionReusableView {
            
            questionHeader.configure(text: GameManager.shared.questionsList[testeCount].question)
            header = questionHeader
            header.frame.size = CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 2.1)
        }
        
        return header
    }
    
    // Changing layout settings
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameManager.shared.answersPerQuestion
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.1, height: collectionView.frame.width / 2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.frame.width / 3, left: 0, bottom: 0, right: 0)
    }
    
    // Item selected
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GameManager.shared.questionsList[testeCount].answersList[indexPath.item].isAnswer {
            collectionView.cellForItem(at: indexPath)!.blinkBackground(UIColor.green, finished: {
                self.reloadData(.rightAnswer)
            })
        } else {
            collectionView.cellForItem(at: indexPath)!.blinkBackground(UIColor.red, finished: {
                self.reloadData(.wrongAnswer)
            })
        }
    }
    
    func reloadData(_ method: AnswerMethod) {
        GameManager.shared.updateUserScoreAndTime(method)
        self.userRights.text = String(GameManager.shared.rightAnswersCounter)
        self.userScore.text = String(GameManager.shared.userScore)
        self.answerCollection.reloadData()
        self.testeCount += 1
        GameManager.shared.unselectUsedHelps()
    }
    
    // Timer counter
    
    @objc func updateCounter() {
        GameManager.shared.updateCounter(timerLabel)
    }
    
    // Gesture Recognizer
    
    @IBAction func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        gesture.direction = .left
        GameManager.shared.useSkipQuestionIfAvailable{ reloadData(.notAnswered) }
    }
    
    @IBAction func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        gesture.direction = .right
        GameManager.shared.useHalfChoicesIfAvailable(testeCount, answerCollection)
    }
    
    @IBAction func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        gesture.minimumPressDuration = GameManager.shared.timeToFreeze
        GameManager.shared.useFreezeTimeIfAvailable()
    }
    
    //

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
