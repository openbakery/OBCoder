//
//  Coder.swift
//  OBFoundation
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation

public protocol Coder {

	func encode(_ encodable: Encodable)
	func encode(_ string: String, forKey key: String)
	func encode(_ boolValue: Bool, forKey key: String)
	func encode(_ number: Int, forKey key: String)
	func encode(_ number: Float, forKey key: String)
	func encode(_ point: CGPoint, forKey key: String)
	func encode(_ encodable: Encodable, forKey key: String)
	func encode(_ array: [String], forKey key: String)
	func encode(_ array: [Int], forKey key: String)
	func encode(_ array: [Encodable], forKey key: String)
	func encode(objects: [AnyObject], forKey key: String)
	func encode(_ date: Date, forKey key: String)

}


public extension Coder {

	func encode(_ date: Date, forKey key: String) {
		let formatter = ISO8601DateFormatter()
		let stringValue = formatter.string(from: date)
		self.encode(stringValue, forKey: key)
	}
}
