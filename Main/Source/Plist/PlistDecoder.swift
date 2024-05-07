//
// Created by René Pirringer on 17.03.21.
// Copyright (c) 2021 Rene Pirringer. All rights reserved.
//

import Foundation
import UIKit

open class PlistDecoder: OBCoder.Decoder {

	let dictionary: [String: Any]

	public init(data: Data) {
		do {
			if let dictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] {
				self.dictionary = dictionary
			} else {
				self.dictionary = [:]
			}
		} catch {
			self.dictionary = [:]
		}
	}

	init(dictionary: [String: Any]) {
		self.dictionary = dictionary
	}


	public func integer(forKey key: String) -> Int? {
		if let value = dictionary[key] as? Int {
			return value
		}
		return nil
	}

	public func float(forKey key: String) -> Float? {
		if let value = dictionary[key] as? NSNumber {
			return value.floatValue
		}
		if let value = dictionary[key] as? Float {
			return value
		}
		return nil
	}


	public func bool(forKey key: String) -> Bool? {
		if let value = dictionary[key] as? Bool {
			return value
		}
		return nil
	}

	public func string(forKey key: String) -> String? {
		if let value = dictionary[key] as? String {
			return value
		}
		return nil
	}


	public func decode<T>(type: T.Type) -> T? where T: Encodable {
		return T(decoder: self)
	}

	public func decode<T>(forKey key: String, closure: (Decoder) -> T?) -> T? {
		if let value = dictionary[key] as? [String: AnyObject] {
			let decoder = PlistDecoder(dictionary: value)
			return closure(decoder)
		}

		return nil
	}

	public func decodeArray<T>(forKey key: String, closure: (Decoder) -> T?) -> [T]? {
		if let dataArray = dictionary[key] as? [[String : AnyObject]] {
			var resultArray = [T]()
			for dictionary in dataArray {
				let decoder = PlistDecoder(dictionary:dictionary)
				if let object = closure(decoder) {
					resultArray.append(object)
				}
			}
			return resultArray
		}
		return nil
	}

	public func point(forKey key: String) -> CGPoint? {
		guard let pointDictionary =  self.dictionary[key] as? [String: Any] else {
			return nil
		}
		guard let x = pointDictionary["x"] as? NSNumber else {
			return nil
		}
		guard let y = pointDictionary["y"] as? NSNumber else {
			return nil
		}
		return CGPoint(x: x.doubleValue, y: y.doubleValue)
	}

	public func stringArray(forKey key: String) -> [String]? {
		if let result = self.dictionary[key] as? [String] {
			return result
		}
		return nil
	}

	public func intArray(forKey key: String) -> [Int]? {
		if let result = self.dictionary[key] as? [Int] {
			return result
		}
		return nil
	}

	public func dictionary(forKey key: String) -> [String : Any]? {
		if let result = self.dictionary[key] as? [String: Any] {
			return result
		}
		return nil
	}
}
