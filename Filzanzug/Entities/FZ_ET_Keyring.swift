//
//  FZ_ETkey_ring.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

extension FZKeyring: FZKeyringProtocol {
	public var key: String { return key_ }
}

public struct FZKeyring {
	fileprivate var key_: String
	
	public init () { key_ = NSUUID().uuidString }
}
