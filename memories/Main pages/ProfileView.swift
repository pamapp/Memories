//
//  ProfileView.swift
//  memories
//
//  Created by Alina Potapova on 28.04.2022.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var viewLocationModel: LocationSelectView.LocationModel

    @ObservedObject var viewFolderModel: FoldersView.FolderModel
    
    @ObservedObject var viewMemoryModel: MemoriesView.MemoryModel
    
    @State var date = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainBackgroundColor
                    .ignoresSafeArea()
                VStack(spacing: 40) {
                    VStack(spacing: 10) {
                        Image("test_photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 125, height: 125)
                            .clipped()
                            .mask(Circle())
                        
                        Text("Alina")
                            .font(.title2)
                    }.padding(.top, 50)
                    
                    VStack(alignment: .leading) {
                        Text("Activity".uppercased())
                            .padding(.horizontal, 40)
                        activityView
                            .padding(.horizontal, 25)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Statistic".uppercased())
                            .padding(.horizontal, 40)
                        
                        HStack(alignment: .center) {
                            cellStatusView(iconName: "cloud.fill",
                                           statNumber: viewFolderModel.getMemoriesNum(),
                                           statText: memoriesNum(viewFolderModel.getMemoriesNum()))
                                .padding(.leading, 25)
                                .padding(.trailing, 5)
                            cellStatusView(iconName: "map.fill",
                                           statNumber: viewLocationModel.getPlacesNumder(),
                                           statText: placesNum(viewLocationModel.getPlacesNumder()))
                                .padding(.leading, 5)
                                .padding(.trailing, 25)
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }

    func chartHeigth(value: Int) -> Double {
        let maxValue: Int = self.viewMemoryModel.memoriesNumberByDate(month: date.get(.month)).max()!
        if maxValue == 0 {
            return 0
        }
        return Double(150 * value / maxValue)
    }
    
    func memoriesNum(_ value: Int) -> String {
        if value == 1 {
            return "memory"
        } else if value > 1 || value == 0{
            return "memories"
        }
        return ""
    }
    
    func placesNum(_ value: Int) -> String {
        if value == 1 {
            return "place"
        } else if value > 1 || value == 0 {
            return "places"
        }
        return ""
    }
    
    func cellStatusView(iconName: String, statNumber: Int, statText: String) -> some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.cellColor)
                .frame(width: geo.size.width, height: geo.size.height / 1.8)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Image(systemName: iconName)
                                .font(.system(size: 25))
                                .foregroundColor(.tabButtonColor)
                            Spacer()
                            HStack {
                                Text("\(statNumber)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                Text(statText)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }.padding()
                        Spacer()
                    }
                )
        }
    }
    
    var activityView: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.cellColor)
                .frame(width: geo.size.width, height: geo.size.height + 10)
                .overlay(
                    VStack {
                        Spacer()
                        HStack(spacing: 18) {
                            ForEach(self.viewMemoryModel.memoriesNumberByDate(month: date.get(.month)), id: \.self) { number in
                                VStack {
                                    NumberBar(month: number, height: chartHeigth(value: number))
                                }
                            }
                        }
                        HStack(spacing: 27) {
                            ForEach(self.viewMemoryModel.monthToStringByDate(month: date.get(.month)), id: \.self) { title in
                                Text(title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                )
        }
    }
}

struct NumberBar: View {
    @State var showMemoriesNum: Bool = false
    @State var month: Int
    @State var height: Double
    
    var body: some View {
        ZStack {
            if showMemoriesNum {
                VStack {
                    memoriesNumDescription(month)
                    Spacer()
                }.offset(y: -12)
            }
            VStack {
                Spacer()
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .frame(width: 8, height: 150)
                        .cornerRadius(5)
                        .foregroundColor(.mainBackgroundColor)
          
                    Rectangle()
                        .frame(width: 8, height: height)
                        .cornerRadius(5)
                        .foregroundColor(.tabButtonColor)
                }
            }
            
        }
        .padding(.vertical, 3)
        .frame(width: 35, height: 175)
        .onTapGesture {
            self.showMemoriesNum.toggle()
        }
    }
    
    func memoriesNumDescription(_ number: Int) -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 7)
                .frame(width: 35, height: 20, alignment: .center)
                .foregroundColor(.tabButtonColor)
                .overlay(
                    Text("\(number)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.mainBackgroundColor)
                )
            Triangle()
                .foregroundColor(.tabButtonColor)
                .frame(width: 10, height: 7)
                .rotationEffect(.degrees(180))
        }
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}
