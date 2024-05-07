//
// Created by Rene Pirringer on 18/08/2017.
// Copyright (c) 2017 René Pirringer. All rights reserved.
//

import Foundation


open class JSONCoder : Coder {


  var data = [String: AnyObject]()

  public var jsonString : String {
    get {
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options:.prettyPrinted)
        if let result = String(data: jsonData, encoding: .utf8) {
          return result
        }
      } catch {
				return "{}"
      }
      return "{}"
    }
  }

  public init() {
  }

  public func encode(_ encodeable: Encodable) {
    let coder = JSONCoder()
    encodeable.encode(with: coder)
		self.data = self.data.merging(coder.data) { (current, _) in current } 
  }

  public func encode(_ string: String, forKey key: String) {
    encodeObject(string as AnyObject, forKey: key)
  }

  public func encode(_ boolValue: Bool, forKey key: String) {
    encodeObject(NSNumber(value:boolValue), forKey: key)
  }

  public func encode(_ number: Int, forKey key: String) {
    encodeObject(NSNumber(value:number), forKey: key)
  }

  public func encode(_ number: Float, forKey key: String) {
    encodeObject(NSNumber(value:number), forKey: key)
  }


  public func encode(_ point: CGPoint, forKey key: String) {
    let pointDictionary = [
      "x": NSNumber(value:Float(point.x)),
      "y": NSNumber(value:Float(point.y))
    ]
    encodeObject(pointDictionary as AnyObject, forKey:key)
  }

  func encodeObject(_ object: AnyObject, forKey key: String) {
    data[key] = object
  }

  public func encode(_ encodeable: Encodable, forKey key: String) {
    let coder = JSONCoder()
    encodeable.encode(with: coder)
    encodeObject(coder.data as AnyObject, forKey:key)
  }


  public func encode(_ array: [String], forKey key: String) {
    encodeObject(array as AnyObject, forKey: key)
  }

  public func encode(_ array: [Int], forKey key: String) {
    encodeObject(array as AnyObject, forKey: key)
  }


  public func encode(_ array: [Encodable], forKey key: String) {
    var dataArray = [AnyObject]()
    for encodable in array {
      let coder = JSONCoder()
      encodable.encode(with: coder)
      dataArray.append(coder.data as AnyObject)
    }
    encodeObject(dataArray as AnyObject, forKey: key)
  }

  public func encode(objects: [AnyObject], forKey key: String) {
    encodeObject(objects as AnyObject, forKey: key)
  }


	
	public func encode(_ dictionary: [String: Any], forKey key: String) {
		data[key] = dictionary as AnyObject
  }
	
}
