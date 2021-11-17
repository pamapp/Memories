//
//  CellButtons.swift
//  memories
//
//  Created by Alina Potapova on 17.11.2021.
//

//!!!!!!!!!!!!!!!!!!!!!!move buttons

import SwiftUI

let buttonWidth: CGFloat = 90

enum CellButtons: Identifiable {
    case fav
    case delete
    
    var id: String {
        return "\(self)"
    }
}

struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    
    func getView(for image: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: buttonWidth, height: cellHeight)
            .foregroundColor(color)
            .overlay(
                Image(systemName: image)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            )
    }
    
    var body: some View {
        switch data {
        case .fav:
            getView(for: "star", color: Color.yellow)
        case .delete:
            getView(for: "xmark.bin", color: Color.red)
        }
    }
}

struct SwipeContainerCell: ViewModifier  {
    enum VisibleButton {
        case none
        case left
        case right
    }
    @State private var offset: CGFloat = 0
    @State private var oldOffset: CGFloat = 0
    @State private var visibleButton: VisibleButton = .none
    
    let leadingButtons: [CellButtons]
    let trailingButton: [CellButtons]
    let maxLeadingOffset: CGFloat
    let minTrailingOffset: CGFloat
    let onClick: (CellButtons) -> Void
    
    init(leadingButtons: [CellButtons], trailingButton: [CellButtons], onClick: @escaping (CellButtons) -> Void) {
        self.leadingButtons = leadingButtons
        self.trailingButton = trailingButton
        maxLeadingOffset = CGFloat(leadingButtons.count) * buttonWidth
        minTrailingOffset = CGFloat(trailingButton.count) * buttonWidth * -1
        self.onClick = onClick
    }
    
    func reset() {
        visibleButton = .none
        offset = 0
        oldOffset = 0
    }
    
    func body(content: Content) -> some View {
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        ForEach(leadingButtons) { buttonsData in
//                            Button(action: {
//                                withAnimation {
//                                    reset()
//                                }
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
//                                    onClick(buttonsData)
//                                }
//                            }, label: {
//                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
//                            })
//                        }
//                    }.offset(x: (-1 * maxLeadingOffset) + offset)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        ForEach(trailingButton) { buttonsData in
                            Button(action: {
                                withAnimation {
                                    reset()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { ///call once hide animation done
                                    onClick(buttonsData)
                                }
                            }, label: {
                                CellButtonView.init(data: buttonsData, cellHeight: proxy.size.height)
                            })
                            .padding(.leading, 5)
                        }
                    }
//                    .offset(x: (-1 * minTrailingOffset) + offset)
                }.frame(width: 330)
            }
            
            content
                .contentShape(RoundedRectangle(cornerRadius: 15)) ///otherwise swipe won't work in vacant area
                .offset(x: offset)
//                .background(.black)

                .gesture(DragGesture(minimumDistance: 15, coordinateSpace: .local)
                    .onChanged({ (value) in
                        let totalSlide = value.translation.width + oldOffset
                        if  (0...Int(maxLeadingOffset) ~= Int(totalSlide)) || (Int(minTrailingOffset)...0 ~= Int(totalSlide)) { //left to right slide
                            withAnimation{
                                offset = totalSlide
                            }
                        }
                    })
                    .onEnded({ value in
                        withAnimation {
                          if visibleButton == .left && value.translation.width < -20 { ///user dismisses left buttons
                            reset()
                         } else if  visibleButton == .right && value.translation.width > 20 { ///user dismisses right buttons
                            reset()
                         } else if offset > 10 || offset < -10 { ///scroller more then 50% show button
                            if offset > 0 {
                                visibleButton = .left
                                offset = maxLeadingOffset
                            } else {
                                visibleButton = .right
                                offset = minTrailingOffset
                            }
                            oldOffset = offset
                            ///Bonus Handling -> set action if user swipe more then x px
                        } else {
                            reset()
                        }
                     }
                 }))
        }
    }
}
