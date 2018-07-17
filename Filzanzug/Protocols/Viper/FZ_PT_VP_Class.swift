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
