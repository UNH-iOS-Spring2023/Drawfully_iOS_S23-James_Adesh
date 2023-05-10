//
//  LaunchScreenView.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/28/23.
//
//  Citation : https://holyswift.app/animated-launch-screen-in-swiftui/


import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager // Environment Object to get the state of animation

    @State private var firstAnimation = false  // Boolean to control the animation
    @State private var secondAnimation = false // Boolean to control the animation
    @State private var startFadeoutAnimation = false // Boolean to control the animation
    
    @ViewBuilder
    private var image: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .rotationEffect(firstAnimation ? Angle(degrees: 900) : Angle(degrees: 1800)) // Adding rotation effect
            .scaleEffect(secondAnimation ? 0 : 1) // Adding scaling effect to the animation
            .offset(y: secondAnimation ? 400 : 0)
    }
    
    @ViewBuilder
    private var backgroundColor: some View {
        Color.mint.ignoresSafeArea()
    }
    
    private let animationTimer = Timer // Timer to handle the animation
        .publish(every: 0.5, on: .current, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            backgroundColor
            VStack{
                image
                Text("Drawfully").font(.largeTitle).bold().foregroundColor(.black)
            }
        }.onReceive(animationTimer) { timerValue in
            updateAnimation()  // updating timer to start off animation
        }.opacity(startFadeoutAnimation ? 0 : 1)
    }
    
    // function to start off animation
    private func updateAnimation() {
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
