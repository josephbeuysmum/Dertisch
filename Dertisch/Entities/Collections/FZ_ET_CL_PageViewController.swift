//
//  DT_ET_CL_PageDish.swift
//  Dertisch
//
//  Created by Richard Willis on 08/12/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension DTPageDishEntities: DTDeallocatableProtocol {
	public func cleanUp() {}
}

public class DTPageDishEntities {
	fileprivate let key_: String
	
	// todo needs routing injected
	public init (_ key: String) {
		key_ = key
	}
}
