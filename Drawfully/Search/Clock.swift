//
//  Timer.swift
//  Drawfully
//
//  Created by James on 5/8/23.
//

import SwiftUI
import SwiftClockUI

struct Clock: View {
    
    // current time
    @State private var date = Date()
    
    // display strings
    let time: String
    let theme: String
    let subject: String
    let style: String
    
    init(
        time: String = "Time",
        theme: String = "Theme",
        subject: String = "Subject",
        style: String = "Style"
    ){
        
        // if the displays are the default value, don't display anything
        if theme == "Theme" {
            self.theme = ""
        }
        else {
            self.theme = theme
        }
        
        if time == "Time" {
            self.time = ""
        }
        else {
            self.time = time
        }
        
        if subject == "Subject" {
            self.subject = ""
        }
        else {
            self.subject = subject
        }
        
        if style == "Style" {
            self.style = ""
        }
        else {
            self.style = style
        }
    }
    
    var body: some View {
        
        // these views are for the card class
        let themeCard = VStack {
            Spacer()
            
            Text("Subject:")
                .font(.title2)
                .foregroundColor(AppTextColor)
            
            Text("\(theme)")
                .font(.body)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
        
        let timeCard = VStack {
            Spacer()
            
            Text("Time:")
                .font(.title2)
                .foregroundColor(AppTextColor)
            
            Text("\(time)")
                .font(.body)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
        
        let subjectCard = VStack {
            Spacer()
            
            Text("Subject:")
                .font(.title2)
                .foregroundColor(AppTextColor)
            
            Text("\(subject)")
                .font(.body)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
        
        let styleCard = VStack {
            Spacer()
            
            Text("Style:")
                .font(.title2)
                .foregroundColor(AppTextColor)
            
            Text("\(style)")
                .font(.body)
                .foregroundColor(AppTextColor)
            
            Spacer()
        }
        
        // 2x2 grid of cards
        HStack {
            Card(width: 150, height: 100, cornerRadius: 16, views:{ AnyView(timeCard) })
                .padding(1)
                .frame(alignment: .leading)
            
            Card(width: 150, height: 100, cornerRadius: 16, views:{ AnyView(subjectCard) })
                .padding(1)
                .frame(alignment: .trailing)
        }
        
        HStack{
            Card(width: 150, height: 100, cornerRadius: 16, views:{ AnyView(themeCard) })
                .padding(1)
                .frame(alignment: .leading)
            
            Card(width: 150, height: 100, cornerRadius: 16, views:{ AnyView(styleCard) })
                .padding(1)
                .frame(alignment: .leading)
            
        }
        
        // shoow a clock, based on SwiftClockUI
        ClockView().environment(\.clockDate, $date)
            .padding()
    }
}
