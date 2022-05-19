//
//  String+Ext.swift
//  Hang Mobile
//
//  Created by Fahmi Dzulqarnain on 30/04/22.
//

import Foundation

extension String
{
    mutating func replace(originalString:String, withString newString:String)
    {
        let replacedString = self.replacingOccurrences(of: originalString, with: newString)
        self = replacedString
    }
}
