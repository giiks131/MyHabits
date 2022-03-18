//
//  Extensions.swift
//  Habits Tracker
//
//  Created by Александр Шаповалов on 10.02.2022.
//

import UIKit

func stripTime(from originalDate: Date) -> Date {
    let components = Calendar.current.dateComponents([.hour, .minute], from: originalDate)
    let date = Calendar.current.date(from: components)
    return date!
}
