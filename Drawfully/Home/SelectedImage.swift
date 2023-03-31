//
//  SelectedImage.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 3/31/23.
//

import SwiftUI

struct SelectedImage: View {
    var img: UIImage
    var body: some View {

        ZStack {
            Color.black // Black background
            Image(uiImage: img)
                .resizable()
                .scaledToFit()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SelectedImage_Previews: PreviewProvider {
    static var previews: some View {
        SelectedImage(img: UIImage(imageLiteralResourceName: "sample_drawing"))
    }
}
