//
// Created by Rene Pirringer on 2019-01-30.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation

public extension Encodable {

	func toDictionary() -> [String: Any] {
		let coder = OBCoder.DictionaryCoder()
		coder.encode(self)
		return coder.dictionary

	}
}
