//
//  PrayView.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 30/04/22.
//

import SwiftUI
import CoreLocation

struct PrayView: View {
    @StateObject private var notification = PrayNotification()
    @StateObject var locationManager = LocationManager()
    @State var city = ""
    @State var selectedDateIndex = 0
    
    let lastSevenDay: [Int] = {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [Int]()
        for i in 1 ... 7 {
            let day = cal.component(.day, from: date)
            days.append(day)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }()
    
    let lastSevenDate: [Date] = {
        let cal = Calendar.current
        var dates = [Date]()
        for i in 0 ... 6 {
            let date = Date().addDays(i)
            dates.append(date)
        }
        
        return dates
    }()
        
    var userLatitude: Double {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    
    var userLongitude: Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    var location: String {
        if let location = UserDefaults.standard.object(forKey: "coordinate") as? [Double] {
            let place = CLLocation(latitude: location[0], longitude: location[1])
            
            place.placemark { placemark, error in
                let cityName = placemark?.locality ?? placemark?.state ?? placemark?.country ?? "Undetected"
                
                if cityName != "Undetected" {
                    UserDefaults.standard.set(cityName, forKey: "cityName")
                    city = cityName
                } else if let savedCity = UserDefaults.standard.string(forKey: "CityName") {
                    city = savedCity
                }
                
                print("Kota: \(city)")
            }
            
            return "\(city)"
        }
        
        return "City"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                UpcomingPrayView()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                
                HStack {
                    Image(systemName: "location.circle.fill")
                    Text(location)
                        .font(Font.custom("Quicksand-SemiBold", size: 20, relativeTo: .body))
                }
                .padding(.bottom, 24)
                
                let prayTime = PrayTime(userLatitude, userLongitude, lastSevenDate[selectedDateIndex])
                let prays = prayTime.getPrayTimes(date: lastSevenDate[selectedDateIndex])

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
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 36)
            }
            .padding(.top, 24)
            
            Spacer()
            
            ScrollView(.horizontal) {
                HStack {
                    Spacer()
                    
                    ForEach(0..<7) { index in
                        let color: Color = (selectedDateIndex == index) ? Color.oliveGreen : Color.softGreen
                        let font: String = (selectedDateIndex == index) ? "Quicksand-Bold" : "Quicksand-Regular"
                        let fontColor: Color = (selectedDateIndex == index) ? Color.white : Color.darkGreen
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(color)
                                .frame(width: 45, height: 45, alignment: .bottom)
                            Text("\(lastSevenDay[index])")
                                .font(Font.custom(font, size: 20, relativeTo: .body))
                                .foregroundColor(fontColor)
                                .onTapGesture {
                                    selectedDateIndex = index
                                }
                        }
                        .padding(.trailing, 10)
                    }
                    
                    Spacer()
                }
            }
            .padding()
        }
    }
}

struct PrayView_Previews: PreviewProvider {
    static var previews: some View {
        PrayView()
    }
}
