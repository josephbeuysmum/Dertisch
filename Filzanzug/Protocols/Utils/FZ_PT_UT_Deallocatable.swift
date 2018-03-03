//
//  FZ_PT_UT_Deallocatable.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

// todo deallocate in a better way, with weak vars etc
public protocol FZDeallocatableProtocol {
	func deallocate ()
}
