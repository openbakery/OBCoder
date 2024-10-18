//
//  DictionaryCoderTest.swift
//  OBFoundationTests
//
//  Created by Rene Pirringer on 18.12.18.
//  Copyright © 2018 Rene Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import OBCoder

class DictionaryDecoderTest : XCTestCase {



	func test_decode_string() {
		let decoder = DictionaryDecoder(dictionary: ["string": "Test"])
		assertThat(decoder.string(forKey:"string"), presentAnd(equalTo("Test")))
	}

	func test_decode_boolean() {
		let decoder = DictionaryDecoder(dictionary: ["key": true])
		assertThat(decoder.bool(forKey:"key"), presentAnd(equalTo(true)))
	}

	func test_decode_boolean_from_string() {
		let decoder = DictionaryDecoder(dictionary: ["key": "true"])
		assertThat(decoder.bool(forKey:"key"), presentAnd(equalTo(true)))
	}

	func test_decode_boolean_value_false() {
		let decoder = DictionaryDecoder(dictionary: ["key": false])
		assertThat(decoder.bool(forKey:"key"), presentAnd(equalTo(false)))
	}


	func test_decode_boolean_value_false_from_string() {
		let decoder = DictionaryDecoder(dictionary: ["key": "false"])
		assertThat(decoder.bool(forKey:"key"), presentAnd(equalTo(false)))
	}


	func test_decode_int() {
		let decoder = DictionaryDecoder(dictionary: ["value": 123])
		assertThat(decoder.integer(forKey: "value"), presentAnd(equalTo(123)))
	}


	func test_decode_int_from_string() {
		let decoder = DictionaryDecoder(dictionary: ["value": "123"])
		assertThat(decoder.integer(forKey: "value"), presentAnd(equalTo(123)))
	}


	func test_decode_float() {
		// when
		let decoder = DictionaryDecoder(dictionary: ["value": 123.0])

		// then
		assertThat(decoder.float(forKey: "value"), presentAnd(equalTo(123.0)))
	}


	func test_decode_float_from_string() {
		// when
		let decoder = DictionaryDecoder(dictionary: ["value": "123.0"])

		// then
		assertThat(decoder.float(forKey: "value"), presentAnd(equalTo(123.0)))
	}


	func test_decode_point() {
		let decoder = DictionaryDecoder(dictionary: ["point": ["x": 10, "y":11]])
		let point = decoder.point(forKey: "point")
		assertThat(point, present())
		if let point = point {
			assertThat(point.x, equalTo(10))
			assertThat(point.y, equalTo(11))
		}
	}


	func test_decode_array() {
		let decoder = DictionaryDecoder(dictionary: ["array": ["x", "y"]])
		let array = decoder.stringArray(forKey:"array")
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem("x"))
		}
	}



	func test_decode_int_array() {
		let decoder = DictionaryDecoder(dictionary: ["array": [1, 2]])
		let array = decoder.intArray(forKey:"array")
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem(1))
			assertThat(array, hasItem(2))
		}
	}


	func test_decode_encodable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = DictionaryCoder()
		coder.encode(quadrilateral, forKey:"crop")

		let decoder = DictionaryDecoder(dictionary: coder.dictionary)

		let result = decoder.decode(forKey:"crop") { decoder in
			return Quadrilateral(decoder: decoder)
		}
		assertThat(result, presentAnd(instanceOf(Quadrilateral.self)))
		if let result = result {
			assertThat(result.topLeft.x, equalTo(1))
			assertThat(result.topLeft.y, equalTo(1))
		}
	}





	func test_decode_encodeable_array() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = DictionaryCoder()
		coder.encode([quadrilateral, quadrilateral], forKey:"crop")

		let decoder = DictionaryDecoder(dictionary: coder.dictionary)

		let result = decoder.decodeArray(forKey:"crop") { decoder in
			return Quadrilateral(decoder: decoder)
		}

		assertThat(result, present())
		if let result = result {
			assertThat(result, hasCount(2))
			if result.count > 1 {
				assertThat(result[0].topLeft.x, equalTo(1))
				assertThat(result[0].topLeft.y, equalTo(1))
			}

		}
	}


	func test_decode_encodable_root() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = DictionaryCoder()
		coder.encode(quadrilateral)
		let decoder = DictionaryDecoder(dictionary: coder.dictionary)
		let result = decoder.decode(type:Quadrilateral.self)
		assertThat(result?.topLeft.x, presentAnd(equalTo(1)))
		assertThat(result?.topLeft.y, presentAnd(equalTo(1)))
	}


	@available(iOS 10, *)
	func test_decode_date() {
		// given
		let decoder = DictionaryDecoder(dictionary: ["date": "2021-10-27T08:27:00Z"])

		// when
		let date = decoder.date(forKey: "date")

		// then
		let expectedDate = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)
		assertThat(date, presentAnd(equalTo(expectedDate)))
	}
	
	func test_decoder_for_key() {
		// given
		let decoder = DictionaryDecoder(dictionary: ["foo": [ "bar" : [ "baz": [ "id": "asdf" ]]]])
		
		// then
		assertThat(decoder.decoder(forKey: "foo"), presentAnd(instanceOf(OBCoder.DictionaryDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar"), presentAnd(instanceOf(OBCoder.DictionaryDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar")?.decoder(forKey:"baz")?.string(forKey: "id"), presentAnd(equalTo("asdf")))

	}
}
