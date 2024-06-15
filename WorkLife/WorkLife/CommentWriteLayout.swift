//
//  CommentWriteLayout.swift
//  WorkLife
//
//  Created by kim kanghyeok on 6/15/24.
//

import SwiftUI

struct CommentWriteLayout: View {
    
    @Binding var comments: [String]
    @State private var text: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
            ZStack {
                TextField("칭찬을 입력해주세요", text: $text)
                    .padding()
                    .cornerRadius(20)
                    .focused($focused)
                    .onTapGesture { focused = true }
                    .frame(width: 360, height: 50)
                    .overlay{
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .stroke(lineWidth: 0.25)
                    }
                HStack{
                    Spacer()
                    Button {
                        comments.append(text)
                        text = ""
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(text.isEmpty ? .gray : .green)
                    }
                    .padding(.trailing)
                    .disabled(text.isEmpty)
                }
            }
            .padding()
            .background(Color(.systemBackground).shadow(radius: 5))
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.bottom, focused ? 0 : 0)
    }
}

fileprivate
struct Comment: Identifiable, Hashable {
    let id = UUID()
    let text: String
}

