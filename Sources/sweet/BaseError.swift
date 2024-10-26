class BaseError: CustomStringConvertible, Error {
    let location: Location
    let description: String
    
    init(_ location: Location, _ description: String) {
        self.location = location
        self.description = description
    }
}
