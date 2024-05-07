//
// Created by René Pirringer on 17.03.21.
// Copyright (c) 2021 Rene Pirringer. All rights reserved.
//

import Foundation

open class PlistCoder: OBCoder.Coder {

	var dictionary = [String: Any]()

	public var xmlString: String? {
		get {
			if let data = self.data {
				if let result = String(data: data, encoding: .utf8) {
					return result
				}
			}
			return nil
		}
	}

	public var data: Data? {
		get {
			do {
				return try PropertyListSerialization.data(fromPropertyList: dictionary, format: PropertyListSerialization.PropertyListFormat.xml, options: 0)
			} catch {
				// nil is returned when the plist could not be created
			}
			return nil
		}
	}

	public func encode(_ encodable: Encodable) {
		encodable.encode(with: self)
	}

	public func encode(_ string: String, forKey key: String) {
		dictionary[key] = string
	}

	public func encode(_ boolValue: Bool, forKey key: String) {
		dictionary[key] = boolValue
	}

	public func encode(_ number: Int, forKey key: String) {
		dictionary[key] = number
	}

	public func encode(_ number: Float, forKey key: String) {
		dictionary[key] = number
	}

	public func encode(_ point: CGPoint, forKey key: String) {
		dictionary[key] = [
			"class": "CGPoint",
			"x": point.x,
			"y": point.y,
		] as [String : Any]
	}

	public func encode(_ encodable: Encodable, forKey key: String) {
		let coder = PlistCoder()
		encodable.encode(with: coder)
		dictionary[key] = coder.dictionary
	}

	public func encode(_ array: [String], forKey key: String) {
		dictionary[key] = array
	}

	public func encode(_ array: [Int], forKey key: String) {
		dictionary[key] = array
	}

	public func encode(_ array: [Encodable], forKey key: String) {
		var dataArray = [Any]()
		for encodable in array {
			let coder = PlistCoder()
			encodable.encode(with: coder)
			dataArray.append(coder.dictionary)
		}
		self.dictionary[key] = dataArray
	}
	
	public func encode(_ dict: [String: Any], forKey key: String) {
		self.dictionary[key] = dict
	}

	public func encode(objects: [AnyObject], forKey key: String) {
	}


}
