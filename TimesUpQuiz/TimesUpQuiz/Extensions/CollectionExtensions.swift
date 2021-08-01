extension Collection {
    func pick(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
