//
// Created by Rene Pirringer on 18/08/2017.
// Copyright (c) 2017 René Pirringer. All rights reserved.
//

import Foundation

open class JSONDecoder : Decoder {

	var data : [String: Any]

	public convenience init(jsonString: String) {
		self.init(jsonString: jsonString, defaultValues: [:])
	}

	public convenience init(fileURL: URL) throws {
		let jsonString = try String(contentsOf: fileURL)
		self.init(jsonString: jsonString)
	}

	public init(jsonString: String, defaultValues: [String: Any]) {
		data = defaultValues
		if let jsonData = jsonString.data(using: .utf8) {
			do {
				if let result = try JSONSerialization.jsonObject(with: jsonData) as? [String: AnyObject] {
					data.merge(result) { (_, new) in new }
					return
				}
			} catch {
				// ignore
			}
		}
	}

	init(data: [String: Any]) {
		self.data = data
	}


	public func decode<T:Encodable>(type: T.Type) -> T? {
		return T(decoder: self)
	}


	public func decoder(forKey key: String) -> Decoder? {
		if let value = data[key] as? [String : Any]{
			let decoder = JSONDecoder(data:value)
			return decoder
		}
		return nil
	}

	public func decodeArray<T>(forKey key: String, closure: DecodeClosure<T>) -> [T]? {
		if let dataArray = data[key] as? [[String : Any]] {
			var resultArray = [T]()
			for data in dataArray {
				let decoder = JSONDecoder(data:data)
				if let object = closure(decoder) {
					resultArray.append(object)
				}
			}
			return resultArray
		}
		return nil
	}

	public func string(forKey key: String) -> String? {
		if let value = data[key] as? String {
			return value
		}
		return nil
	}

	public func bool(forKey key: String) -> Bool? {
		if let value = data[key] as? Bool {
			return value
		}
		if let stringValue = data[key] as? String {
			return Bool(stringValue)
		}
		return nil
	}

	public func integer(forKey key: String) -> Int? {
		if let value = data[key] as? Int {
			return value
		}
		if let stringValue = data[key] as? String {
			return Int(stringValue)
		}
		return nil
	}

	public func float(forKey key: String) -> Float? {
		if let value = data[key] as? Float {
			return value
		}
		if let stringValue = data[key] as? String {
			return Float(stringValue)
		}
		return nil
	}


	public func point(forKey key: String) -> CGPoint? {
		guard let dictionary = data[key] as? [String: Any] else {
			return nil
		}

		guard let x = dictionary["x"] as? CGFloat else {
			return nil
		}

		guard let y = dictionary["y"] as? CGFloat else {
			return nil
		}
		return CGPoint(x: x, y: y)
	}

	public func stringArray(forKey key: String) -> [String]? {
		if let result = data[key] as? [String] {
			return result
		}
		return nil
	}

	public func intArray(forKey key: String) -> [Int]? {
		if let result = data[key] as? [Int] {
			return result
		}
		return nil
	}
	
	public func dictionary(forKey key: String) -> [String: Any]? {
		if let result = data[key] as? [String: Any] {
			return result
		}
		return nil
	}

	public var keys: [String] {
		return Array(data.keys)
	}

}
