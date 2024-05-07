//
// Created by Rene Pirringer on 18/08/2017.
// Copyright (c) 2017 René Pirringer. All rights reserved.
//

import Foundation

public protocol Encodable {

	func encode(with: Coder)
	init?(decoder: Decoder)

}
