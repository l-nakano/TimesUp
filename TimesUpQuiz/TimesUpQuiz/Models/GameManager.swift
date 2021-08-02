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
        QuizData(
            question: "Qual país tem mais ilhas no mundo?",
            answersList: [("Japão", false), ("Ilhas Salomão", false), ("Canadá", false), ("Suécia", true)]),
        QuizData(
            question: "Qual o menor país do mundo?",
            answersList: [("Mônaco", false), ("Vaticano", true), ("San Marino", false), ("Malta", false)]),
        QuizData(
            question: "Qual o ponto mais baixo do planeta Terra?",
            answersList: [("Polo Norte", false), ("Fossa das Marianas", true), ("Fenda de Bentley", false), ("Gruta de Krubera", false)]),
        QuizData(
            question: "Qual o rio mais longo do mundo?",
            answersList: [("Nilo", true), ("Amazonas", false), ("Yangtze", false), ("Congo", false)]),
        QuizData(
            question: "De quem é a frase \"Penso, logo existo.\"?",
            answersList: [("Platão", false), ("Francis Bacon", false), ("Descartes", true), ("Sócrates", false)]),
        QuizData(
            question: "Em que período o fogo foi descoberto?",
            answersList: [("Neolítico", false), ("Paleolítico", true), ("Idade Média", false), ("Pedra Polida", false)]),
        QuizData(
            question: "Qual a montanha mais alta do Brasil?",
            answersList: [("Pico da Neblina", true), ("Pico Paraná", false), ("Monte Roraima", false), ("Pica da Bandeira", false)]),
        QuizData(
            question: "Qual país é transcontinental?",
            answersList: [("Filipinas", false), ("Rússia", true), ("Groelândia", false), ("Tanzânia", false)]),
        QuizData(
            question: "Quem foi o primeiro homem a pisar na lua?",
            answersList: [("Yuri Gagarin", false), ("Charles Conrad", false), ("Charles Duke", false), ("Neil Armstrong", true)]),
        QuizData(
            question: "Qual animal amamentou Rômulo e Remo?",
            answersList: [("Cabra", false), ("Vaca", false), ("Ovelha", false), ("Loba", true)]),
        QuizData(
            question: "Quem pintou o teto da Capela Sistina?",
            answersList: [("Michelangelo", true), ("da Vinci", false), ("Botticelli", false), ("Donatello", false)]),
        QuizData(
            question: "Qual o menor planeta do sistema solar?",
            answersList: [("Mercúrio", true), ("Júpiter", false), ("Marte", false), ("Saturno", false)])
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
        halfChoicesPicks: ArraySlice<(answerText: String, isAnswer: Bool)>!,
        userWin = false
}
