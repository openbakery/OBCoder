//
//  DictionaryDecoder.swift
//  OBFoundation
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation
import UIKit

open class DictionaryDecoder : Decoder {
	
	
	
	public let dictionary: [String: Any]
	
	public init(dictionary: [String: Any]) {
		self.dictionary = dictionary
	}
	
	
	public func decode<T:Encodable>(type: T.Type) -> T? {
		return T(decoder: self)
	}
	
	
	public func decode<T>(forKey key: String, closure: DecodeClosure<T>) -> T? {
		if let value = dictionary[key] as? [String : AnyObject]{
			let decoder = DictionaryDecoder(dictionary:value)
			return closure(decoder)
		}
		return nil
	}
	
	public func decodeArray<T>(forKey key: String, closure: DecodeClosure<T>) -> [T]? {
		if let dataArray = dictionary[key] as? [[String : AnyObject]] {
			var resultArray = [T]()
			for data in dataArray {
				let decoder = DictionaryDecoder(dictionary:data)
				if let object = closure(decoder) {
					resultArray.append(object)
				}
			}
			return resultArray
		}
		return nil
	}
	
	public func string(forKey key: String) -> String? {
		if let value = self.dictionary[key] as? String {
			return value
		}
		return nil
	}
	
	public func bool(forKey key: String) -> Bool? {
		if let value = self.dictionary[key] as? Bool {
			return value
		}
		if let value = self.dictionary[key] as? String {
			return Bool(value)
		}
		return nil
	}
	
	public func integer(forKey key: String) -> Int? {
		if let value = self.dictionary[key] as? Int {
			return value
		}
		if let value = self.dictionary[key] as? String {
			return Int(value)
		}
		return nil
	}

	public func float(forKey key: String) -> Float? {
		if let value = self.dictionary[key] as? Float {
			return value
		}
		if let value = self.dictionary[key] as? NSNumber {
			return value.floatValue
		}
		if let value = self.dictionary[key] as? String {
			return Float(value)
		}
		return nil
	}


	public func point(forKey key: String) -> CGPoint? {
		guard let pointDictionary =  self.dictionary[key] as? [String: AnyObject] else {
			return nil
		}
		guard let x = pointDictionary["x"] as? CGFloat else {
			return nil
		}
		guard let y = pointDictionary["y"] as? CGFloat else {
			return nil
		}
		return CGPoint(x: x, y: y)
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
