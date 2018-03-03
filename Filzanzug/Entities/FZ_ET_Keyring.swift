//
//  FZ_ET_Keyring.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension FZKeyring: FZKeyringProtocol {}

public struct FZKeyring {
	public var key: String { return _key }
	
	fileprivate var _key: String
	
	public init () { _key = NSUUID().uuidString }
}
