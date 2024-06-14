import SwiftUI

func getDiary(diaryName: String) {
    let session = URLSession(configuration: .default)
    guard let url = URL(String: "API") else { return }
    
    session.dataTask(with: url) { data, response, error in
        
        guard let data = data, error == nil else { return }
        
        let decoder = JSONDecoder()
        guard let diary = try? decoder.decode(Diary.self, from: data) else { return }
        
        DispatchQueue.main.async {
            
        }
    }.resume()
}
