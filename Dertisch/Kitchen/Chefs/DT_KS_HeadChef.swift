//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol DTHeadChefForKitchenMember {
	mutating func give(dish: DTDish)
}

public protocol DTHeadChefForWaiter: DTGiveOrderProtocol {}

public protocol DTHeadChef: DTHeadChefForWaiter, DTHeadChefForKitchenMember, DTStartShiftProtocol, DTEndShiftProtocol {
	init(_ sousChefs: [String: DTKitchenMember]?)
	var waiter: DTWaiterForHeadChef? { get set }
}

public extension DTHeadChef {
	public func endShift() { flagNonImplementation() }
	public mutating func give(_ order: DTOrder) { flagNonImplementation() }
	public func startShift() { flagNonImplementation() }
}

public extension DTHeadChefForKitchenMember {
	public func give(dish: DTDish) {
//		lo()
		guard var waiter = DTFirstInstance().get(DTWaiterForHeadChef.self, from: Mirror(reflecting: self)) else { return }
		waiter.hand(dish)
	}
}