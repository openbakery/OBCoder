//
//  Quadrilateral.swift
//  OBCoderTests
//
//  Created by René Pirringer on 07.05.24.
//

import Foundation

@testable import OBCoder

public struct Quadrilateral: Encodable, Equatable {

    public enum Corner: Int {
        case topLeft = 0
        case topRight
        case bottomLeft
        case bottomRight
    }

    public enum Edge: Int {
        case top = 0
        case bottom
        case left
        case right
    }

    public static let zero = Quadrilateral(
        topLeft: .zero, topRight: .zero, bottomLeft: .zero, bottomRight: .zero)

    public var topLeft: CGPoint
    public var topRight: CGPoint
    public var bottomLeft: CGPoint
    public var bottomRight: CGPoint

    public init(topLeft: CGPoint, topRight: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public init?(decoder: OBCoder.Decoder) {
        guard let topLeft = decoder.point(forKey: "topLeft") else {
            return nil
        }
        guard let topRight = decoder.point(forKey: "topRight") else {
            return nil
        }
        guard let bottomLeft = decoder.point(forKey: "bottomLeft") else {
            return nil
        }
        guard let bottomRight = decoder.point(forKey: "bottomRight") else {
            return nil
        }
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public func encode(with coder: Coder) {
        coder.encode(topLeft, forKey: "topLeft")
        coder.encode(topRight, forKey: "topRight")
        coder.encode(bottomLeft, forKey: "bottomLeft")
        coder.encode(bottomRight, forKey: "bottomRight")
    }

}
