import UIKit

class GameManager {
    
    static var shared = GameManager()
    
    private init() {}
    
    var questionsList: [QuizData] = [
        QuizData(
            question: "Qual é o Deus Egípcio do Sol?",
            answersList: [("Osíris", false), ("Mut", false), ("Anúbis", false), ("Amon-Rá", true)]),
        QuizData(
            question: "Quantos fusos horários existem na Rússia?",
            answersList: [("4", false), ("6", false), ("9", false), ("11", true)]),
        QuizData(question: "Qual é o animal nacional da Austrália?",
                 answersList: [("Canguru", true), ("Coala", false), ("Diabo da Tasmânia", false), ("Equidna", false)])
    ]
    
    let answersPerQuestion = 4,
        timeToFreeze = 0.5,
        helpQuantity = 1
    
    var timeLeft = 60,
        currentQuestionTime = 0,
        userScore = 0,
        rightAnswersCounter = 0,
        freezeTimeInUse = false,
        freezeTimeTimesUsed = 0,
        skipQuestionTimesUsed = 0,
        halfChoicesTimesUsed = 0
    
    func updateUserScoreAndTime(_ method: AnswerMethod) {
        switch method {
        case .rightAnswer:
            rightAnswersCounter += 1
            timeLeft += 11
            if currentQuestionTime < 5 {
                userScore += 10
            } else {
                userScore += currentQuestionTime < 14 ? 14 - currentQuestionTime : 1
            }
        case .wrongAnswer:
            timeLeft -= 4
        default:
            break
        }
        currentQuestionTime = 0
    }
    
    func useSkipQuestionIfAvailable(_ method: () -> Void) {
        if helpQuantity > skipQuestionTimesUsed {
            skipQuestionTimesUsed += 1
            method()
        }
    }
    
    func useFreezeTimeIfAvailable() {
        if helpQuantity > freezeTimeTimesUsed && !freezeTimeInUse {
            freezeTimeTimesUsed += 1
            freezeTimeInUse = true
        }
    }
    
    func unfreezeTimerFreezed() {
        if freezeTimeInUse {
            freezeTimeInUse = false
        }
    }
    
    func updateCounter(_ timerLabel: UILabel) {
        if(timeLeft > 0 && !freezeTimeInUse) {
            timerLabel.text = String(timeLeft)
            timeLeft -= 1
            currentQuestionTime += 1
        } else if timeLeft == 0 {
            timerLabel.text = "Acabou o tempo!"
        }
    }
}
