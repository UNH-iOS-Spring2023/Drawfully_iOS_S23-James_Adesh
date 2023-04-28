//
//  LaunchScreenView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/28/23.
//
//  Citation : https://holyswift.app/animated-launch-screen-in-swiftui/


import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager // Mark 1

    @State private var firstAnimation = false  // Mark 2
    @State private var secondAnimation = false // Mark 2
    @State private var startFadeoutAnimation = false // Mark 2
    
    @ViewBuilder
    private var image: some View {  // Mark 3
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .rotationEffect(firstAnimation ? Angle(degrees: 900) : Angle(degrees: 1800)) // Mark 4
            .scaleEffect(secondAnimation ? 0 : 1) // Mark 4
            .offset(y: secondAnimation ? 400 : 0) // Mark 4
    }
    
    @ViewBuilder
    private var backgroundColor: some View {  // Mark 3
        Color.mint.ignoresSafeArea()
    }
    
    private let animationTimer = Timer // Mark 5
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor  // Mark 3
            VStack{
                image  // Mark 3
                Text("Drawfully").font(.largeTitle).bold().foregroundColor(.black)
            }
        }.onReceive(animationTimer) { timerValue in
            updateAnimation()  // Mark 5
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    private func updateAnimation() { // Mark 5
        switch launchScreenState.state {
        case .firstStep:
            withAnimation(.easeInOut(duration: 0.9)) {
                firstAnimation.toggle()
            }
        case .secondStep:
            if secondAnimation == false {
                withAnimation(.linear) {
                    self.secondAnimation = true
                    startFadeoutAnimation = true
                }
            }
        case .finished:
            // use this case to finish any work needed
            break
        }
    }
    
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenStateManager())
    }
}
