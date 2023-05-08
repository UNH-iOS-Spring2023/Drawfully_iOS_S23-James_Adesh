//
//  Timer.swift
//  Drawfully
//
//  Created by James on 5/8/23.
//

import SwiftUI
import SwiftClockUI

struct Clock: View {
    
    @State private var date = Date()
    @State private var timeLeft = Date(timeIntervalSinceNow: +60) // 1 minute
    
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
        
        ClockView().environment(\.clockDate, $date)
            .padding()
    }
}
