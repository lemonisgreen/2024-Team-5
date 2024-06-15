import Foundation

struct finishResponse: Codable {
    
    let id: String
    let color: Int
    let date: String
    let weather: Int
    let image: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case color = "Color"
        case date = "Date"
        case weather = "Weather"
        case image = "Image"
        case content = "Content"
        
    }
}
