import Foundation

enum ServicedData<T, Er: Error> {
    case uninitialized
    case data(T)
    case inProgress(Task<T, Er>)
}
