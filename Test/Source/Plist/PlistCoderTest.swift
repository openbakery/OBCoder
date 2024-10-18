//
// Created by René Pirringer on 17.03.21.
// Copyright (c) 2021 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import OBCoder


class PlistCoderTest: PlistCoder_Base_Test {

	var coder : PlistCoder!

	override func setUp() {
		super.setUp()
		coder = PlistCoder()
	}

	override func tearDown() {
		coder = nil
		super.tearDown()
	}


	func test_instance() {
		assertThat(coder, presentAnd(instanceOf(PlistCoder.self)))
		assertThat(coder, presentAnd(instanceOf(Coder.self)))
	}



	func test_empty_plistString() {
		let plistString = self.plistString()
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}


	func test_encode_string() {
		// when
		coder.encode("Demo", forKey: "Test")

		// then
		let plistString = self.plistString(data: ["Test": "Demo"])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}

	func test_encode_as_data() {
		// when
		coder.encode("Demo", forKey: "Test")

		// then
		let plistString = self.plistString(data: ["Test": "Demo"])
		let expectedData = plistString.data(using: .utf8)
		assertThat(coder.data, presentAnd(equalTo(expectedData)))
	}



	func test_encode_int() {
		// when
		coder.encode(1, forKey: "intValue")

		// then
		let plistString = self.plistString(data: ["intValue": 1])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}


	func test_encode_bool_true() {
		// when
		coder.encode(true, forKey: "KEY")

		// then
		let plistString = self.plistString(data: ["KEY": true])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}

	func test_encode_bool_false() {
		// when
		coder.encode(false, forKey: "KEY")

		// then
		let plistString = self.plistString(data: ["KEY": false])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}

	func test_encode_float() {
		// when
		coder.encode(Float(2), forKey: "KEY")

		// then
		let plistString = self.plistString(data: ["KEY": Float(2)])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}


	func test_encode_point() {
		let point = CGPoint(x: 10, y: 11)
		coder.encode(point, forKey:"point")

		// then
		let plistString = self.plistString(data: ["point": point])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}



	func test_encode_string_array() {
		coder.encode(["first", "second"], forKey:"array")

		// then
		let plistString = self.plistString(data: ["array": ["first", "second"]])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}


	func test_encode_int_array() {
		coder.encode([1,2,3], forKey:"array")

		// then
		let plistString = self.plistString(data: ["array": [1,2,3]])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}




	func test_encode_encodable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode(quadrilateral, forKey:"crop")

		// then
		let topLeft = self.plistValue(key: "topLeft", value: CGPoint(x: 1, y: 1), level: 1)
		assertThat(coder.xmlString, presentAnd(containsString(topLeft)))

		let bottomRight = self.plistValue(key: "bottomRight", value: CGPoint(x: 6, y: 6), level: 1)
		assertThat(coder.xmlString, presentAnd(containsString(bottomRight)))
	}


	func test_encode_encodable_array() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		coder.encode([quadrilateral, quadrilateral], forKey: "array")

		// then
		let topLeft = self.plistValue(key: "topLeft", value: CGPoint(x: 1, y: 1), level: 2)
		assertThat(coder.xmlString, presentAnd(containsString(topLeft)))
		let expectedString = """
	<key>array</key>
	<array>
		<dict>
			<key>bottomLeft</key>
"""
		assertThat(coder.xmlString, presentAnd(containsString(expectedString)))

	}


	func test_encode_encodable_as_root() {
		let simple = SimpleEncodable()
		coder.encode(simple)

		let plistString = self.plistString(data: ["key": "value"])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}

	@available(iOS 10, *)
	func test_encode_date() throws {
		// when
		let date = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)

		// when
		coder.encode(date, forKey: "date")

		// then
		let plistString = self.plistString(data: ["date": "2021-10-27T08:27:00Z"])
		assertThat(coder.xmlString, presentAnd(equalTo(plistString)))
	}


	func test_encode_dictionary() {
		
		coder.encode(["foo": "bar"], forKey: "dict")

		// then
		let expectedString = """
	<key>dict</key>
	<dict>
		<key>foo</key>
		<string>bar</string>
	</dict>
"""
		assertThat(coder.xmlString, presentAnd(containsString(expectedString)))

	}
}
