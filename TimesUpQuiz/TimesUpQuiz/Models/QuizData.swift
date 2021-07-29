class QuizData {
    
    var question: String,
        answersList: [(answerText: String, isAnswer: Bool)]
    
    init(question: String, answersList: [(answerText: String, isAnswer: Bool)]) {
        self.question = question
        self.answersList = answersList
    }
}
