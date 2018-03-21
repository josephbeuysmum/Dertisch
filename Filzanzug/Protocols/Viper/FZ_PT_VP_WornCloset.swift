//
//  FZ_PT_VPworn_closet.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZWornClosetImplementerProtocol: FZWornClosetEntityProtocol, FZDeallocatableProtocol {
	// formerly also: FZActivatableProtocol, FZClassNameProtocol, FZInitableProtocol
	var className: String { get }
	init ()
	func activate ()
}
