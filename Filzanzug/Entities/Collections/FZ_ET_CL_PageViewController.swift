//
//  FZ_ET_CL_PageViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 08/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPageViewControllerEntities: FZDeallocatableProtocol {
	public func deallocate () {}
}

public class FZPageViewControllerEntities {
	fileprivate let key_: String
	
	// todo needs routing injected
	public init (_ key: String) {
		key_ = key
	}
}
