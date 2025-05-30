//
//  Decoder.swift
//  OBFoundation
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation

public protocol Decoder {

	typealias DecodeClosure<T> = (Decoder) -> T?
	
	func decode<T:Encodable>(type: T.Type) -> T?
	func decode<T>(forKey key: String, closure: DecodeClosure<T>) -> T?
	func decoder(forKey key: String) -> Decoder?
	func decodeArray<T>(forKey key: String, closure: DecodeClosure<T>) -> [T]?
	func string(forKey key: String) -> String?
	func bool(forKey key: String) -> Bool?
	func integer(forKey key: String) -> Int?
	func float(forKey key: String) -> Float?
	func point(forKey key: String) -> CGPoint?
	func stringArray(forKey key: String) -> [String]?
	func intArray(forKey key: String) -> [Int]?

	func string(forKey key: String, default: String) -> String
	func bool(forKey key: String, default: Bool) -> Bool
	func integer(forKey key: String, default: Int) -> Int
	
	func date(forKey key: String) -> Date?

	func dictionary(forKey key: String) -> [String: Any]?

	var keys: [String] { get }
}

public extension Decoder {
	
	func decode<T>(forKey key: String, closure: (Decoder) -> T?) -> T? {
		if let decoder = self.decoder(forKey: key) {
			return closure(decoder)
		}
		return nil
	}
	
	func decoder(forKeyPath path: String...) -> Decoder? {
		return self.decoder(forKeyPath: path)
	}

	func decoder(forKeyPath keyPath: [String]) -> Decoder? {
		if let key = keyPath.first {
			let result = self.decoder(forKey: key)
			return result?.decoder(forKeyPath: Array(keyPath.dropFirst()))
		}
		return self
	}
	

	func string(forKey key: String, default defaultValue: String) -> String {
		if let result = self.string(forKey: key) {
			return result
		}
		return defaultValue
	}

	func bool(forKey key: String, default defaultValue: Bool) -> Bool {
		if let result = self.bool(forKey: key) {
			return result
		}
		return defaultValue
	}

	func integer(forKey key: String, default defaultValue: Int) -> Int {
		if let result = self.integer(forKey: key) {
			return result
		}
		return defaultValue
	}

	@available(iOS 10, *)
	func date(forKey key: String) -> Date? {
		if let stringValue = string(forKey: key) {
			let formatter = ISO8601DateFormatter()
			return formatter.date(from: stringValue)
		}
		return nil
	}
	
}
