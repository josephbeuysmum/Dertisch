//
//  HeadChef.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

fileprivate struct HeadChefFacets {
	let
	forWaiter: HeadChefForWaiter,
	forSousChef: HeadChefForSousChef?
}

fileprivate var rota: [String: HeadChefFacets] = [:]



// tood why is class here and not in SimpleColleagueProtocol?
public protocol HeadChefForSousChef: class, SimpleColleagueProtocol {
	func give(prep: InternalOrder)
}

public protocol HeadChefForWaiter: SimpleColleagueProtocol, GiveCustomerOrderable {}



extension HeadChefForSousChef {
	public func give(prep: InternalOrder) {
		lo("commented out presently 2")
//		let fulfilledOrder = FulfilledOrder(prep.ticket, dishes: prep.dishes as? Dishionarizer)
//		Rota().waiterForHeadChef(self as? StaffRelatable)?.serve(main: fulfilledOrder)
	}
}

extension HeadChefForWaiter {
	public func give(_ order: CustomerOrder) {
		lo(rota.count, self)
	}
}



internal protocol HeadChefProtocol: ComplexColleagueProtocol, BeginShiftable, EndShiftable, StaffMember, StaffRelatable {
	init(_ name: String, _ resources: [String: KitchenResource]?)
	func inject(
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ waiter: WaiterForHeadChef?)
}

internal class HeadChef {
	fileprivate let name: String
	
	fileprivate var waiter: WaiterForHeadChef?
	
	internal required init(_ name: String, _ resources: [String: KitchenResource]?) {
		self.name = name
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension HeadChef: HeadChefProtocol {
	internal func inject(
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ waiter: WaiterForHeadChef?) {
		self.waiter = waiter
		if let strongWaiterType = forWaiterType {
			let waiter = strongWaiterType.init()
			let sousChef: HeadChefForSousChef?
			if let strongSousChefType = forSousChefType {
				sousChef = strongSousChefType.init()
			} else {
				sousChef = nil
			}
			rota[name] = HeadChefFacets(forWaiter: waiter, forSousChef: sousChef)
		}

	}
	
	internal func forSousChef() -> HeadChefForSousChef? {
		return rota[name]?.forSousChef
	}
	
	internal func forWaiter() -> HeadChefForWaiter? {
		return rota[name]?.forWaiter
	}
	
	internal func beginShift() {
		lo()
	}
	internal func endShift() {
		lo()
	}
}
