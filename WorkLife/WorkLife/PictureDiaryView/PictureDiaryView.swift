//
//  ContentView.swift
//  Team5Practice
//
//  Created by 신혜연 on 6/15/24.
//

import SwiftUI
import UIKit

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update
    }
}

struct PictureDiaryView: View {
    @State private var birth = Date.now
    @State private var selectedWeather = "sun.max"
    @State private var diaryText = ""
    @State private var showingDatePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    
    let weatherSymbols = ["sun.max", "cloud.sun", "umbrella", "snow"]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    var body: some View {
        VStack {
            // 일기 상단
            HStack {
                
                // 날짜
                HStack {
                    Text(dateFormatter.string(from: birth))
                    
                    Button(action: {
                        showingDatePicker.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                    }
                }
                .popover(isPresented: $showingDatePicker) {
                    VStack {
                        DatePicker("날짜 선택", selection: $birth, in: ...Date().addingTimeInterval(60*60*24*365*10), displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .labelsHidden()
                            .disabled(false)
                        
                        Button("확인") {
                            showingDatePicker.toggle()
                        }
                        .padding()
                    }
                    .padding()
                }
                
                Spacer()
                
                //날씨
                Picker(selection: $selectedWeather, label: Text("날씨")) {
                    ForEach(weatherSymbols, id: \.self) { symbol in
                        Image(systemName: symbol)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .tag(symbol)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 140)
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 20)
            
            
            //사진
            Button(action: {
                isShowingImagePicker.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 360, height: 200)
                        .foregroundColor(.secondary)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 360, height: 200)
                            .clipped()
                            .cornerRadius(10)
                    } else {
                        VStack {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                                .padding(.bottom, 2)
                            Text("사진 추가하기")
                                .font(.system(size: 14))
                                .colorMultiply(.black)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoPicker(selectedImage: $selectedImage)
            }
            .padding(.bottom, 10)
            
            //일기
            VStack(spacing: 4) {
                Text("일기 내용")
                    .padding(.trailing, 290)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.secondary)
                    TextEditor(text: $diaryText)
                        .frame(width: 360, height: 100)
                    //.border(Color.gray, width: 1)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PictureDiaryView()
    }
}
