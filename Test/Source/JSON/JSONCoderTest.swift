//
// Created by Rene Pirringer on 18/08/2017.
// Copyright (c) 2017 René Pirringer. All rights reserved.
//

import Foundation
import XCTest
import SwiftHamcrest
@testable import OBCoder


class JSONCoderTest : XCTestCase {

	var coder : JSONCoder!

	override func setUp() {
		super.setUp()
		coder = JSONCoder()
	}

	override func tearDown() {
		coder = nil
		super.tearDown()
	}

	func test_instance() {
		assertThat(coder, presentAnd(instanceOf(JSONCoder.self)))
	}

	func test_empty_jsonString() {
		assertThat(coder.jsonString, equalTo("{\n\n}"))
	}

	func test_encode_string() {
		coder.encode("Test", forKey: "string")
		assertThat(coder.jsonString, containsString("\"string\" : \"Test\""))
	}

	func test_encode_int() {
		coder.encode(1, forKey:"value")
		assertThat(coder.jsonString, containsString("\"value\" : 1"))
	}


	func test_encode_float() {
		coder.encode(1.1, forKey:"value")
		assertThat(coder.jsonString, containsString("\"value\" : 1.1"))
	}


	func test_encode_point() {
		let point = CGPoint(x: 10, y: 11)
		coder.encode(point, forKey:"point")
		assertThat(coder.jsonString, containsString("\"point\" : {\n    \""))
		assertThat(coder.jsonString, containsString("\"y\" : 11"))
		assertThat(coder.jsonString, containsString("\"x\" : 10"))
		assertThat(coder.jsonString, hasSuffix("}"))
	}

	func test_encode_encodeable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode(quadrilateral, forKey:"crop")
		assertThat(coder.jsonString, containsString("\"crop\" : {\n    \""))
		assertThat(coder.jsonString, containsString("\"topLeft\" : "))
	}

	func test_encode_array() {
		coder.encode(["first", "second"], forKey:"array")
		assertThat(coder.jsonString, containsString("\"array\" : [\n    \"first\",\n    \"second\"\n  ]"))
	}


	func test_encode_int_array() {
		coder.encode([1, 2], forKey:"array")
		assertThat(coder.jsonString, containsString("\"array\" : [\n    1,\n    2\n  ]"))
	}

	func test_encode_encodeable_array() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode([quadrilateral, quadrilateral], forKey:"array")
		assertThat(coder.jsonString, containsString("\"array\" : [\n    {\n      \""))
		assertThat(coder.jsonString, containsString("\"bottomLeft"))
	}



	func test_encode_encodable_as_root() {
		let simple = SimpleEncodable()
		coder.encode(simple)
		assertThat(coder.jsonString, equalTo("{\n  \"key\" : \"value\"\n}"))
	}

	func test_encode_root_and_key() {
		let simple = SimpleEncodable()
		coder.encode(simple)
		coder.encode("test", forKey: "test")
		assertThat(coder.jsonString, containsString("\"key\" : \"value\""))
		assertThat(coder.jsonString, containsString("\"test\" : \"test\""))

	}


	func test_encode_date() throws {
		// given
		let date = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)

		// when
		coder.encode(date, forKey: "date")

		// then
		assertThat(coder.jsonString, containsString("\"date\" : \"2021-10-27T08:27:00Z\""))
	}
	
	func test_encode_dictionary() throws {
		
		let dictionary = ["foo": "bar"]
		
		// when
		coder.encode(dictionary, forKey: "dictionary")

		// then
		assertThat(coder.jsonString, containsString("\"dictionary\" : {"))
		assertThat(coder.jsonString, containsString("\"foo\" : \"bar\""))
		assertThat(coder.jsonString, hasSuffix("}"))
		
	}

}
