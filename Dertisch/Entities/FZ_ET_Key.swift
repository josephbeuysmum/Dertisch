//
//  FZKey_.swift
//  Dertisch
//
//  Created by Richard Willis on 25/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

extension FZKey: FZKeyProtocol {
	public var teeth: String { return teeth_ }
}

public struct FZKey {
	fileprivate var teeth_: String
	
	public init (_ delegate: FZViperClassProtocol) {
		teeth_ = NSUUID().uuidString
		guaranteeSingleInstanceOfSelf(within: delegate)
	}
}
