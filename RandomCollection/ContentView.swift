//
//  ContentView.swift
//  RandomCollection
//
//  Created by Valeriy Nikolaev on 09/03/24.
//

import Foundation
import SwiftUI

struct SquareItem: View {
    @State var random: Int
    let currentIndex: Int
    @Binding var selectedIndex: Int
    @State private var isPressed = false

    var body: some View {
        Button(action: { }, label: {
            Text("\(random)")
                .frame(width: 48, height: 48)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue, lineWidth: 3)
                )
                .foregroundStyle(.white)
        })
        .animation(.bouncy, value: random)
        .buttonStyle(PressableButtonStyle())
        .onChange(of: selectedIndex) {
            if selectedIndex == currentIndex {
                random = Int.random(in: 0...99)
            }
        }
    }
}

struct CollectionView: View {
    @Binding var random: Int
    @State var squareRandomItem: Int = Int.zero

    private let rows = [GridItem(.fixed(100))]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0..<Int.random(in: 10...20), id: \.self) { index in
                    SquareItem(
                        random: Int.random(in: 0...99),
                        currentIndex: index,
                        selectedIndex: $squareRandomItem
                    )
                }
            }.onChange(of: random) {
                squareRandomItem = Int.random(in: 0...20)
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct ContentView: View {
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var randomValue = Int.zero
    @State private var nums = [Int](0...20)

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(nums, id: \.self ) { num in
                        CollectionView(random: $randomValue)
                            .frame(height: 70)
                            .onAppear() {
                                if num == nums.count - 1 {
                                    let extendedArray = [Int](nums.count...nums.count + 5)
                                    nums.append(contentsOf: extendedArray)
                                }
                            }
                    }.onReceive(timer) { _ in
                        randomValue = -1
                        randomValue = Int.random(in: 0...20)
                    }
                }
            }
        }
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
}
