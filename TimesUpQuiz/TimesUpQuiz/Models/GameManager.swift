import Foundation

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
        timeToFreezeTime = 0.5
    
    var timeLeft = 60,
        currentQuestionTime = 1,
        userScore = 0,
        rightAnswersCounter = 0
    
    func updateUserScoreAndTime(_ method: AnswerMethod) {
        switch method {
        case .rightAnswer:
            rightAnswersCounter += 1
            timeLeft += 10
            if currentQuestionTime < 5 {
                userScore += 10
            } else {
                userScore += currentQuestionTime < 14 ? 14 - currentQuestionTime : 1
            }
        case .wrongAnswer:
            timeLeft -= 5
        }
        currentQuestionTime = 1
    }
}
