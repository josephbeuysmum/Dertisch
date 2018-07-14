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
	
	fileprivate func assess(_ delegate: FZViperTemporaryNameProtocol) {
		let reflection = Mirror(reflecting: delegate)
		for (_, child) in reflection.children.enumerated() {
			if child.value is FZKeyring {
				fatalError("FZKeyring delegates can only possess one FZKeyring")
			}
		}
	}
}

public struct FZKeyring {
	fileprivate var key_: String
	
	public init (_ delegate: FZViperTemporaryNameProtocol) {
		key_ = NSUUID().uuidString
		assess(delegate)
	}
}
