//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: DtCustomer] = [:]





public protocol Customerable {
	func waiter(_ key: String) -> WaiterForCustomer?
}

public protocol CustomerForMaitreD: class {
	func layTable()
	func showToTable()
	func peruseMenu()
	func returnMenuToWaiter(_ order: CustomerOrder?)
	func menuReturnedToWaiter(_ order: CustomerOrder?)
}

extension CustomerForMaitreD {
	public func layTable() {}
	public func showToTable() {}
	public func peruseMenu() {}
	public func returnMenuToWaiter(_ order: CustomerOrder? = nil) {}
	public func menuReturnedToWaiter(_ order: CustomerOrder? = nil) {}
}

public protocol CustomerForWaiter: class {
	func serveBill()
}

extension CustomerForWaiter {
	public func serveBill() {}
}

public protocol CustomerForRestaurantTable: class {
	func isSeated(_ key: String)
	func tableAssigned(_ key: String)

}

extension CustomerForRestaurantTable {
	public func isSeated(_ key: String) {
		rota[key]?.forMaitreD(key)?.layTable()
	}
	public func tableAssigned(_ key: String) {
		guard let customer = rota[key] else { return }
		customer.forMaitreD(key)?.showToTable()
		customer.forSommelier(key)?.regionChosen()
	}
}

public protocol CustomerForSommelier: class {
	func regionChosen()
}

extension CustomerForSommelier {
	public func regionChosen() {}
}

internal protocol CustomerableInternal {
	func forWaiter(_ key: String) -> CustomerForWaiter?
}

internal protocol CustomerInjectable {
	func inject(_ waiter: WaiterForCustomer?)
}

internal protocol CustomerInternal: Customerable, CustomerableInternal, CustomerInjectable {
	init(
		_ key: String,
		_ restaurantTable: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?)
}





internal class InternalCustomer {
	private var key: String?
	private var head: CustomerInternal?
	
	required init() {}
	
	convenience init(_ key: String, _ customer: Customerable) {
		self.init()
		self.key = key
		head = customer as? CustomerInternal
	}
}

extension InternalCustomer: Customer {
	var restaurantTable: RestaurantTable {
		return "" as! RestaurantTable
	}
	
	final func beginShift() { lo() }
	final func endShift() { lo() }
	final func beginBreak() { lo() }
	final func endBreak() { lo() }
	
	// tood tood tood tood we're just returning nils here, we need proper returns
	func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		lo("currently hardcoded nil return")
		return nil
	}
	
	func forSommelier(_ key: String) -> CustomerForSommelier? {
		lo("currently hardcoded nil return")
		return nil
	}
	
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable? {
		lo("currently hardcoded nil return")
		return nil
	}
}

extension InternalCustomer: CustomerableInternal {
	final func forWaiter(_ key: String) -> CustomerForWaiter? {
		return head?.forWaiter(key)
	}
}

extension InternalCustomer: CustomerInjectable {
	public final func inject(_ waiter: WaiterForCustomer?) {
		head?.inject(waiter)
	}
}





public protocol DTCustomerFacet {
	init(_ key: String, _ customer: DtCustomer)
}

public protocol DtCustomerForWaiter: DTCustomerFacet, CustomerForWaiter {
	func approach()
	func present(dish dishId: String)
}

public extension DtCustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
}

public protocol DtCustomerForMaitreD: DTCustomerFacet, CustomerForMaitreD {}

public protocol DtCustomerForRestaurantTable: DTCustomerFacet, CustomerForRestaurantTable {}

public protocol DtCustomerForSommelier: DTCustomerFacet, CustomerForSommelier {}





public protocol Customer: WorkShiftable, CigaretteBreakable {
	var restaurantTable: RestaurantTable { get }
}

internal protocol CustomerInternalProtocol {
	func forMaitreD(_ key: String) -> CustomerForMaitreD?
	func forSommelier(_ key: String) -> CustomerForSommelier?
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable?
}

public class DtCustomer {
	private let private_key: String
	private let restaurant_table: RestaurantTable
	
	fileprivate var for_restaurant_table: DtCustomerForRestaurantTable?
	// tood do we really need a public version of CustomerForMaitreD?
	fileprivate var for_maitre_d: DtCustomerForMaitreD?
	fileprivate var for_sommelier: DtCustomerForSommelier?
	fileprivate var for_waiter: DtCustomerForWaiter?
	fileprivate var waiter_: DtWaiterForCustomer?
	
	internal required init(
		_ key: String,
		_ restaurantTable: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?) {
		private_key = key
		restaurant_table = restaurantTable
		for_restaurant_table = (forRestaurantTableType as? DtCustomerForRestaurantTable.Type)?.init(key, self)
		for_maitre_d = (forMaitreDType as? DtCustomerForMaitreD.Type)?.init(key, self)
		for_sommelier = (forSommelierType as? DtCustomerForSommelier.Type)?.init(key, self)
		for_waiter = (forWaiterType as? DtCustomerForWaiter.Type)?.init(key, self)
		rota[private_key] = self
		lo("BONJOUR  ", self)
	}
	
	deinit {
		lo("AU REVOIR", self)
		
	}
}

extension DtCustomer {
	public final func forWaiter(_ key: String) -> DtCustomerForWaiter? {
		return key == private_key ? for_waiter : nil
	}
}

extension DtCustomer: Customer {
	public final var restaurantTable: RestaurantTable { return restaurant_table }
	public func beginShift() { lo() }
	public func endShift() { lo() }
	public func beginBreak() { lo() }
	public func endBreak() { lo() }
}

extension DtCustomer: CustomerInternalProtocol {
	final func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		return key == private_key ? for_maitre_d : nil
	}
	
	final func forSommelier(_ key: String) -> CustomerForSommelier? {
		return key == private_key ? for_sommelier : nil
	}
	
	final func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable? {
		return key == private_key ? for_restaurant_table : nil
	}
}

extension DtCustomer: CustomerInternal {
	public final func waiter(_ key: String) -> WaiterForCustomer? {
		return key == private_key ? waiter_ : nil
	}
	
	final func forWaiter(_ key: String) -> CustomerForWaiter? {
		return key == private_key ? for_waiter : nil
	}
	
	final func inject(_ waiter: WaiterForCustomer?) {
		waiter_ = waiter as? DtWaiterForCustomer
	}
}
