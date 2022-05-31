//
//  MemoryEditView.swift
//  memories
//
//  Created by Alina Potapova on 14.08.2021.
//

import SwiftUI

struct MemoryEditView: View {
    @Environment(\.presentationMode) var isPresented
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var memoryText: String
    @State var memoryTitle: String
    @State var placeText: String
    @State var date: Date
    @State var selectedColor: Color
    @State var place: Location
    
    @State var longitude: Double
    @State var latitude: Double
    @State var locationName: String
    
    var folder: Folder
    var characterLimit = 20
    
    @State var isShowPicker: Bool = false
    @State var showDatePicker: Bool = false
    @State var isFolderChange: Bool = false

    @State var isShowMap: Bool = false
    
    @State private var inputImage: UIImage?
    @State var image: Image?
    
    @ObservedObject var viewFolderModel: FoldersView.FolderModel
    @ObservedObject var viewModel: MemoriesView.MemoryModel
    @ObservedObject var viewLocationModel: LocationSelectView.LocationModel
    
    var pickerColors: [Color] = [
        .cellColor,
        .pickerGreen,
        .pickerBlue,
        .pickerPink,
        .pickerCirclePurple,
        .pickerRed
    ]
    
    var memory: Memory
    
    private enum Strings {
        static let title = "Title..."
        static let title_footnote = "Enter memory title"
        static let date = "date"
        static let date_footnote = "Select memory date"
        static let location = "location"
        static let location_footnote = "Select memory location"
        static let folder = "folder"
        static let folder_footnote = "Select folder"
        static let theme_color = "theme color"
        static let theme_color_footnote = "Select theme color"
        static let text = "Text here..."
        static let photo = "Photo"
        static let photo_footnote = "Select memory photo"
    }

    let imageHeight = UIScreen.main.bounds.height / 7
    let sectionWidth = UIScreen.main.bounds.width / 1.1
    let buttonSelectWidth = UIScreen.main.bounds.width / 2
    
    @State private var showMemory = true

    @State var folderIndex: Int = 0

    var body: some View {
        ZStack {
            Color.mainBackgroundColor
                .ignoresSafeArea()
            VStack {
                HStack {
                    cancelToolBar
                    Spacer()
                    doneToolBar
                }
                
                VStack(alignment: showMemory ? .leading : .trailing, spacing: 1) {
                    Divider()
                    HStack(spacing: 0) {
                        memoryTextButton
                        Divider().frame(height: 45)
                        memoryInfoButton
                    }
                    ZStack(alignment: showMemory ? .leading : .trailing) {
                        Divider()
                        Rectangle()
                            .fill(Color.tabButtonColor)
                            .frame(width: buttonSelectWidth, height: 1)
                        
                    }
                }
                if !self.showMemory {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 8.3)
                                .overlay(
                                    HStack() {
                                        TextField(Strings.title, text: $memoryTitle)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(.white)
                                            .accentColor(.white)
                                            .font(.montserrat(18))
                                            .padding(.leading, 20)
                                            .onReceive(memoryTitle.publisher.collect()) {
                                                let s = String($0.prefix(characterLimit))
                                                if memoryTitle != s {
                                                    memoryTitle = s
                                                }
                                             }
                                        Spacer()
                                    }
                                )
                            Text(Strings.title_footnote)
                                .listFootnoteTextStyle()
                        }
                        
                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 8.3)
                                .overlay(
                                    HStack(alignment: .center) {
                                        Text(Strings.date.uppercased())
                                            .font(.montserratBold(16))
                                            .padding(.leading, 20)
                                        Spacer()

                                        Button {
                                            self.endEditing()
                                            self.showDatePicker.toggle()
                                        } label: {
                                            Text(timeFormat)
                                                .font(.montserrat(18))
                                                .foregroundColor(.secondary)
                                        }.padding(.trailing, 18)
                                    }
                                )
                            Text(Strings.date_footnote)
                                .listFootnoteTextStyle()
                        }

                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 8.3)
                                .overlay(
                                    HStack() {
                                        Text(Strings.location.uppercased())
                                            .font(.montserratBold(16))
                                            .padding(.leading, 20)

                                        Spacer()

                                        Button {
                                            self.isShowMap.toggle()
                                        } label: {
                                            Text(locationName == "" ? "Select" : "\(locationName)")
                                                .font(.montserrat(18))
                                                .foregroundColor(.secondary)
                                        }.padding(.trailing, 18)
                                        .sheet(isPresented: $isShowMap) {
                                            LocationSelectView(
                                                longitude: $longitude,
                                                latitude: $latitude,
                                                locationName: $locationName
                                            )
                                        }

                                    }
                                )
                            Text(Strings.location_footnote)
                                .listFootnoteTextStyle()
                        }

                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 8.3)
                                .overlay(
                                    HStack() {
                                        Text(Strings.folder.uppercased())
                                            .font(.montserratBold(16))
                                            .padding(.leading, 20)
                                        Spacer()
                                        Menu {
                                            ForEach(Array(viewFolderModel.folders.enumerated()), id: \.element) { index, selectFolder in
                                                Button {
                                                    print("select folder")
                                                    self.folderIndex = index
                                                    self.isFolderChange = true
                                                } label: {
                                                    HStack {
                                                        Text(selectFolder.safeName)
                                                            .font(.montserrat(18))
                                                        if selectFolder.isFavorite {
                                                            Image(systemName: "star.circle.fill")
                                                                .font(.system(size: 5))
                                                                .foregroundColor(.cellColor)
                                                        }
                                                    }
                                                }
                                            }
                                        } label: {
                                            HStack(spacing: 5) {
                                                Text(viewFolderModel.folders[folderIndex].safeName)
                                                    .font(.montserrat(18))
                                                    .foregroundColor(.secondary)
                                            }.padding(.trailing, 18)
                                        }
                                    }
                                )
                            Text(Strings.folder_footnote)
                                .listFootnoteTextStyle()
                        }
                        
                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 5)
                                .overlay(
                                    HStack() {
                                        Text(Strings.photo.uppercased())
                                            .font(.montserratBold(16))
                                            .padding(.leading, 20)
                                        Spacer()
                                        Button {
                                            self.endEditing()
                                            self.isShowPicker.toggle()
                                        } label: {
                                            image?
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: imageHeight / 2.5)
                                                .cornerRadius(10)
                                        }.padding(.trailing, 18)
                                        .sheet(isPresented: $isShowPicker, onDismiss: loadImage) {
                                            ImagePicker(image: self.$inputImage)
                                                .accentColor(.white)
                                        }
                                    }
                                )
                            Text(Strings.photo_footnote)
                                .listFootnoteTextStyle()
                        }
                        
                        VStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.tabColor)
                                .frame(width: sectionWidth, height: sectionWidth / 4.1)
                                .overlay(
                                    VStack {
                                        HStack() {
                                            Text(Strings.theme_color.uppercased())
                                                .font(.montserratBold(16))
                                                .padding(.leading, 20)
                                            Spacer()
                                        }
                                        HStack(alignment: .top) {
                                            ForEach(pickerColors, id: \.self) { color in
                                                Button(action: {
                                                    self.selectedColor = color
                                                }, label: {
                                                    ZStack {
                                                        Circle()
                                                            .foregroundColor(selectedColor == color ? color : .cellColor)
                                                            .frame(width: 35, height: 35)
                                                        Circle()
                                                            .foregroundColor(.mainBackgroundColor)
                                                            .frame(width: 31, height: 31)
                                                        Circle()
                                                            .foregroundColor(color)
                                                            .frame(width: 25, height: 25)
                                                    }
                                                })
                                            }
                                            Spacer()
                                        }.padding(.leading, 20)
                                    }
                                )
                            Text(Strings.theme_color_footnote)
                                .listFootnoteTextStyle()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .keyboardAdaptive()
                }
                
                if self.showMemory{
                    ZStack {
                        if memoryText.isEmpty {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(Strings.text)
                                        .foregroundColor(.secondary)
                                        .font(.montserrat(18))
                                        .padding(.leading, 15)
                                        .padding(.top, 8)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                        VStack(alignment: .leading) {
                            TextEditor(text: $memoryText)
                                .foregroundColor(.white)
                                .font(.montserrat(17))
                                .lineSpacing(10)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 55)
                                .accentColor(.white)
                                .onAppear() {
                                   UITextView.appearance().backgroundColor = .clear
                                 }
                            Spacer()
                        }
                    }
                }
                Spacer()
            } //VStack
            
            .navigationBarTitle("")
            .navigationBarHidden(true)

            if self.showDatePicker {
                ZStack {
                    Color.mainBackgroundColor
                        .ignoresSafeArea()
                    VStack() {
                        DatePicker("Prompt Text", selection: $date, displayedComponents: [.date])
                            .accentColor(.tabButtonColor)
                            .font(.montserratBold(16))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.cellColor)
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(width: 350, height: 400)

                        Button {
                            self.showDatePicker.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.tabButtonColor)
                                .frame(width: 120, height: 50)
                                .overlay(
                                    Text("Save")
                                        .foregroundColor(.white)
                                        .font(.montserratBold(18))

                                )
                        }
                    }
                }.navigationBarHidden(true)
            }
        }
    }
    
    var timeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self.date)
    }
    
    private var doneToolBar: some View {
        Button(action: {
            if !showMemory {
                self.endEditing()
                self.viewModel.editMemory(
                    memory: memory,
                    text: memoryText,
                    title: memoryTitle,
                    place: self.viewLocationModel.changeLocationCoordinates(location: place, name: locationName, longitude: longitude, latitude: latitude),
                    date: date,
                    folder: isFolderChange ? viewFolderModel.folders[folderIndex] : folder,
                    color: intByColor(color: selectedColor),
                    image: inputImage
                )
                self.isPresented.wrappedValue.dismiss()
            } else {
                self.endEditing()
                self.showMemory = false
            }
        }, label: {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.tabButtonColor)
                .frame(width: 100, height: 32)
                .overlay(
                    Text(showMemory ? "Next" : "Save")
                        .foregroundColor(.white)
                        .font(.montserratBold(16))
                )
        }).padding(.trailing, 20)
    }
    
    private var cancelToolBar: some View {
        Button() {
            self.isPresented.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(.montserratBold(16))

            }
        }.padding(.leading, 20)
    }

    private var memoryTextButton: some View {
        Button(action: {
            self.showMemory = true
        }, label: {
            VStack {
                Text("Memory")
                    .foregroundColor(showMemory ? .tabButtonColor : .white)
                    .font(.montserratBold(16))
            }.frame(width: buttonSelectWidth, height: 32)
        })
    }
    
    private var memoryInfoButton: some View {
        Button(action: {
            self.showMemory = false
        }, label: {
            VStack {
                Text("Info")
                    .foregroundColor(showMemory ? .white : .tabButtonColor)
                    .font(.montserratBold(16))
            }.frame(width: buttonSelectWidth, height: 32)
        })
    }

    private func intByColor(color: Color) -> Int {
        switch color {
        case .cellColor: return 0
        case .pickerGreen: return 1
        case .pickerBlue: return 2
        case .pickerPink: return 3
        case .pickerCirclePurple: return 4
        case .pickerRed: return 5
        default:
            return 0
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func savesImage(Name: String, inputImage: UIImage?) {
        let fileName = helper.getDocumentsDirectory().appendingPathComponent(Name)
        do {
            if let jpegData = inputImage?.jpegData(compressionQuality: 0.8) {
                try jpegData.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
            }
        } catch {
            print("Unable to save image")
        }
     }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
}
