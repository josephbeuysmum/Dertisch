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
	var forMaitreD: WaiterForMaitreD? { get }
	var forCustomer: WaiterForCustomer? { get }
	var forHeadChef: WaiterForHeadChef? { get }
}

internal protocol WaiterInternalProtocol: ComplexColleagueProtocol, StaffMember {
	init(_ name: String)
	func inject(
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?,
		_ customer: CustomerForWaiter?,
		_ headChef: HeadChefForWaiter?)
}

public class Waiter {
	fileprivate let name: String
	
	fileprivate var
	customer: CustomerForWaiter?,
	headChef: HeadChefForWaiter?
	
	internal required init(_ name: String) {
		self.name = name
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension Waiter: WaiterProtocol {
	public var forMaitreD: WaiterForMaitreD? {
		return rota[name]?.forMaitreD
	}
	
	public var forCustomer: WaiterForCustomer? {
		return rota[name]?.forCustomer
	}
	
	public var forHeadChef: WaiterForHeadChef? {
		return rota[name]?.forHeadChef
	}
}

extension Waiter: WaiterInternalProtocol {
	func inject(
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?,
		_ customer: CustomerForWaiter?,
		_ headChef: HeadChefForWaiter?) {
		self.customer = customer
		self.headChef = headChef
		
		let headChef = forHeadChef != nil ? forHeadChef!.init(self) : nil
		rota[name] = WaiterFacets(forCustomer.init(self), forMaitreD.init(self), headChef)
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
