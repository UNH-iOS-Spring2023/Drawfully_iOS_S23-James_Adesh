//
//  LaunchScreenStateManager.swift
//  Drawfully
//
//  Created by Adesh Agarwal on 4/28/23.
//
//  Citation : https://holyswift.app/animated-launch-screen-in-swiftui/


import Foundation

final class LaunchScreenStateManager: ObservableObject {

//Initializing at first step
@MainActor @Published private(set) var state: LaunchScreenStep = .firstStep

    @MainActor func dismiss() {
        Task {
            state = .secondStep

            try? await Task.sleep(for: Duration.seconds(1))

            self.state = .finished
        }
    }
}
