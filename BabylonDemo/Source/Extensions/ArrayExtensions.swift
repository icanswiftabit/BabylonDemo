import Foundation

extension Array where Element: Storeable {

    // Returns an array of objects with unique id. Assuming the lest object with certain ID is the most up to date
    func lastUnique() -> [Element] {
        var elementsForReturn = [Element]()
        reversed().forEach { element in
            if !elementsForReturn.contains(where: { $0.id == element.id }) {
                elementsForReturn.append(element)
            }
        }
        return elementsForReturn
    }
}
