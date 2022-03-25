//
//  RadioPlayer.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 13/01/22.
//

import SwiftUI
import Foundation
import AVKit
import MediaPlayer

class RadioPlayer: ObservableObject {
    @Published var isPlaying = false
    var audioPlayer: AVPlayer?
    var nowPlayingInfo: [String : Any]!
    
    init() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupMediaPlayerNotification()
        setupNotificationView()
        setupNotifications()
    }
    
    func playRadio(){
        if let link = URL(string: "http://46.235.224.203:8000/listen.mp3"){
            self.audioPlayer = AVPlayer(url: link)
            
            self.audioPlayer?.play()
            self.isPlaying.toggle()
        }
    }
    
    func pauseRadio(){
        if self.audioPlayer != nil {
            self.isPlaying.toggle()
            self.audioPlayer?.pause()
        }
    }
}

extension RadioPlayer {
    func setupMediaPlayerNotification(){
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 0.0 {
                self.playRadio()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.audioPlayer?.rate == 1.0 {
                self.pauseRadio()
                return .success
            }
            return .commandFailed
        }
    }
    
    func setupNotificationView(){
        nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Radio Hang FM"
        if let image = UIImage(named: "Radio - Notif Icon") {
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { size in
                        return image
                }
            }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.audioPlayer?.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer?.currentTime
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNotifications() {
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(self,
                                     selector: #selector(handleInterruption),
                                     name: AVAudioSession.interruptionNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(handleRouteChange),
                                     name: AVAudioSession.routeChangeNotification,
                                     object: nil)
    }
    
    @objc func handleRouteChange(notification: Notification) {
      guard let userInfo = notification.userInfo,
        let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
        let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
          return
      }
      switch reason {
      case .newDeviceAvailable:
        let session = AVAudioSession.sharedInstance()
        for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.headphones {
          print("headphones connected")
          DispatchQueue.main.sync {
            self.playRadio()
          }
          break
        }
      case .oldDeviceUnavailable:
        if let previousRoute =
          userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
          for output in previousRoute.outputs where output.portType == AVAudioSession.Port.headphones {
            print("headphones disconnected")
            DispatchQueue.main.sync {
              self.pauseRadio()
            }
            break
          }
        }
      default: ()
      }
    }
    
    @objc func handleInterruption(notification: Notification) {
      guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
          return
      }
      
      if type == .began {
        print("Interruption began")
        // Interruption began, take appropriate actions
      }
      else if type == .ended {
        if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
          let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
          if options.contains(.shouldResume) {
            // Interruption Ended - playback should resume
            print("Interruption Ended - playback should resume")
            playRadio()
          } else {
            // Interruption Ended - playback should NOT resume
            print("Interruption Ended - playback should NOT resume")
          }
        }
      }
    }
}
