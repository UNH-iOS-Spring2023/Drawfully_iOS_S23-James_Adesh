//
//  Card.swift
//  Drawfully
//
//  Created by James on 5/8/23.
//

import SwiftUI

struct Card: View {
    
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let views: () -> AnyView
    
    init(
        width: CGFloat = CGFloat.infinity,
        height: CGFloat = 140,
        cornerRadius: CGFloat = 16,
        views: @escaping () -> AnyView
    ){
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.views = views
    }
    
    var body: some View {
        ZStack{
           RoundedRectangle(cornerRadius: cornerRadius)
               .fill(AppThemeColor)
               .shadow(radius: 3)
               
           VStack{
               views()
           }
       }
        .frame(width: width, height: height)
            .padding()
    }
}
