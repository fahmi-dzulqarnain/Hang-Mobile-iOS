//
//  NotificationViewModel.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 30/04/22.
//

import Foundation
import UserNotifications

class PrayNotification: ObservableObject {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func showNotification(pray: Pray) -> Bool {
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: pray.prayTime)
        let hour = dateComponent.hour ?? 0
        let minute = dateComponent.minute ?? 0
        let prayTime = String(format: "%02d:%02d", hour, minute)

        let prayName = pray.prayName
        let content = UNMutableNotificationContent()
        let subtitle = prayName == "Sunrise" ? "The sun is rising" : "Let's pray \(prayName) early"
        content.title = "Time for \(prayName) at \(prayTime)"
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: prayName, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        return true
    }
}
