//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

fileprivate var rota: [String: Waiter] = [:]



public protocol WaiterFacet {
	init(_ waiter: Waiter)
}

// tood is this (and similar) still needed?
public protocol WaiterForMaitreD: class, WaiterFacet, SimpleColleagueProtocol {}

public protocol WaiterForCustomer: class, WaiterFacet, SimpleColleagueProtocol, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte(_ key: String)
}

public protocol WaiterForHeadChef: class, WaiterFacet, SimpleColleagueProtocol {
	func serve(_ key: String, entrees: FulfilledOrder)
	func serve(_ key: String, main: FulfilledOrder)
}

//public protocol WaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder)
//	func fillCarte(with entrees: FulfilledOrder)
//}

//public protocol WaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}



public extension WaiterForCustomer {
	func emptyCarte(_ key: String) {}
	
	public func give(_ key: String, _ order: CustomerOrder) {
		rota[key]?._headChef?.give(key, order)
	}
}

//public extension WaiterForMaitreD {}

public extension WaiterForHeadChef {
	// todo the waiter calls a serve function on itself from a serve function: is this necessary?
	public func serve(_ key: String, main: FulfilledOrder) {
		lo("commented out presently 4")
		//		guard
		//			let waiter = self as? WaiterForWaiter,
		//			let selfAsStaffRelationship = self as? StaffRelatable,
		//			let customer = Rota().customerForWaiter(selfAsStaffRelationship)
		//			else { return }
		//		Rota().hasCarte(selfAsStaffRelationship) ? waiter.addToCarte(main) : waiter.fillCarte(with: main)
		//		DispatchQueue.main.async {
		//			customer.present(dish: main.ticket)
		//		}
	}
	
	public func serve(_ key: String, entrees: FulfilledOrder) {
		lo("commented out presently 5")
		
		
		
		//		guard
		//			let waiter = self as? WaiterForWaiter,
		//			let customer = Rota().customerForWaiter(self as? StaffRelatable)
		//			else { return }
		//		waiter.fillCarte(with: entrees)
		//		customer.present(dish: entrees.ticket)
	}
}

//public extension WaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder) {}
//	func fillCarte(with entrees: FulfilledOrder) {}
//}



public protocol WaiterProtocol {
	func forMaitreD(_ key: String) -> WaiterForMaitreD?
	func forCustomer(_ key: String) -> WaiterForCustomer?
	func forHeadChef(_ key: String) -> WaiterForHeadChef?
	func customer(_ key: String) -> CustomerForWaiter?
	func headChef(_ key: String) -> HeadChefForWaiter?
}

internal protocol WaiterInternalProtocol: ComplexColleagueProtocol, StaffMember {
	init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?)
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?)
}

public class Waiter {
	private let
	privateKey: String
	
	fileprivate var
	_forCustomer: WaiterForCustomer?,
	_forMaitreD: WaiterForMaitreD?,
	_forHeadChef: WaiterForHeadChef?,
	_customer: CustomerForWaiter?,
	_headChef: HeadChefForWaiter?
	
	internal required init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?) {
		privateKey = key
		self._forCustomer = forCustomer.init(self)
		self._forMaitreD = forMaitreD.init(self)
		self._forHeadChef = forHeadChef != nil ? forHeadChef!.init(self) : nil
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension Waiter: WaiterProtocol {
	public func forMaitreD(_ key: String) -> WaiterForMaitreD? {
		return key == privateKey ? _forMaitreD : nil
	}
	
	public func forCustomer(_ key: String) -> WaiterForCustomer? {
		return key == privateKey ? _forCustomer : nil
	}
	
	public func forHeadChef(_ key: String) -> WaiterForHeadChef? {
		return key == privateKey ? _forHeadChef : nil
	}
	
	public func customer(_ key: String) -> CustomerForWaiter? {
		return key == privateKey ? _customer : nil
	}
	
	public func headChef(_ key: String) -> HeadChefForWaiter? {
		return key == privateKey ? _headChef : nil
	}
}

extension Waiter: WaiterInternalProtocol {
	internal var internalKey: String {
		return privateKey
	}
	
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?) {
		self._customer = customer
		self._headChef = headChef
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
