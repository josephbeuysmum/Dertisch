//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

fileprivate class CustomerFacets {
	let
	forRestaurantTable: CustomerForRestaurantTable,
	forMaitreD: CustomerForMaitreD,
	forSommelier: CustomerForSommelier,
	forWaiter: CustomerForWaiter?
	
	init(
		_ forRestaurantTable: CustomerForRestaurantTable,
		_ forMaitreD: CustomerForMaitreD,
		_ forSommelier: CustomerForSommelier,
		_ forWaiter: CustomerForWaiter?) {
		self.forRestaurantTable = forRestaurantTable
		self.forMaitreD = forMaitreD
		self.forSommelier = forSommelier
		self.forWaiter = forWaiter
	}
}

fileprivate var rota: [String: CustomerFacets] = [:]



public protocol CustomerForCustomer: class, SimpleColleagueProtocol {
	func layTable()
	func showToTable()
}

public protocol CustomerForMaitreD: class, SimpleColleagueProtocol {
	func peruseMenu()
	func returnMenuToWaiter(_ order: CustomerOrder?)
	func menuReturnedToWaiter(_ order: CustomerOrder?)
}

public protocol CustomerForSommelier: class, SimpleColleagueProtocol {
	func regionChosen()
}

public protocol CustomerForRestaurantTable: class, SimpleColleagueProtocol {
	func tableAssigned()
	func isSeated()
}

public protocol CustomerForWaiter: class, SimpleColleagueProtocol {
	func approach()
	func present(dish dishId: String)
	func presentCheck()
}



extension CustomerForCustomer {
	public func layTable() {}
	public func showToTable() {}
}

public extension CustomerForMaitreD {
	public func peruseMenu() {}
	public func returnMenuToWaiter(_ order: CustomerOrder? = nil) {}
	public func menuReturnedToWaiter(_ order: CustomerOrder? = nil) {}
}

public extension CustomerForRestaurantTable {
	public func tableAssigned() {
		lo("commented out presently 1")
//		(self as? CustomerForCustomer)?.showToTable()
//		(self as? CustomerForSommelier)?.regionChosen()
	}
	
	public func isSeated() {
		lo("commented out presently 2")
//		(self as? CustomerForCustomer)?.layTable()
	}
}

public extension CustomerForSommelier {
	public func regionChosen() {}
}

public extension CustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
	public func presentCheck() {}
}



internal protocol CustomerProtocol: ComplexColleagueProtocol, BeginShiftable, EndShiftable, StaffRelatable {
	var restaurantTable: RestaurantTable { get }
	init(_ name: String, _ restaurantTable: RestaurantTable)
	func inject(
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?,
		_ waiter: WaiterForCustomer?)
}

// tood make this into InternalCustomer or similar and then make a new public class called Customer something that just carries the .selves of its facets at maitreD.introduce(...) time, same goes for HeadChef, Waiter, etc
internal class Customer {
	fileprivate let
	name: String,
	table: RestaurantTable
	
	fileprivate var
	waiter: WaiterForCustomer?
	
	internal required init(_ name: String, _ table: RestaurantTable) {
		self.name = name
		self.table = table
		lo("BONJOUR  ", self)
	}
	
	deinit {
		lo("AU REVOIR", self)
		
	}
}

extension Customer: CustomerProtocol {
	internal var restaurantTable: RestaurantTable {
		return table
	}
	
	internal func inject(
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?,
		_ waiter: WaiterForCustomer?) {
		self.waiter = waiter
		let forWaiter = forWaiterType != nil ? forWaiterType!.init() : nil
		rota[name] = CustomerFacets(
			forRestaurantTableType.init(),
			forMaitreDType.init(),
			forSommelierType.init(),
			forWaiter)
	}
	
	internal func forRestaurantTable() -> CustomerForRestaurantTable? {
		return rota[name]?.forRestaurantTable
	}
	
	internal func forMaitreD() -> CustomerForMaitreD? {
		return rota[name]?.forMaitreD
	}
	
	internal func forSommelier() -> CustomerForSommelier? {
		return rota[name]?.forSommelier
	}
	
	internal func forWaiter() -> CustomerForWaiter? {
		return rota[name]?.forWaiter
	}
	
	internal func beginShift() {
		lo()
	}
	internal func endShift() {
		lo()
	}
}
