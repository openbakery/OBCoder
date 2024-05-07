//
// Created by René Pirringer on 17.03.21.
// Copyright (c) 2021 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import SwiftHamcrest
@testable import OBCoder

class PlistCoder_Base_Test: XCTestCase {



	func indentation(level: Int) -> String{
		var result = ""
		for _ in 0...level {
			result += "\t"
		}
		return result
	}

	func plistValue(key: String, value: Any, level: Int = 0) -> String {
		let indent = "\n\(indentation(level: level))"
		let valueString = plistElement(value: value, level: level)
		return "\(indent)<key>\(key)</key>\(valueString)"
	}

	func plistValue(key: String, rawString: String, level: Int = 0) -> String {
		let indent = "\n\t"
		return "\(indent)<key>\(key)</key>\(indent)\(rawString)"
	}

	func stringValue(_ floatValue: Float) -> String {
		let formatter = NumberFormatter()
		formatter.locale = Locale.init(identifier: "en_US")
		formatter.numberStyle = .decimal
		if let formattedValue = formatter.string(from: NSNumber(value: floatValue)) {
			return formattedValue
		}
		return ""
	}

	func plistElement(value: Any, level: Int = 0) -> String {
		let indent = "\n\(indentation(level: level))"
		let valueString: String
		if value is Int {
			return "\(indent)<integer>\(value)</integer>"
		}

		if let floatValue = value as? Float {
			valueString = stringValue(floatValue)
			return "\(indent)<real>\(valueString)</real>"
		}

		if let boolValue = value as? Bool {
			if boolValue {
				return "\(indent)<true/>"
			} else {
				return "\(indent)<false/>"
			}
		}

		if let pointValue = value as? CGPoint {
			valueString = self.pointValue(point: pointValue, level: level)
			return "\(indent)\(valueString)"
		}


		return "\(indent)<string>\(value)</string>"
	}


	func pointValue(point: CGPoint, level: Int = 0) -> String {
		let indent = "\(indentation(level: level))"
		var result = "<dict>"
		result += plistValue(key: "class", value: "CGPoint", level: level+1)
		result += plistValue(key: "x", value: Float(point.x), level: level+1)
		result += plistValue(key: "y", value: Float(point.y), level: level+1)
		result += "\n\(indent)</dict>"
		return result
	}

	func plistValue(key: String, boolean: Bool, level: Int = 0) -> String {
		if boolean {
			return plistValue(key: key, rawString: "<true/>", level: level)
		} else {
			return plistValue(key: key, rawString: "<false/>", level: level)
		}
	}

	func plistValue(key: String, array: [Any], level: Int = 0) -> String {
		var elementString = "<array>"
		for item in array {
			if let stringItem = item as? String {
				elementString += plistElement(value: stringItem, level: level+1)
			}
			if let intItem = item as? Int {
				elementString += plistElement(value: intItem, level: level+1)
			}

		}
		elementString += "\n\(indentation(level: level))</array>"
		return plistValue(key: key, rawString: elementString)
	}


	func plistString(data: [String: Any] = [:]) -> String {

		var valueString = "<dict>"
		for (key, value) in data {

			if let array = value as? [Any] {
				valueString += plistValue(key: key, array: array)
			} else {
				valueString += plistValue(key: key, value: value)
			}

		}

		if valueString == "<dict>" {
			valueString = "<dict/>"
		} else {
			valueString += "\n</dict>"
		}

		let emptyPlistString = """
													 <?xml version="1.0" encoding="UTF-8"?>
													 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
													 <plist version="1.0">
													 \(valueString)
													 </plist>

													 """
		return emptyPlistString
	}

}
