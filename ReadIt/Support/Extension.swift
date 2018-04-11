//
//  Extension.swift
//  ReadIt
//
//  Created by Marc Nieto on 4/11/18.
//  Copyright © 2018 Marc Nieto. All rights reserved.
//

import Foundation

extension Date {
    var isInThisWeek: Bool {
        return self.isInSameWeek(date: Date())
    }

    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }

    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
