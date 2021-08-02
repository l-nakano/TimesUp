import UIKit

let reuseAnswerIdentifier = "Answer"
let reuseQuestionIdentifier = "Question"

class QuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var answerCollection: UICollectionView!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var rightAnswersCounter: UILabel!
    @IBOutlet weak var userScoreImage: UIImageView!
    @IBOutlet weak var rightAnswersCounterImage: UIImageView!
    
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var testeCount = 0 // Mudar para a variável aleatória
    var testeFreeze = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerCollection.dataSource = self
        answerCollection.delegate = self
        
        initializeViewsAndConstraints()
        verticalStackView.spacing = answerCollection.frame.width / 4
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    // Change Header and Cell content
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAnswerIdentifier, for: indexPath) as? AnswerCollectionViewCell {
            
            let currentText = GameManager.shared.questionsList[testeCount].answersList[indexPath.item].answerText
            if !GameManager.shared.halfChoicesInUse {
                answerCell.configure(text: currentText, color: UIColor(named: "CardsColor")!)
            } else if checkIfPicked(indexPath.item) {
                answerCell.configure(text: currentText, color: UIColor(named: "CardsCoverColor")!, disableCell: true)
            } else {
                answerCell.configure(text: currentText, color: UIColor(named: "CardsColor")!)
            }
            
            cell = answerCell
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header = UICollectionReusableView()
        
        if let questionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseQuestionIdentifier, for: indexPath) as? QuestionCollectionReusableView {
            
            let headerSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 2.1)
            questionHeader.configure(text: GameManager.shared.questionsList[testeCount].question, color: UIColor(named: "CardsColor")!, size: headerSize)
            header = questionHeader
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
        return UIEdgeInsets(top: collectionView.frame.width / 2, left: 0, bottom: 0, right: 0)
    }
    
    func initializeViewsAndConstraints() {
        let screenSize: CGRect = UIScreen.main.bounds
        userScoreImage.widthAnchor.constraint(equalToConstant: screenSize.width * 0.075).isActive = true
        rightAnswersCounterImage.widthAnchor.constraint(equalToConstant: screenSize.width * 0.07).isActive = true
        
        rightAnswersCounter.text = String(GameManager.shared.rightAnswersCounter)
        userScore.text = String(GameManager.shared.userScore)
        
        timerLabel.text = String(GameManager.shared.timeLeft)
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
        updateUserScoreAndTime(method)
        unselectHelpsInUse()
        rightAnswersCounter.text = String(GameManager.shared.rightAnswersCounter)
        userScore.text = String(GameManager.shared.userScore)
        answerCollection.reloadData()
        testeCount += 1
    }
    
    // Timer counter
    
    @objc func updateCounter() {
        if GameManager.shared.timeLeft > 0 && !GameManager.shared.freezeTimeInUse {
            timerLabel.text = String(GameManager.shared.timeLeft)
            GameManager.shared.timeLeft -= 1
            GameManager.shared.currentQuestionTime += 1
        } else if GameManager.shared.timeLeft == 0 {
            timerLabel.text = "Acabou o tempo!"
        }
    }
    
    // Gesture Recognizer
    
    @IBAction func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        gesture.direction = .left
        useSkipQuestionIfAvailable{ reloadData(.notAnswered) }
    }
    
    @IBAction func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        gesture.direction = .right
        useHalfChoicesIfAvailable()
    }
    
    @IBAction func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        gesture.minimumPressDuration = GameManager.shared.timeToFreeze
        useFreezeTimeIfAvailable()
    }
    
    // Data Management Functions
    
    func updateUserScoreAndTime(_ method: AnswerMethod) {
        switch method {
        case .rightAnswer:
            GameManager.shared.rightAnswersCounter += 1
            GameManager.shared.timeLeft += 11
            if GameManager.shared.currentQuestionTime < 5 {
                GameManager.shared.userScore += 10
            } else {
                GameManager.shared.userScore += GameManager.shared.currentQuestionTime < 14 ? 14 - GameManager.shared.currentQuestionTime : 1
            }
        case .wrongAnswer:
            GameManager.shared.timeLeft -= 4
        default:
            break
        }
        GameManager.shared.currentQuestionTime = 0
    }
    
    func useSkipQuestionIfAvailable(_ method: () -> Void) {
        if GameManager.shared.helpQuantity > GameManager.shared.skipQuestionTimesUsed {
            GameManager.shared.skipQuestionTimesUsed += 1
            method()
        }
    }
    
    func useFreezeTimeIfAvailable() {
        if GameManager.shared.helpQuantity > GameManager.shared.freezeTimeTimesUsed && !GameManager.shared.freezeTimeInUse {
            GameManager.shared.freezeTimeTimesUsed += 1
            GameManager.shared.freezeTimeInUse = true
        }
    }
    
    func useHalfChoicesIfAvailable() {
        if GameManager.shared.helpQuantity > GameManager.shared.halfChoicesTimesUsed && !GameManager.shared.halfChoicesInUse {
            GameManager.shared.halfChoicesInUse = true
            GameManager.shared.halfChoicesTimesUsed += 1
            GameManager.shared.halfChoicesPicks = GameManager.shared.questionsList[testeCount].answersList.filter({ $0.isAnswer == false }).pick(2)
            answerCollection.reloadData()
        }
    }
    
    func checkIfPicked(_ answerNumber: Int) -> Bool {
        return GameManager.shared.halfChoicesPicks.map({ $0.answerText }).contains(GameManager.shared.questionsList[testeCount].answersList[answerNumber].answerText)
    }
    
    func unselectHelpsInUse() {
        if GameManager.shared.freezeTimeInUse { GameManager.shared.freezeTimeInUse = false }
        if GameManager.shared.halfChoicesInUse { GameManager.shared.halfChoicesInUse = false }
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
