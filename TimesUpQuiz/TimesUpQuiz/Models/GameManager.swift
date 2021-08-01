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
        QuizData(
            question: "Qual é o animal nacional da Austrália?",
            answersList: [("Canguru", true), ("Coala", false), ("Diabo da Tasmânia", false), ("Equidna", false)]),
        
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
        halfChoicesInUse = false,
        halfChoicesTimesUsed = 0,
        halfChoicesPicks: ArraySlice<(answerText: String, isAnswer: Bool)>!
}
