//
// Created by René Pirringer on 17.03.21.
// Copyright (c) 2021 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import OBCoder


class PlistDecoderTest: PlistCoder_Base_Test {

	func decoder(dictionary: [String: Any]) -> PlistDecoder? {
		let plistString = self.plistString(data: dictionary)
		if let data = plistString.data(using: .utf8) {
			return PlistDecoder(data: data)
		}
		return nil
	}


	func test_instance() {
		let decoder = self.decoder(dictionary:[:])

		// then
		assertThat(decoder, presentAnd(instanceOf(Decoder.self)))
		assertThat(decoder, presentAnd(instanceOf(PlistDecoder.self)))
	}

	func test_decode_string_1() {
		// when
		let decoder = self.decoder(dictionary: ["string": "Test"])
		
		// then
		assertThat(decoder?.string(forKey: "string"), presentAnd(equalTo("Test")))
	}
	
	
	func test_decode_string_2() {
		// when
		let decoder = self.decoder(dictionary: ["string": "Foo"])
		
		// then
		assertThat(decoder?.string(forKey: "string"), presentAnd(equalTo("Foo")))
	}


	func test_decode_boolean_true() {
		let decoder = self.decoder(dictionary: ["key": true])

		// then
		assertThat(decoder?.bool(forKey: "key"), presentAnd(equalTo(true)))
	}

	func test_decode_boolean_false() {
		let decoder = self.decoder(dictionary: ["key": false])

		// then
		assertThat(decoder?.bool(forKey: "key"), presentAnd(equalTo(false)))
	}


	func test_decode_int() {
		let decoder = self.decoder(dictionary: ["key": 123])

		// then
		assertThat(decoder?.integer(forKey: "key"), presentAnd(equalTo(123)))
	}


	func test_decode_float() {
		let decoder = self.decoder(dictionary: ["key": Float(123.2)])

		// then
		assertThat(decoder?.float(forKey: "key"), presentAnd(equalTo(123.2)))
	}


	func test_decode_point() {
		let decoder = self.decoder(dictionary: ["point": CGPoint(x: 10, y: 11)])

		// when
		let point = decoder?.point(forKey: "point")

		// then
		assertThat(point, present())
		if let point = point {
			assertThat(point.x, equalTo(10))
			assertThat(point.y, equalTo(11))
		}
	}


	func test_decode_array() {
		let decoder = self.decoder(dictionary:  ["array": ["x", "y"]])

		// when
		let array = decoder?.stringArray(forKey: "array")

		// then
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem("x"))
		}
	}


	func test_decode_int_array() {
		let decoder = self.decoder(dictionary: ["array": [1, 2]])

		// when
		let array = decoder?.intArray(forKey: "array")

		// then
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem(1))
			assertThat(array, hasItem(2))
		}
	}


	func test_decode_encodable() throws {
		// given
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = PlistCoder()
		coder.encode(quadrilateral, forKey: "crop")
		let data = try XCTUnwrap(coder.data)

		// when
		let decoder = PlistDecoder(data: data)

		let result = decoder.decode(forKey: "crop") { decoder in
			return Quadrilateral(decoder: decoder)
		}
		assertThat(result, presentAnd(instanceOf(Quadrilateral.self)))
		if let result = result {
			assertThat(result.topLeft.x, equalTo(1))
			assertThat(result.topLeft.y, equalTo(1))
		}
	}


	func test_decode_encodable_array() throws {
		// given
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = PlistCoder()
		coder.encode([quadrilateral, quadrilateral], forKey: "crop")
		let data = try XCTUnwrap(coder.data)

		// when
		let decoder = PlistDecoder(data: data)
		let result = decoder.decodeArray(forKey: "crop") { decoder in
			return Quadrilateral(decoder: decoder)
		}

		// then
		assertThat(result, present())
		if let result = result {
			assertThat(result, hasCount(2))
			if result.count > 1 {
				assertThat(result[0].topLeft.x, equalTo(1))
				assertThat(result[0].topLeft.y, equalTo(1))
			}

		}
	}


	func test_decode_encodable_root() throws {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = PlistCoder()
		coder.encode(quadrilateral)
		let data = try XCTUnwrap(coder.data)

		// when
		let decoder = PlistDecoder(data: data)

		// when
		let result = decoder.decode(type: Quadrilateral.self)
		assertThat(result?.topLeft.x, presentAnd(equalTo(1)))
		assertThat(result?.topLeft.y, presentAnd(equalTo(1)))
	}


	func test_decode_date() {
		// when
		let decoder = self.decoder(dictionary: ["date": "2021-10-27T08:27:00Z"])

		// then
		let date = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)
		assertThat(decoder?.date(forKey: "date"), presentAnd(equalTo(date)))
	}

	func test_decode_dictionary() throws {
		// when
		let coder = PlistCoder()
		coder.encode(["Foo":"Bar"], forKey: "dictionary")
		let data = try XCTUnwrap(coder.xmlString?.data(using:.utf8))
		
		let decoder = PlistDecoder(data: data)

		// then
		assertThat(decoder.dictionary(forKey: "dictionary"), presentAnd(instanceOf([String: Any].self)))
		assertThat(decoder.dictionary(forKey: "dictionary")?["Foo"], presentAnd(instanceOfAnd(equalTo("Bar"))))
	}
	
	
	func test_decoder_for_key() {
		// given
		
		let decoder = PlistDecoder(dictionary: ["foo": [ "bar" : [ "baz": [ "id": "asdf" ]]]])
		
		// then
		assertThat(decoder.decoder(forKey: "foo"), presentAnd(instanceOf(OBCoder.PlistDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar"), presentAnd(instanceOf(OBCoder.PlistDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar")?.decoder(forKey:"baz")?.string(forKey: "id"), presentAnd(equalTo("asdf")))

	}

}
