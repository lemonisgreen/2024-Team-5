//
//  CommentView.swift
//  WorkLife
//
//  Created by kim kanghyeok on 6/15/24.
//

import SwiftUI

struct CommentView: View {
    
    @State private var comments: [String] = []
    @State var text: String = ""
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(comments, id:\.self) { comment in
                    HStack{
                        Image("greenDot")
                            .resizable()
                            .frame(width: 17, height: 17)
                        ZStack{
                            Image("commentBox")
                                .resizable()
                                .frame(width: 337, height: 60)
                            Text(comment)
                        }
                    }
                }
            }
            Spacer()
        }
        .overlay(
            CommentWriteLayout(comments: $comments)
            , alignment: .bottom
        )
    }
}

fileprivate
struct Comment: Identifiable, Hashable {
    let id = UUID()
    let text: String
}

#Preview {
    CommentView()
}
