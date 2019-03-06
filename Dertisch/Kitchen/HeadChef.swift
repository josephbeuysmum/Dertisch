//
//  HeadChef.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

fileprivate var rota: [String: HeadChef] = [:]







public protocol HeadChefFacet {
	init(_ headChef: HeadChef, _ key: String)
}

public protocol HeadChefForSousChef: class, HeadChefFacet {
	func give(_ prep: InternalOrder)
}

public protocol HeadChefForWaiter: class, HeadChefFacet, GiveCustomerOrderable {}







extension HeadChefForSousChef {
	public func give(_ prep: InternalOrder) {
		lo("commented out presently 2")
//		let fulfilledOrder = FulfilledOrder(prep.ticket, dishes: prep.dishes as? Dishionarizer)
//		Rota().waiterForHeadChef(self as? StaffRelatable)?.serve(main: fulfilledOrder)
	}
}

extension HeadChefForWaiter {
	public func give(_ order: CustomerOrder, _ key: String) {}
}



public protocol HeadChefProtocol {
	func forWaiter(_ key: String) -> HeadChefForWaiter?
	func forSousChef(_ key: String) -> HeadChefForSousChef?
	func waiter(_ key: String) -> WaiterForHeadChef?
}

internal protocol HeadChefInternalProtocol: WorkShiftable {
	init(
		_ key: String,
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ resources: [String: KitchenResource]?)
	func inject(_ waiter: WaiterForHeadChef?)
}

public class HeadChef {
	fileprivate let privateKey: String
	
	fileprivate var
	_forWaiter: HeadChefForWaiter?,
	_forSousChef: HeadChefForSousChef?,
	_waiter: WaiterForHeadChef?
	
	internal required init(
		_ key: String,
		_ forWaiterType: HeadChefForWaiter.Type?,
		_ forSousChefType: HeadChefForSousChef.Type?,
		_ resources: [String: KitchenResource]?) {
		privateKey = key
		_forWaiter = forWaiterType != nil ? forWaiterType!.init(self, key) : nil
		_forSousChef = forSousChefType != nil ? forSousChefType!.init(self, key) : nil
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension HeadChef: HeadChefProtocol {
	public func forWaiter(_ key: String) -> HeadChefForWaiter? {
		return key == privateKey ? _forWaiter : nil
	}
	
	public func forSousChef(_ key: String) -> HeadChefForSousChef? {
		return key == privateKey ? _forSousChef : nil
	}
	
	public func waiter(_ key: String) -> WaiterForHeadChef? {
		return key == privateKey ? _waiter : nil
	}
}

extension HeadChef: HeadChefInternalProtocol {
	internal func inject(_ waiter: WaiterForHeadChef?) {
		self._waiter = waiter
	}
}

extension HeadChef: WorkShiftable {
	public final func beginShift() {
		lo()
	}
	
	public final func endShift() {
		lo()
	}
}

extension HeadChef: CigaretteBreakable {
	public final func beginBreak() {
		lo()
	}
	
	public final func endBreak() {
		lo()
	}
}
