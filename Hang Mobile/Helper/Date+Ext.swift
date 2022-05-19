//
//  Date+Ext.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 30/04/22.
//

import Foundation

extension Date {
    func addMinute(_ minutes: Int) -> Date
    {
        return self.addingTimeInterval(TimeInterval(60 * minutes))
    }
    
    func addDays(_ days: Int) -> Date
    {
        return self.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    }
}
