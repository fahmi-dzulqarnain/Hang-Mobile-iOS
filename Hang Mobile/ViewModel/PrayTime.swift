//
//  PrayTime.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 25/03/22.
//

import Foundation
import Adhan

class PrayTime: ObservableObject {
    @Published var upcomingPrayName = ""
    @Published var upcomingPrayTime = Date()
    @Published var isDisplayNext = false
    var locationManager = LocationManager()
    
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    private var dateComponents: DateComponents?
    private var coordinates: Coordinates?
    private var calculationParams: CalculationParameters?
    
    init() {
        setupPrayTime()
    }
}

extension PrayTime {
    private func setupPrayTime() {
        let location = locationManager.lastLocation?.coordinate
        coordinates = Coordinates(
            latitude: location?.latitude ?? 1.102960,
            longitude: location?.longitude ?? 104.060810)
        dateComponents = cal.dateComponents([.year, .month, .day], from: Date())
        calculationParams = CalculationMethod.egyptian.params
        calculationParams?.madhab = .shafi
        
        if let prayer = PrayerTimes(coordinates: coordinates!, date: dateComponents!, calculationParameters: calculationParams!) {
            let currentPray = getCurrentPray()
            isDisplayNext = true
            
            if Date() < currentPray!.prayTime.addMinute(30) {
                upcomingPrayName = currentPray?.prayName ?? ""
                upcomingPrayTime = currentPray?.prayTime ?? Date()
                isDisplayNext = false
            } else if let nextPrayer = prayer.nextPrayer() {
                upcomingPrayName = getPrayName(prayer: nextPrayer)
                upcomingPrayTime = prayer.time(for: nextPrayer).addMinute(2)
            } else {
                upcomingPrayName = "Shubuh"
                upcomingPrayTime = prayer.fajr.addDays(1).addMinute(2)
            }
        }
    }
    
    public func getCurrentPray() -> Pray? {
        if let prayer = PrayerTimes(coordinates: coordinates!, date: dateComponents!, calculationParameters: calculationParams!) {
            let currentPrayer = prayer.currentPrayer()!
            return Pray(prayName: getPrayName(prayer: currentPrayer), prayTime: prayer.time(for: currentPrayer).addMinute(2))
        }
        return nil
    }
    
    public func getPrayTimes(date: Date = Date()) -> [Pray] {
        var prays: [Pray] = []
        dateComponents = cal.dateComponents([.year, .month, .day], from: date)
        
        if let prayer = PrayerTimes(coordinates: coordinates!, date: dateComponents!, calculationParameters: calculationParams!) {
            let shubuh = Pray(prayName: "Shubuh", prayTime: prayer.fajr.addMinute(2))
            let sunrise = Pray(prayName: "Sunrise", prayTime: prayer.sunrise)
            let dzuhur = Pray(prayName: "Dzuhur", prayTime: prayer.dhuhr.addMinute(2))
            let ashar = Pray(prayName: "Ashar", prayTime: prayer.asr.addMinute(2))
            let maghrib = Pray(prayName: "Maghrib", prayTime: prayer.maghrib.addMinute(2))
            let isya = Pray(prayName: "Isya", prayTime: prayer.isha.addMinute(2))

            prays += [shubuh, sunrise, dzuhur, ashar, maghrib, isya]
        }
        return prays
    }
    
    private func getPrayName(prayer: Prayer) -> String {
        var result: String
        
        switch (prayer) {
        case .fajr :
            result = "Shubuh"
        case .sunrise:
            result = "Sunrise"
        case .dhuhr:
            result = "Dzuhur"
        case .asr:
            result = "Ashar"
        case .maghrib:
            result = "Maghrib"
        case .isha:
            result = "Isya"
        }
        
        return result
    }
}

struct Pray {
    var prayID = UUID()
    var prayName = ""
    var prayTime = Date()
}
