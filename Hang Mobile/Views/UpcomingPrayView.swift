//
//  UpcomingPrayView.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 07/05/22.
//

import SwiftUI

struct UpcomingPrayView: View {
    @StateObject private var notification = PrayNotification()
    @Environment(\.scenePhase) var scenePhase
    
    @State var upcomingPray = ""
    @State var upcomingTime = Date()
    @State var postfixText = " remaining"
    
    var body: some View {
        ZStack {
            let pray = Pray(prayName: upcomingPray, prayTime: upcomingTime)
            let _ = notification.showNotification(pray: pray)

            Image(upcomingPray)
                .fitToAspectRatio(1.8)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5, y: 3)
            VStack {
                HStack {
                    Text(upcomingPray)
                        .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                        .foregroundColor(.white)
                    Text(upcomingTime, style: .time)
                        .font(Font.custom("Quicksand-Bold", size: 25, relativeTo: .largeTitle))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 8)
                .shadow(radius: 5)
                
                HStack {
                    Text(upcomingTime, style: .relative)
                        .font(Font.custom("Quicksand-Medium", size: 17, relativeTo: .body))
                        .foregroundColor(.white) +
                    Text(postfixText)
                        .font(Font.custom("Quicksand-Medium", size: 17, relativeTo: .body))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 24)
                .padding(.trailing, 190)
                .shadow(radius: 5)
                Spacer()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                    
                    let updatedPray = PrayTime()
                    postfixText = updatedPray.isDisplayNext ? " remaining" : " ago"
                    upcomingTime = updatedPray.upcomingPrayTime
                    upcomingPray = updatedPray.upcomingPrayName
                }
            }
        }
        .onAppear() {
            let updatedPray = PrayTime()
            postfixText = updatedPray.isDisplayNext ? " remaining" : " ago"
            upcomingTime = updatedPray.upcomingPrayTime
            upcomingPray = updatedPray.upcomingPrayName
        }
    }
}

struct UpcomingPrayView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingPrayView()
    }
}
