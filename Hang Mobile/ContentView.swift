//
//  ContentView.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 13/01/22.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @StateObject private var radioPlayer = RadioPlayer()
    
    var body: some View {
        VStack {
            Image("Radio - Home Icon")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .mask(Circle().frame(width: 150, height: 150, alignment: .center))
                .padding(.bottom)
            
            Text("Radio Hang")
                .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                .padding(.bottom, 40)
            
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
            .padding(.bottom, 40)
            
            Image(systemName: radioPlayer.isPlaying ? "pause.rectangle.fill": "play.square.fill")
                .font(.system(size: 70))
                .foregroundColor(.darkGreen)
                .padding(.bottom, 40)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

struct VolumeSlider: UIViewRepresentable {
   func makeUIView(context: Context) -> MPVolumeView {
      MPVolumeView(frame: .zero)
   }

   func updateUIView(_ view: MPVolumeView, context: Context) {}
}
