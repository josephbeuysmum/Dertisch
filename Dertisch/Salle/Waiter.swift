//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

fileprivate struct WaiterFacets {
	let
	name: String,
	forCustomer: WaiterForCustomer,
	forMaitreD: WaiterForMaitreD,
	forHeadChef: WaiterForHeadChef?
}

fileprivate var rota: [WaiterFacets] = []







public protocol WaiterForCustomer: class, SimpleColleagueProtocol, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte()
}

//public protocol WaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol WaiterForHeadChef: class, SimpleColleagueProtocol {
	func serve(entrees: FulfilledOrder)
	func serve(main: FulfilledOrder)
}

// tood is this still needed?
public protocol WaiterForMaitreD: class, SimpleColleagueProtocol {}

public protocol WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder)
	func fillCarte(with entrees: FulfilledOrder)
}



public extension WaiterForCustomer {
	func emptyCarte() {}
	
	public func give(_ order: CustomerOrder) {
		lo("commented out presently 3")
		//		guard let headChef = Rota().headChefForWaiter(self as? StaffRelatable) else { return }
		//		headChef.give(order)
	}
}

public extension WaiterForMaitreD {}

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

public extension WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {}
	func fillCarte(with entrees: FulfilledOrder) {}
}



internal protocol WaiterProtocol: ComplexColleagueProtocol, BeginShiftable, EndShiftable, StaffMember, StaffRelatable {
	init(_ name: String)
	func inject(
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?,
		_ customer: CustomerForWaiter?,
		_ headChef: HeadChefForWaiter?)
}

internal class Waiter {
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
	private var facets: WaiterFacets? {
		let results = rota.filter { $0.name == name }
		return results.count == 1 ? results[0] : nil
	}
	
	func inject(
		_ forCustomer: WaiterForCustomer.Type,
		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?,
		_ customer: CustomerForWaiter?,
		_ headChef: HeadChefForWaiter?) {
		self.customer = customer
		self.headChef = headChef
		
		let headChef = forHeadChef != nil ? forHeadChef!.init() : nil
		rota.append(WaiterFacets(
			name: name,
			forCustomer: forCustomer.init(),
			forMaitreD: forMaitreD.init(),
			forHeadChef: headChef))
	}

	
	internal func forCustomer() -> WaiterForCustomer? {
		return facets?.forCustomer
	}
	
	internal func forMaitreD() -> WaiterForMaitreD? {
		return facets?.forMaitreD
	}
	
	internal func forHeadChef() -> WaiterForHeadChef? {
		return facets?.forHeadChef
	}
	
	internal func beginShift() {
		lo()
	}
	internal func endShift() {
		lo()
	}
}
