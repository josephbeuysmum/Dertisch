//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

fileprivate class WaiterFacets {
	let
	forCustomer: WaiterForCustomer,
	forMaitreD: WaiterForMaitreD,
	forHeadChef: WaiterForHeadChef?
	
	init (
	_ forCustomer: WaiterForCustomer,
	_ forMaitreD: WaiterForMaitreD,
	_ forHeadChef: WaiterForHeadChef?) {
		self.forCustomer = forCustomer
		self.forMaitreD = forMaitreD
		self.forHeadChef = forHeadChef
	}
}

fileprivate var rota: [String: WaiterFacets] = [:]



public protocol WaiterFacet {
	init(_ waiter: Waiter)
}

// tood is this (and similar) still needed?
public protocol WaiterForMaitreD: class, WaiterFacet, SimpleColleagueProtocol {}

public protocol WaiterForCustomer: class, WaiterFacet, SimpleColleagueProtocol, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte()
}

public protocol WaiterForHeadChef: class, WaiterFacet, SimpleColleagueProtocol {
	func serve(entrees: FulfilledOrder)
	func serve(main: FulfilledOrder)
}

//public protocol WaiterForWaiter {
//	func addToCarte(_ main: FulfilledOrder)
//	func fillCarte(with entrees: FulfilledOrder)
//}

//public protocol WaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}



public extension WaiterForCustomer {
	func emptyCarte() {}
	
	public func give(_ order: CustomerOrder) {
		lo("commented out presently 3")
		//		guard let headChef = Rota().headChefForWaiter(self as? StaffRelatable) else { return }
		//		headChef.give(order)
	}
}

//public extension WaiterForMaitreD {}

public extension WaiterForHeadChef {
	// todo the waiter calls a serve function on itself from a serve function: is this necessary?
	public func serve(main: FulfilledOrder) {
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
	
	public func serve(entrees: FulfilledOrder) {
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
	func forMaitreD(by key: String) -> WaiterForMaitreD?
	func forCustomer(by key: String) -> WaiterForCustomer?
	func forHeadChef(by key: String) -> WaiterForHeadChef?
	func customer(by key: String) -> CustomerForWaiter?
	func headChef(by key: String) -> HeadChefForWaiter?
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
	private let privateKey: String

	fileprivate var
	customer: CustomerForWaiter?,
	headChef: HeadChefForWaiter?
	
	internal required init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?) {
		privateKey = key
		let headChef = forHeadChef != nil ? forHeadChef!.init(self) : nil
		rota[privateKey] = WaiterFacets(forCustomer.init(self), forMaitreD.init(self), headChef)
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension Waiter: WaiterProtocol {
	public func forMaitreD(by key: String) -> WaiterForMaitreD? {
		return rota[key]?.forMaitreD
	}
	
	public func forCustomer(by key: String) -> WaiterForCustomer? {
		return rota[key]?.forCustomer
	}
	
	public func forHeadChef(by key: String) -> WaiterForHeadChef? {
		return rota[key]?.forHeadChef
	}
	
	public func customer(by key: String) -> CustomerForWaiter? {
		return key == privateKey ? customer : nil
	}
	
	public func headChef(by key: String) -> HeadChefForWaiter? {
		return key == privateKey ? headChef : nil
	}
}

extension Waiter: WaiterInternalProtocol {
	internal var internalKey: String {
		return privateKey
	}
	
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?) {
		self.customer = customer
		self.headChef = headChef
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
