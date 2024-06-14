//
//  DiaryInfo.swift
//  WorkLife
//
//  Created by kim kanghyeok on 6/15/24.
//

import Foundation

struct DiaryInfo: Codable {
    
    let color: Int
    let date: String
    let weather: Int
    let image: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        
        case color = "Color"
        case date = "Date"
        case weather = "Weather"
        case image = "Image"
        case content = "Content"
        
    }
}
