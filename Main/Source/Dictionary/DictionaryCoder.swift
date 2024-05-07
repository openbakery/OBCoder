//
//  DictionaryCoder.swift
//  OBFoundation
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation

open class DictionaryCoder : OBCoder.Coder {


	public var dictionary = [String:Any]()
	
	public init() {
	}
	
	public func encode(_ encodeable: Encodable) {
		encodeable.encode(with: self)
	}
	
	public func encode(_ string: String, forKey key: String) {
		self.dictionary[key] = string
	}
	
	public func encode(_ boolValue: Bool, forKey key: String) {
	}
	
	public func encode(_ number: Int, forKey key: String) {
		self.dictionary[key] = number
	}

	public func encode(_ number: Float, forKey key: String) {
		self.dictionary[key] = number
	}


	public func encode(_ point: CGPoint, forKey key: String) {
		
		self.dictionary[key] = [
			"x": point.x,
			"y": point.y
		]
		
	}
	
	public func encode(_ encodeable: Encodable, forKey key: String) {
		let coder = DictionaryCoder()
		encodeable.encode(with: coder)
		dictionary[key] = coder.dictionary
	}
	
	public func encode(_ array: [String], forKey key: String) {
		self.dictionary[key] = array
	}
	
	public func encode(_ array: [Int], forKey key: String) {
		self.dictionary[key] = array
	}
	
	public func encode(_ array: [Encodable], forKey key: String) {
		var dataArray = [Any]()
		for encodable in array {
			let coder = DictionaryCoder()
			encodable.encode(with: coder)
			dataArray.append(coder.dictionary)
		}
		self.dictionary[key] = dataArray
	}
	
	public func encode(objects: [AnyObject], forKey key: String) {
	}


}
