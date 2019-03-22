//
//  FoundationExt.swift
//  Game UIKit
//
//  Created by Farini on 3/21/19.
//  Copyright © 2019 Farini. All rights reserved.
//

import Foundation

extension Date{
    
    /** Returns the time left until the date happens in 2 units. if until is nil, compares to now */
    func timeRemainingText(until:Date?) -> String{
        
        let calendar = Calendar.current
        
        let now = until ?? Date() // This is a chance in case needs to compare to other than now date
        
        // Make sure date is in the future
        guard now.compare(self) == .orderedAscending else{
            return "Finished"
        }
        
        // Frrom now until date happens
        let deltaComps = calendar.dateComponents([.weekOfYear, .day, .hour, .minute, .second], from: now, to: self)
        
        let deltaWeeks = deltaComps.weekOfYear ?? 0
        let deltaDays = deltaComps.day ?? 0
        let deltaHours = deltaComps.hour ?? 0
        let deltaMinutes = deltaComps.minute ?? 0
        let deltaSec = deltaComps.second ?? 0
        
        var lblString:String = "0"
        
        if deltaWeeks > 0{
            lblString = "\(deltaWeeks)w \(deltaDays)d"
        }else if deltaDays > 0{
            lblString = "\(deltaDays)d \(deltaHours)h"
        }else if deltaHours > 0{
            lblString = "\(deltaHours)h \(deltaMinutes)m"
        }else if deltaMinutes > 0{
            lblString = "\(deltaMinutes)m \(deltaSec)s"
        }else{
            lblString = "\(deltaSec)s"
        }
        
        return lblString
    }
}

extension TimeInterval{
    
    /** Makes A Time Interval, given the hours */
    static func makeWith(hours:Int) -> TimeInterval{
        return 60.0 * 60.0 * Double(hours)
    }
}

extension Int {
    
    /** Abreviates the number to a 3 digit number with multiplying indicator (Million, Billion, etc)*/
    var abbreviated: String {
        let abbrev = "KMBTPE"   // K is thousand, M is Millions, B is Billions, etc.
        
        return abbrev.enumerated().reversed().reduce(nil as String?) { accum, tuple in
            let factor = Double(self) / pow(10, Double(tuple.0 + 1) * 3)
            let format = (factor.truncatingRemainder(dividingBy: 1)  == 0 ? "%.0f%@" : "%.1f%@")
            return accum ?? (factor > 1 ? String(format: format, factor, String(tuple.1)) : nil)
            } ?? String(self)
    }
}

extension Double{
    
    /** A String for this number with 2 digits */
    var doubleDigitString:String{
        return String(format: "%.2f", self)
    }
    
    /** This number rounded to 2 digits */
    var doubleDigitRounded:Double{
        return (self * 100).rounded()/100
    }
}


