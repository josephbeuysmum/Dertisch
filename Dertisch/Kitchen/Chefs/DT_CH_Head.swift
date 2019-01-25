//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol HeadChefForSousChef {
	mutating func give(dishes: FulfilledOrder)
}

public protocol HeadChefForWaiter: GiveOrderProtocol {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForSousChef, KitchenResource, StaffMember, SwitchesRelationshipProtocol {
	init(_ resources: [String: KitchenResource]?)
	var waiter: WaiterForHeadChef? { get set }
}

public extension HeadChef {
	public func endBreak() {}
	public func end() {}
	public func give(_ order: Order) {}
	public func startBreak() {}
	public func begin() {}
}

public extension HeadChefForSousChef {
	public func give(dishes: FulfilledOrder) {
		Rota().waiterForHeadChef(self as? SwitchesRelationshipProtocol)?.serve(main: dishes)
	}
}
