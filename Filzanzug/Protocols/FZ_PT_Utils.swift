//
//  FZ_PT_Utils.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo deallocate in a better way, with weak vars etc
public protocol FZDeallocatableProtocol {
	func deallocate ()
}

public protocol FZDescribableProtocol {
	var description: String { get }
}

public protocol FZSignalReceivableProtocol {}

// [seemingly] deprecated
//public protocol FZIsActivatedProtocol {
//	var isActivated: Bool { get }
//}

//public protocol FZActivatableProtocol {
//	func activate ()
//}

//public protocol FZClassNameProtocol {
//	var instanceDescriptor: String { get }
//}

//public protocol FZInitableProtocol {
//	init ()
//}

