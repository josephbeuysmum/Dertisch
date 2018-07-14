//
//  FZ_PT_VPworn_closet.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZViperClassProtocol: FZDeallocatableProtocol, FZSignalReceivableProtocol {
	var instanceDescriptor: String { get }
	init()
	func activate()
}

public extension FZViperClassSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf(within delegate: FZViperClassProtocol) {
		let reflection = Mirror(reflecting: delegate)
		for (_, child) in reflection.children.enumerated() {
			if child.value is Self {
				fatalError("FZKeyring delegates can only possess one FZKeyring")
			}
		}
		lo("all good!")
	}
}

public protocol FZViperClassSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf(within delegate: FZViperClassProtocol)
}
