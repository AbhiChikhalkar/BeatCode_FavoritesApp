//
//  FlowLayout.swift
//  BeatCode_FavoritesApp
//
//  Created by Abhishek Chikhalkar on 06/07/25.
//

import SwiftUI

struct FlowLayout<Item: Hashable, ItemView: View>: View {
    let items: [Item]
    let spacing: CGFloat
    let content: (Item) -> ItemView
    
    @State private var totalHeight = CGFloat.zero
    
    init(items: [Item], spacing: CGFloat = 8, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero
            
            return ZStack(alignment: .topLeading) {
                ForEach(self.items, id: \.self) { item in
                    self.content(item)
                        .padding([.trailing, .bottom], self.spacing)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width) {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == self.items.last {
                                width = 0
                            } else {
                                width -= d.width + self.spacing
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { d in
                            let result = height
                            if item == self.items.last {
                                height = 0
                            }
                            return result
                        })
                        .accessibilityElement(children: .combine)
                }
            }
            .background(viewHeightReader($totalHeight))
            .accessibilityElement(children: .contain)
        }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
