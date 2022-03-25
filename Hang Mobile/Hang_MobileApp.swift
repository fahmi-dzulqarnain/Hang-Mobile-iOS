//
//  Hang_MobileApp.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 13/01/22.
//

import SwiftUI
import AVKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            } catch let error as NSError {
                print("Setting category to AVAudioSessionCategoryPlayback failed: \(error)")
            }
        
            return true
        }
}

@main
struct Hang_MobileApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
