//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol HeadChefForSousChef {
	mutating func give(prep: InternalOrder)
}

public protocol HeadChefForWaiter: GiveOrderProtocol {}

public protocol HeadChef: HeadChefForWaiter, HeadChefForSousChef, KitchenResource, StaffMember, SwitchesRelationshipProtocol {
	init(_ resources: [String: KitchenResource]?)
	var waiter: WaiterForHeadChef? { get set }
}

public extension HeadChef {
	public func beginBreak() { lo() }
	public func beginShift() { lo() }
	public func endBreak() { lo() }
	public func endShift() { lo() }
	public func give(_ order: OrderFromCustomer) { lo() }
}

public extension HeadChefForSousChef {
	public func give(prep: InternalOrder) {
		lo()
		let fulfilledOrder: FulfilledOrder
		if let dishes = prep.dishes as? Dishionarizer {
			fulfilledOrder = FulfilledOrder(prep.ticket, dishes: dishes)
		} else {
			fulfilledOrder = FulfilledOrder(prep.ticket)
		}
		Rota().waiterForHeadChef(self as? SwitchesRelationshipProtocol)?.serve(main: fulfilledOrder)
	}
}
