//
//  LoginView.swift
//  WorkLife
//
//  Created by 조세연 on 6/15/24.
//

import SwiftUI

struct LoginView: View {
    @State private var password = ""
    @State var colorCode : Int
    
    var body: some View {
        VStack{
            Image("img_icon")
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 16)
            
            Text("자랑일기")
//                .font(.OnboardingTitle)
            
            Text("시작 코드를 입력해 주세요")
//                .font(.OnboardingBody)
                .padding(.top, 55)
            
            SecureField("", text: $password, onCommit: performLogin)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .frame(width: 138)
                           .padding()
                  
            
        }
    }
    
    func postLogin() async {
        do {
            colorCode = try await LoginService.shared.PostLoginData(user_id: password)
            print("에러안뜸")
        } catch {
            print("에러 발생: \(error)")
        }
    }
    
    
    func performLogin() {
        Task {
            await postLogin()
        }
    }
    
    
}

//#Preview {
//    LoginView(colorCode: Int)
//}
