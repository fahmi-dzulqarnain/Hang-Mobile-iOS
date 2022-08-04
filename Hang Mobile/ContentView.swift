//
//  ContentView.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 13/01/22.
//

import SwiftUI
import AVKit
import MediaPlayer

struct ContentView: View {
    @StateObject private var radioPlayer = RadioPlayer()
    
    let iconSize: CGFloat = 71.0
    
    @State var shouldShowModal = false
    @State var selectedTabIndex = 0
    @State var screenWidth = 0
    
    private let tabImages = ["tab-radio", "tab-video", "tab-shalat"]
    private let streamPlayer = AVPlayer(url: URL(string: "https://hangmedia.co.id/videoPlayer")!)
    
    var body: some View {
        VStack {
            switch selectedTabIndex {
            case 0:
                ScrollView {
                    VStack {
                        UpcomingPrayView()
                            .padding(.top, 24)
                            .padding(.horizontal, 24)
                        
                        HStack {
                            Image("Radio - Home Icon")
                                .resizable()
                                .frame(width: iconSize, height: iconSize, alignment: .center)
                                .mask(Circle()
                                    .frame(width: iconSize, height: iconSize, alignment: .center))
                                .padding(.bottom)
                            
                            Text("Radio Hang")
                                .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                                .padding(.leading, 16)
                                .padding(.bottom, 16)
                        }
                        .padding(.top, 24)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 0.5)
                                .foregroundColor(.primary)
                            
                            Rectangle()
                                .frame(width: 60, height: 22, alignment: .center)
                                .foregroundColor(.background)
                            
                            Text("LIVE")
                                .font(Font.custom("Quicksand-SemiBold", size: 21, relativeTo: .headline))
                                .padding()
                        }
                        .padding(.bottom, 24)
                        
                        Image(systemName: radioPlayer.isPlaying ? "pause.rectangle.fill": "play.square.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.darkGreen)
                            .padding(.bottom, 32)
                            .onTapGesture {

                                if radioPlayer.isPlaying {
                                    radioPlayer.pauseRadio()
                                } else {
                                    radioPlayer.playRadio()
                                }
                            }
                        
                        VStack {
                            HStack {
                                Image(systemName: "speaker.wave.1.fill")
                                    .foregroundColor(.softGray)
                                    .font(.title2)
                                Spacer()
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.softGray)
                                    .font(.title2)
                            }
                            .padding(.horizontal, 50)
                            .padding(.bottom, 10)
                            
                            VolumeSlider()
                               .frame(height: 50)
                               .padding(.leading, 50)
                               .padding(.trailing, 20)
                        }
                    }
                }
            case 1:
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowModal) {
                        VideoPlayer(player: streamPlayer)
                            .onAppear() {
                                streamPlayer.play()
                                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscapeRight
                                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue,
                                                          forKey: "orientation")
                                UINavigationController.attemptRotationToDeviceOrientation()
                            }
                            .onDisappear() {
                                streamPlayer.pause()
                                selectedTabIndex = 0
                                DispatchQueue.main.async {
                                    AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                                              forKey: "orientation")
                                    UINavigationController.attemptRotationToDeviceOrientation()
                                }
                            }
                            .ignoresSafeArea()
                    }
                    .background(Color.black)
            case 2:
                PrayView()
            default:
                RadioView()
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.background)
                    .frame(height: 135, alignment: .bottom)
                HStack {
                    Spacer()
                    ForEach(0..<3) { index in
                        Button {
                            if index == 1 {
                                shouldShowModal.toggle()
                            }
                            
                            selectedTabIndex = index
                        } label: {
                            Spacer()
                            Image(selectedTabIndex == index
                                  ? "\(tabImages[index])-active"
                                  : "\(tabImages[index])-inactive")
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
            }
            .shadow(radius: 5, x: 0, y: 3)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct VolumeSlider: UIViewRepresentable {
   func makeUIView(context: Context) -> MPVolumeView {
      MPVolumeView(frame: .zero)
   }

   func updateUIView(_ view: MPVolumeView, context: Context) {}
}
