//
//  DateBuilder.swift
//  OBCoderTests
//
//  Created by René Pirringer on 07.05.24.
//

import Foundation

public class DateBuilder {

	public class func create(year: Int? = nil,
													 month: Int? = nil,
													 day: Int? = nil,
													 hour: Int? = nil,
													 minute: Int? = nil,
													 second: Int? = nil,
													 timezone: String? = nil) -> Date {
		let calendar = Calendar.autoupdatingCurrent
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second

		if let timezone = timezone {
			components.timeZone = TimeZone(abbreviation: timezone)
		}
		if let date = calendar.date(from: components) {
			return date
		}
		return Date()
	}

	public class func add(days: Int, toDate date: Date) -> Date {
		return NSCalendar.autoupdatingCurrent.add(days: days, toDate: date)
	}


}


public extension Calendar {
	
	func add(days: Int, toDate date: Date) -> Date {
		self.date(byAdding: .day, value: days, to: date) ?? date
	}
}

