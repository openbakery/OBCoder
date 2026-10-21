//
//  SimpleEncodable.swift
//  OBFoundationTests
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation
@testable import OBCoder


class SimpleEncodable: OBCoder.Encodable {
	func encode(with coder: OBCoder.Coder) {
		coder.encode(value, forKey: "key")
	}
	
	init(value: String = "value") {
		self.value = value
	}
	
	let value: String
	
	required init?(decoder: OBCoder.Decoder) {
		guard let value = decoder.string(forKey: "key") else { return nil }
		self.value = value
	}
}
