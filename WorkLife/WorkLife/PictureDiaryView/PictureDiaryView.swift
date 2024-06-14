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
    var sourceType: UIImagePickerController.SourceType
    
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
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update
    }
}

//struct CharacterCountView: View {
//    let maxCount: Int
//    @Binding var currentCount: Int
//
//    var body: some View {
//        Text("\(currentCount)/\(maxCount)")
//            .foregroundColor(currentCount > maxCount ? .red : .secondary)
//            .font(.caption)
//            .padding(6)
//            .background(Color.white)
//            .cornerRadius(8)
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(currentCount > maxCount ? Color.red : Color.secondary, lineWidth: 1)
//            )
//            .offset(x: -10, y: -10) // 오른쪽 하단에 위치하도록 offset 적용
//            .animation(.default)
//    }
//}

struct PictureDiaryView: View {
    @State private var birth = Date.now
    @State private var selectedWeather = "sun.max"
    @State private var diaryText = ""
    @State private var showingDatePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isShowingCameraPicker = false
    @State private var showImageSourceSelection = false
    @State private var characterCount = 0
    
    let maxDiaryLength = 100 // 최대 입력 길이
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
                HStack(spacing: 2) {
                    Text(dateFormatter.string(from: birth))
                    
                    Button(action: {
                        showingDatePicker.toggle()
                    }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.blue)
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
            
            // 사진 추가하기
            Button(action: {
                showImageSourceSelection = true
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(lineWidth: 1))
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
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                                .padding(.bottom, 2)
                            Text("사진 추가하기")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .actionSheet(isPresented: $showImageSourceSelection) {
                ActionSheet(title: Text("사진 추가하기"), buttons: [
                    .default(Text("사진 앨범에서 선택"), action: {
                        isShowingImagePicker.toggle()
                    }),
                    .default(Text("카메라로 사진 찍기"), action: {
                        isShowingCameraPicker.toggle()
                    }),
                    .cancel()
                ])
            }
            .sheet(isPresented: $isShowingImagePicker) {
                PhotoPicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
            }
            .sheet(isPresented: $isShowingCameraPicker) {
                PhotoPicker(selectedImage: $selectedImage, sourceType: .camera)
            }
            .padding(.bottom, 5)
            
            //일기
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: StrokeStyle())
                    .frame(width: 360, height: 130)
                    .foregroundColor(.secondary)
                
                TextField("자랑하고 싶은 내용을 작성하세요", text: $diaryText, axis: .vertical)
                    .padding(.leading, 5)
                    .frame(width: 350, height: 110)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .onChange(of: diaryText) { newValue in
                        if newValue.count > maxDiaryLength {
                            diaryText = String(newValue.prefix(maxDiaryLength))
                        }
                        characterCount = diaryText.count
                    }
            }
            Text("\(characterCount)/\(maxDiaryLength)")
                .foregroundColor(characterCount >= maxDiaryLength ? .red : .secondary)
                .font(.caption)
                .padding(6)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(characterCount >= maxDiaryLength ? Color.red : Color.secondary, lineWidth: 1)
                )
            
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
