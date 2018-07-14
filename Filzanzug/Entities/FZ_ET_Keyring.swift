//
//  FZKey_.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

extension FZKey: FZKeyProtocol {
	public var hash: String { return hash_ }
}

public struct FZKey {
	fileprivate var hash_: String
	
	public init (_ delegate: FZViperClassProtocol) {
		hash_ = NSUUID().uuidString
		guaranteeSingleInstanceOfSelf(within: delegate)
	}
}
