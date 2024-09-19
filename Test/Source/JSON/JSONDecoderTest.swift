//
// Created by Rene Pirringer on 18/08/2017.
// Copyright (c) 2017 René Pirringer. All rights reserved.
//

import Foundation
import XCTest
import Hamcrest
@testable import OBCoder

class JSONDecoderTest : XCTestCase {

	func test_decode_string() {
		let decoder = JSONDecoder(jsonString: "{\"string\":\"Test\"}")
		assertThat(decoder.string(forKey:"string"), presentAnd(equalTo("Test")))
	}

	func test_decode_boolean() {
		let decoder = JSONDecoder(jsonString: "{\"wasUploaded\": true }")
		assertThat(decoder.bool(forKey:"wasUploaded"), presentAnd(equalTo(true)))
	}

	func test_decode_boolean_from_string() {
		let decoder = JSONDecoder(jsonString: "{\"wasUploaded\": \"true\" }")
		assertThat(decoder.bool(forKey:"wasUploaded"), presentAnd(equalTo(true)))
	}

	func test_decode_boolean_value_false() {
		let decoder = JSONDecoder(jsonString: "{\"wasUploaded\": false }")
		assertThat(decoder.bool(forKey:"wasUploaded"), presentAnd(equalTo(false)))
	}

	func test_decode_boolean_value_false_from_string() {
		let decoder = JSONDecoder(jsonString: "{\"wasUploaded\": \"false\" }")
		assertThat(decoder.bool(forKey:"wasUploaded"), presentAnd(equalTo(false)))
	}


	func test_decode_int() {
		let decoder = JSONDecoder(jsonString: "{\"value\": 123 }")
		assertThat(decoder.integer(forKey: "value"), presentAnd(equalTo(123)))
	}


	func test_decode_int_from_string() {
		let decoder = JSONDecoder(jsonString: "{\"value\": \"123\" }")
		assertThat(decoder.integer(forKey: "value"), presentAnd(equalTo(123)))
	}

	func test_decode_float() {
		// given
		let decoder = JSONDecoder(jsonString: "{\"value\": 123.0 }")

		// when
		assertThat(decoder.float(forKey: "value"), presentAnd(equalTo(123.0)))
	}

	func test_decode_float_from_string() {
		// given
		let decoder = JSONDecoder(jsonString: "{\"value\": \"123.0\" }")

		// when
		assertThat(decoder.float(forKey: "value"), presentAnd(equalTo(123.0)))
	}

	func test_decode_point() {
		let decoder = JSONDecoder(jsonString: "{\"point\": {\"x\": 10, \"y\": 11}}")

		let point = decoder.point(forKey: "point")
		assertThat(point, present())
		if let point = point {
			assertThat(point.x, equalTo(10))
			assertThat(point.y, equalTo(11))
		}
	}

	func test_decode_encodeable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = JSONCoder()
		coder.encode(quadrilateral, forKey:"crop")

		let decoder = JSONDecoder(jsonString: coder.jsonString)

		let result = decoder.decode(forKey:"crop") { decoder in
			return Quadrilateral(decoder: decoder)
		}
		assertThat(result, presentAnd(instanceOf(Quadrilateral.self)))
		if let result = result {
			assertThat(result.topLeft.x, equalTo(1))
			assertThat(result.topLeft.y, equalTo(1))
		}
	}

	func test_decode_array() {
		let decoder = JSONDecoder(jsonString: "{\"array\": [\"x\", \"y\"]}")
		let array = decoder.stringArray(forKey:"array")
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem("x"))
		}
	}

	func test_decode_int_array() {
		let decoder = JSONDecoder(jsonString: "{\"array\": [1, 2]}")
		let array = decoder.intArray(forKey:"array")
		assertThat(array, presentAnd(hasCount(2)))
		if let array = array {
			assertThat(array, hasItem(1))
			assertThat(array, hasItem(2))
		}
	}

	func test_decode_encodeable_array() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = JSONCoder()
		coder.encode([quadrilateral, quadrilateral], forKey:"crop")

		let decoder = JSONDecoder(jsonString: coder.jsonString)

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


	func test_decode_encodable() {
		let quadrilateral = Quadrilateral(topLeft: CGPoint(x: 1, y: 1), topRight: CGPoint(x: 5, y: 1), bottomLeft: CGPoint(x: 2, y: 5), bottomRight: CGPoint(x: 6, y: 6))
		let coder = JSONCoder()
		coder.encode(quadrilateral)
		let decoder = OBCoder.JSONDecoder(jsonString: coder.jsonString)
		let result = decoder.decode(type:Quadrilateral.self)
		assertThat(result, presentAnd(instanceOf(Quadrilateral.self)))
		assertThat(result?.topLeft.x, presentAnd(equalTo(1)))
		assertThat(result?.topLeft.y, presentAnd(equalTo(1)))
	}


	func test_decode_with_default_values() {
		let decoder = OBCoder.JSONDecoder(jsonString: "{}", defaultValues: ["string": "Test"])
		assertThat(decoder.string(forKey:"string"), presentAnd(equalTo("Test")))
	}


	func test_decode_with_default_values_are_overriden() {
		let decoder = OBCoder.JSONDecoder(jsonString: "{\"string\":\"TestOverriden\"}", defaultValues: ["string": "Test"])
		assertThat(decoder.string(forKey:"string"), presentAnd(equalTo("TestOverriden")))
	}


	func test_decode_date() {
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: "{\"date\":\"2021-10-27T08:27:00Z\"}", defaultValues: ["string": "Test"])

		// when
		let date = decoder.date(forKey: "date")

		// then
		let expectedDate = DateBuilder.create(year: 2021, month: 10, day: 27, hour: 10, minute: 27)
		assertThat(date, presentAnd(equalTo(expectedDate)))
	}

	func test_decode_dictionary() {
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: "{\"dictionary\":{\"foo\": \"bar\"} }", defaultValues: [:])

		// when
		let dictionary = decoder.dictionary(forKey: "dictionary")

		// then
		assertThat(dictionary, presentAnd(instanceOf([String: Any].self)))
		assertThat(dictionary?["foo"], presentAnd(instanceOfAnd(equalTo("bar"))))
	}
	
	func test_decode_tree() {
		
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: """
{ 
	"foo": {
		"bar": {
			"baz": {
				"id": "1234"
			}
		},
		"bar1": "asdf"
	}
}
""")
		
		
		let value = decoder.decode(forKey: "foo") { coder1 in
			coder1.decode(forKey: "bar") { coder2 in
				coder2.decode(forKey: "baz") { coder3 in
					return coder3.string(forKey: "id")
				}
			}
		}
		
		assertThat(value, equalTo("1234"))

	}


	func test_decoder_for_key() {
		
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: """
{
"foo": {
 "bar": {
	"baz": {
	 "id": "1234"
	}
 },
}
}
""")
		
		
		assertThat(decoder.decoder(forKey: "foo"), presentAnd(instanceOf(OBCoder.JSONDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar"), presentAnd(instanceOf(OBCoder.JSONDecoder.self)))
		assertThat(decoder.decoder(forKey: "foo")?.decoder(forKey: "bar")?.decoder(forKey:"baz")?.string(forKey: "id"), presentAnd(equalTo("1234")))

	}

	
	func test_decoder_for_key_array() {
		
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: """
{
"foo": {
 "bar": {
	"baz": {
	 "id": "1234"
	}
 },
}
}
""")
		
		
		assertThat(decoder.decoder(forKeyPath: ["foo", "bar", "baz"])?.string(forKey: "id"), presentAnd(equalTo("1234")))

	}
	
	func test_decoder_for_KeyPath() {
		
		// given
		let decoder = OBCoder.JSONDecoder(jsonString: """
{
"foo": {
 "bar": {
	"baz": {
	 "id": "1234"
	}
 },
}
}
""")
		
		
		assertThat(decoder.decoder(forKeyPath: "foo", "bar", "baz")?.string(forKey: "id"), presentAnd(equalTo("1234")))

	}

}
