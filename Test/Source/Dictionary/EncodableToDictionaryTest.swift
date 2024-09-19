//
// Created by Rene Pirringer on 2019-01-30.
// Copyright (c) 2019 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import OBCoder

class EncodableToDictionaryTest : XCTestCase {

	func test_dictionary_for_encodable() {
		let simple = SimpleEncodable()
		let dictionary = simple.toDictionary()
		assertThat(dictionary, hasKey("key"))
		if let value = dictionary["key"] as? String {
			assertThat(value, equalTo("value"))
		} else {
			XCTFail("value not found")
		}
	}


}
