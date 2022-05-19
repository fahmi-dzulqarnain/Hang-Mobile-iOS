//
//  PrayView.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 30/04/22.
//

import SwiftUI

struct PrayView: View {
    @StateObject private var prayTime = PrayTime()
    @StateObject private var notification = PrayNotification()
    
    var body: some View {
        ScrollView {
            VStack {
                UpcomingPrayView()
            }
            .padding(.bottom, 36)
            
            let prays = prayTime.getPrayTimes()
            
            ForEach(prays, id: \.prayID) { pray in
                let prayName = pray.prayName
                let current = prayTime.getCurrentPray()?.prayName
                let font = current == prayName ? "Quicksand-Bold" : "Quicksand-Medium"
                let fontSize: CGFloat = current == prayName ? 20 : 17
                let _ = notification.showNotification(pray: pray)
                
                HStack {
                    Text(prayName)
                        .font(Font.custom(font, size: fontSize, relativeTo: .body))
                    Spacer()
                    Text(pray.prayTime, style: .time)
                        .font(Font.custom(font, size: fontSize, relativeTo: .body))
                }
                Spacer(minLength: 24)
                
                
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
    }
}

struct PrayView_Previews: PreviewProvider {
    static var previews: some View {
        PrayView()
    }
}
