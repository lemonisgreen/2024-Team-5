import Foundation

class finishService {
    
    static let shared = finishService()
    private init() {}
    
    var responceUserId: Int = 0
    
    func makeRequestBody(diaryList: [finishResponse]) -> Data? {
        do {
            let data = finishRequestBody(diaryList: diaryList)
            let jsonEncoder = JSONEncoder()
            let requestBody = try jsonEncoder.encode(data)
            return requestBody
        } catch {
            print(error)
            return nil
        }
    }
    
    func makeRequest(body: Data?) -> URLRequest {
        
        let url = URL(string:"localhost:8000/finish")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let header = ["Content-Type": "application/json"]
        header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    func PostExportData(diaryList: [finishResponse]) async throws -> finishResponse {
        do {
            guard let body = makeRequestBody(diaryList: diaryList)
            else {
                throw NetworkError.requstEncodingError
            }
            
            let request = self.makeRequest(body: body)
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(response)
                throw NetworkError.responseError
            }
            
            let decodedResponse = try JSONDecoder().decode(finishResponse.self, from: data)
//            self.responsePlaylistId = decodedResponse.result.playlistId
           
            return decodedResponse
            
        } catch {
            print("에러세요: \(error)")
            throw error
        }
    }
    

//    
//    private func configureHTTPError(errorCode: Int) -> Error {
//        return NetworkError(rawValue: errorCode)
//        ?? NetworkError.unknownError
//    }
}


