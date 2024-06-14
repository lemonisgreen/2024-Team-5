//
//  CommunityView.swift
//  WorkLife
//
//  Created by kim kanghyeok on 6/15/24.
//

import SwiftUI

struct CommunityView: View {
    //    @Binding var selectColor: Int
    @State private var selectedColor: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("자랑 일기")
                    .frame(width: 64, height: 21)
                //            Image("")
                //            List {
                //                Text("1")
                //                Text("2")
                //            }.listStyle(.sidebar)
                Spacer()
                Button(action: {
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                        .frame(width: 21, height: 21)
                })
            }
            .padding()
            HStack {
                ScrollView(.vertical) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 371, height: 317)
                            .foregroundStyle(selectedColor == 0 ? Color(hex:"F5EDC5") : Color(hex:"C2DDB5"))
                        VStack {
                            HStack {
                                Text("Date")
                                Spacer()
                                Text("날씨")
                            }
                            .padding(20)
                            Spacer()
                            Text("Contents")
                        }
                        .padding()
                        .frame(width: 371, height: 317)
                        
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    CommunityView()
}
