//
//  DictionaryCoderTest.swift
//  OBFoundationTests
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import SwiftHamcrest
@testable import OBCoder

class DictionaryCoderTest : XCTestCase {

	var coder : DictionaryCoder!

	override func setUp() {
		super.setUp()
		coder = DictionaryCoder()
	}

	override func tearDown() {
		coder = nil
		super.tearDown()
	}

	func test_instance() {
		assertThat(coder, presentAnd(instanceOf(DictionaryCoder.self)))
	}



	func test_empty_dictionary() {
		assertThat(coder.dictionary, hasCount(0))
	}


	func test_encode_string() {
		coder.encode("Test", forKey: "string")
		if let value = coder.dictionary["string"] as? String {
			assertThat(value, equalTo("Test"))
		} else {
			XCTFail("value not found")
		}
	}

	func test_encode_int() {
		coder.encode(123, forKey: "string")
		if let value = coder.dictionary["string"] as? Int {
			assertThat(value, equalTo(123))
		} else {
			XCTFail("value not found")
		}
	}

	func test_encode_float() {
		coder.encode(123.0, forKey: "float")
		if let value = coder.dictionary["float"] as? Float {
			assertThat(value, equalTo(123.0))
		} else {
			XCTFail("value not found")
		}
	}


	func test_encode_point() {
		let point = CGPoint(x: 10, y: 11)
		coder.encode(point, forKey:"point")
		if let pointDictionary = coder.dictionary["point"] as? [String: CGFloat] {
			assertThat(pointDictionary, hasEntry("x", 10))
			assertThat(pointDictionary, hasEntry("y", 11))
		} else {
			XCTFail("value not found")
		}
	}


	func test_encode_encodeable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode(quadrilateral, forKey:"crop")
		if let cropDictionary = coder.dictionary["crop"] as? [String: Any] {
			if let topLeft = cropDictionary["topLeft"] as? [String: CGFloat] {
				assertThat(topLeft, hasEntry("x", 1))
				assertThat(topLeft, hasEntry("y", 1))
			} else {
				XCTFail("topLeft not present")
			}
		} else {
			XCTFail("crop not present")
		}
	}


	func test_encode_array() {
		coder.encode(["first", "second"], forKey:"array")
		if let value = coder.dictionary["array"] as? [String] {
			assertThat(value, hasItem("first"))
			assertThat(value, hasItem("second"))
		} else {
			XCTFail("value not found")
		}
	}

	func test_encode_int_array() {
		coder.encode([1, 2], forKey:"array")
		if let value = coder.dictionary["array"] as? [Int] {
			assertThat(value, hasItem(1))
			assertThat(value, hasItem(2))
		} else {
			XCTFail("value not found")
		}
	}


	func test_encode_encodeable_array() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode([quadrilateral, quadrilateral], forKey:"array")

		if let value = coder.dictionary["array"] as? [Any] {

			if let dictionary = value.first as? [String: Any] {
				if let topLeft = dictionary["topLeft"] as? [String: CGFloat] {
					assertThat(topLeft, hasEntry("x", 1))
					assertThat(topLeft, hasEntry("y", 1))
				} else {
					XCTFail("topLeft not present")
				}
			} else {
				XCTFail("dictionary not present")
			}

		} else {
			XCTFail("array not present")
		}
	}


	func test_encode_encodable_as_root() {
		let simple = SimpleEncodable()
		coder.encode(simple)
		if let value = coder.dictionary["key"] as? String {
			assertThat(value, equalTo("value"))
		} else {
			XCTFail("value not present")
		}
	}


	func test_encode_root_and_key() {
		let simple = SimpleEncodable()
		coder.encode(simple)
		coder.encode("test", forKey: "test")
		if let value = coder.dictionary["key"] as? String {
			assertThat(value, equalTo("value"))
		} else {
			XCTFail("value not present")
		}

		if let value = coder.dictionary["test"] as? String {
			assertThat(value, equalTo("test"))
		} else {
			XCTFail("value not present")
		}

	}


	func test_encode_date() throws {
		// given
		let date = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)

		// when
		coder.encode(date, forKey: "date")

		// then
		let value = coder.dictionary["date"]
		assertThat(value, present())
		assertThat(value, presentAnd(instanceOf(String.self, and:equalTo("2021-10-27T08:27:00Z"))))
	}
}
