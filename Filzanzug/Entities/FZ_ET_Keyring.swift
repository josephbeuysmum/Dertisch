//
//  FZ_ETkey_.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

extension FZKeyring: FZKeyringProtocol {
	public var hash: String { return key_ }
}

public struct FZKeyring {
	fileprivate var key_: String
	
	public init (delegate: FZViperClassProtocol) {
		key_ = NSUUID().uuidString
		guaranteeSingleInstanceOfSelf(within: delegate)
	}
}
