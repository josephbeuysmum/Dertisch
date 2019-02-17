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
	var forWaiter: HeadChefForWaiter? { get }
	var forSousChef: HeadChefForSousChef? { get }
}

internal protocol HeadChefInternalProtocol: ComplexColleagueProtocol, StaffMember {
	init(_ name: String, _ resources: [String: KitchenResource]?)
	func inject(
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ waiter: WaiterForHeadChef?)
}

public class HeadChef: HeadChefInternalProtocol {
	fileprivate let name: String
	
	fileprivate var waiter: WaiterForHeadChef?
	
	internal required init(_ name: String, _ resources: [String: KitchenResource]?) {
		self.name = name
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension HeadChef: HeadChefProtocol {
	public var forWaiter: HeadChefForWaiter? {
		return rota[name]?.forWaiter
	}
	
	public var forSousChef: HeadChefForSousChef? {
		return rota[name]?.forSousChef
	}
}

extension HeadChef {
	internal func inject(
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ waiter: WaiterForHeadChef?) {
		self.waiter = waiter
		if let strongWaiterType = forWaiterType {
			let waiter = strongWaiterType.init(self)
			let sousChef: HeadChefForSousChef?
			if let strongSousChefType = forSousChefType {
				sousChef = strongSousChefType.init(self)
			} else {
				sousChef = nil
			}
			rota[name] = HeadChefFacets(waiter, sousChef)
		}

	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
