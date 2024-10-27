class BaseError: CustomStringConvertible, Error {
    let description: String
    let location: Location
    
    init(_ description: String, _ location: Location) {
        self.description = description
        self.location = location
    }
}
