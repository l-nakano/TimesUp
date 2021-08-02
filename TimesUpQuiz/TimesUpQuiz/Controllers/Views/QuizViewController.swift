import UIKit

let reuseAnswerIdentifier = "Answer"
let reuseQuestionIdentifier = "Question"

class QuizViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var answerCollection: UICollectionView!
    @IBOutlet weak var helpsView: UIView!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var rightAnswersLabel: UILabel!
    @IBOutlet weak var userScoreImage: UIImageView!
    @IBOutlet weak var rightAnswersImage: UIImageView!
    @IBOutlet weak var userTimeImage: UIImageView!
    @IBOutlet weak var freezeImage: UIImageView!
    @IBOutlet weak var skipImage: UIImageView!
    @IBOutlet weak var halfImage: UIImageView!
    @IBOutlet weak var hudStackView: UIStackView!
    @IBOutlet weak var quizContentStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var currentQuestion = 0
    var testeFreeze = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        answerCollection.dataSource = self
        answerCollection.delegate = self
        
        initializeViewsAndConstraints()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    // Change Header and Cell content
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseAnswerIdentifier, for: indexPath) as? AnswerCollectionViewCell {
            
            let currentText = GameManager.shared.questionsList[currentQuestion].answersList[indexPath.item].answerText
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
            questionHeader.configure(text: GameManager.shared.questionsList[currentQuestion].question, color: UIColor(named: "CardsColor")!, size: headerSize)
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
        return UIEdgeInsets(top: collectionView.frame.width * 0.45, left: 0, bottom: 0, right: 0)
    }
    
    func initializeViewsAndConstraints() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        quizContentStackView.spacing = screenSize.width * 0.1
        
        userTimeImage.widthAnchor.constraint(equalToConstant: screenSize.width * 0.075).isActive = true
        userScoreImage.widthAnchor.constraint(equalToConstant: screenSize.width * 0.075).isActive = true
        rightAnswersImage.widthAnchor.constraint(equalToConstant: screenSize.width * 0.07).isActive = true
        
        timerLabel.text = String(GameManager.shared.timeLeft)
        rightAnswersLabel.text = String(GameManager.shared.rightAnswersCounter)
        userScoreLabel.text = String(GameManager.shared.userScore)
        
        helpsView.layer.cornerRadius = 20.0
        helpsView.layer.borderWidth = 0.5
        helpsView.layer.borderColor = UIColor.black.cgColor
        helpsView.layer.masksToBounds = true
        
        hudStackView.spacing = hudStackView.frame.width / 7
        
        timerLabel.font = UIFont(name: "Anton-Regular", size: 25)
        userScoreLabel.font = UIFont(name: "Anton-Regular", size: 25)
        rightAnswersLabel.font = UIFont(name: "Anton-Regular", size: 25)
    }
    
    // Item selected
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GameManager.shared.questionsList[currentQuestion].answersList[indexPath.item].isAnswer {
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
        rightAnswersLabel.text = String(GameManager.shared.rightAnswersCounter)
        userScoreLabel.text = String(GameManager.shared.userScore)
        currentQuestion += 1
        if currentQuestion == GameManager.shared.questionsList.count {
            GameManager.shared.userWin = true
            if let vc = storyboard?.instantiateViewController(withIdentifier: "EndGame") {
                show(vc, sender: self)
            }
        } else {
            answerCollection.reloadData()
        }
    }
    
    // Timer counter
    
    @objc func updateCounter() {
        if GameManager.shared.timeLeft > 0 && !GameManager.shared.freezeTimeInUse && !GameManager.shared.userWin {
            timerLabel.text = String(GameManager.shared.timeLeft)
            GameManager.shared.timeLeft -= 1
            GameManager.shared.currentQuestionTime += 1
        } else if GameManager.shared.timeLeft == 0 {
            GameManager.shared.timeLeft -= 1
            timerLabel.text = "0"
            if let vc = storyboard?.instantiateViewController(withIdentifier: "EndGame") {
                show(vc, sender: self)
            }
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
            GameManager.shared.timeLeft += 6
            if GameManager.shared.currentQuestionTime < 5 {
                GameManager.shared.userScore += 10
            } else {
                GameManager.shared.userScore += GameManager.shared.currentQuestionTime < 14 ? 14 - GameManager.shared.currentQuestionTime : 1
            }
        case .wrongAnswer:
            GameManager.shared.timeLeft -= GameManager.shared.timeLeft - 4 > 0 ? 4 : GameManager.shared.timeLeft
        default:
            break
        }
        GameManager.shared.currentQuestionTime = 0
    }
    
    func useSkipQuestionIfAvailable(_ method: () -> Void) {
        if GameManager.shared.helpQuantity > GameManager.shared.skipQuestionTimesUsed {
            GameManager.shared.skipQuestionTimesUsed += 1
            method()
            if GameManager.shared.helpQuantity == GameManager.shared.skipQuestionTimesUsed {
                skipImage.changeImageWithAnimation(UIImage(named: "UsedSkipIcon")!)
            }
        }
    }
    
    func useFreezeTimeIfAvailable() {
        if GameManager.shared.helpQuantity > GameManager.shared.freezeTimeTimesUsed && !GameManager.shared.freezeTimeInUse {
            GameManager.shared.freezeTimeTimesUsed += 1
            GameManager.shared.freezeTimeInUse = true
            if GameManager.shared.helpQuantity == GameManager.shared.freezeTimeTimesUsed {
                freezeImage.changeImageWithAnimation(UIImage(named: "UsedFreezeIcon")!)
            }
        }
    }
    
    func useHalfChoicesIfAvailable() {
        if GameManager.shared.helpQuantity > GameManager.shared.halfChoicesTimesUsed && !GameManager.shared.halfChoicesInUse {
            GameManager.shared.halfChoicesInUse = true
            GameManager.shared.halfChoicesTimesUsed += 1
            GameManager.shared.halfChoicesPicks = GameManager.shared.questionsList[currentQuestion].answersList.filter({ $0.isAnswer == false }).pick(2)
            answerCollection.reloadData()
            if GameManager.shared.helpQuantity == GameManager.shared.halfChoicesTimesUsed {
                halfImage.changeImageWithAnimation(UIImage(named: "UsedHalfIcon")!)
            }
        }
    }
    
    func checkIfPicked(_ answerNumber: Int) -> Bool {
        return GameManager.shared.halfChoicesPicks.map({ $0.answerText }).contains(GameManager.shared.questionsList[currentQuestion].answersList[answerNumber].answerText)
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
