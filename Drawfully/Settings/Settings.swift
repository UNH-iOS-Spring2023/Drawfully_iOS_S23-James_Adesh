//
//  Settings.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 2/17/23.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        
        //Add title bar to Settings Tab
            VStack{
                
                HStack{
                    
                    Spacer()
                    Text("Settings").font(.title).fontWeight(.bold).padding(.trailing, 0.0).multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                }.padding()
                
                Spacer()
                
            }
            }
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
