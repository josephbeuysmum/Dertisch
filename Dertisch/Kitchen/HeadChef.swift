//
//  HeadChef.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

fileprivate class HeadChefFacets {
	let
	forWaiter: HeadChefForWaiter,
	forSousChef: HeadChefForSousChef?
	
	init(_ forWaiter: HeadChefForWaiter, _ forSousChef: HeadChefForSousChef?) {
		self.forWaiter = forWaiter
		self.forSousChef = forSousChef
	}
}

fileprivate var rota: [String: HeadChefFacets] = [:]



public protocol HeadChefFacet {
	init(_ headChef: HeadChef)
}

// tood why is class here and not in SimpleColleagueProtocol?
public protocol HeadChefForSousChef: class, HeadChefFacet, SimpleColleagueProtocol {
	func give(prep: InternalOrder)
}

public protocol HeadChefForWaiter: class, HeadChefFacet, SimpleColleagueProtocol, GiveCustomerOrderable {}



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



public protocol HeadChefProtocol {
	func forWaiter(by key: String) -> HeadChefForWaiter?
	func forSousChef(by key: String) -> HeadChefForSousChef?
	func waiter(by key: String) -> WaiterForHeadChef?
}

internal protocol HeadChefInternalProtocol: ComplexColleagueProtocol, StaffMember {
	init(
		_ key: String,
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ resources: [String: KitchenResource]?)
	func inject(_ waiter: WaiterForHeadChef?)
}

public class HeadChef: HeadChefInternalProtocol {
	fileprivate let privateKey: String
	
	fileprivate var waiter: WaiterForHeadChef?
	
	internal required init(
		_ key: String,
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ resources: [String: KitchenResource]?) {
		privateKey = key
		if let strongWaiterType = forWaiterType {
			let waiter = strongWaiterType.init(self)
			let sousChef: HeadChefForSousChef?
			if let strongSousChefType = forSousChefType {
				sousChef = strongSousChefType.init(self)
			} else {
				sousChef = nil
			}
			rota[privateKey] = HeadChefFacets(waiter, sousChef)
		}
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension HeadChef: HeadChefProtocol {
	public func forWaiter(by key: String) -> HeadChefForWaiter? {
		return rota[key]?.forWaiter
	}
	
	public func forSousChef(by key: String) -> HeadChefForSousChef? {
		return rota[key]?.forSousChef
	}
	
	public func waiter(by key: String) -> WaiterForHeadChef? {
		return key == privateKey ? waiter : nil
	}
}

extension HeadChef {
	internal var internalKey: String {
		return privateKey
	}
	
	internal func inject(_ waiter: WaiterForHeadChef?) {
		self.waiter = waiter
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
