class BaseError: CustomStringConvertible, Error, @unchecked Sendable {
    let description: String
    let location: Location
    
    init(_ description: String, _ location: Location) {
        self.description = "Error in \(location): \(description)"
        self.location = location
    }
}
