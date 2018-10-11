//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension DTHeadChef {
	public var instanceDescriptor: String { return String(describing: self) }
}

public protocol DTHeadChef: DTCleanUp {//: DTSwitchClassProtocol {
	init(waiter: DTWaiterForHeadChef, sousChefs: [String: DTKitchenMember]?)
}
