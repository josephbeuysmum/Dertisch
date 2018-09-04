//
//  DT_PT_VPworn_closet.swift
//  Dertisch
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTSwitchClassProtocol: DTDeallocatableProtocol, DTOrderReceivableProtocol {
	var instanceDescriptor: String { get }
//	init()
	func startShift()
}
