//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: Customer] = [:]



public protocol Customerable {
	func waiter(_ key: String) -> BasicWaiterForCustomer?
}

internal protocol CustomerInternal {
	init(
		_ key: String,
		_ restaurantTable: Seat,
		_ forSeatType: CustomerForSeat.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?)
	func inject(_ waiter: WaiterForCustomer?)
	func forMaitreD(_ key: String) -> CustomerForMaitreD?
	func forSommelier(_ key: String) -> CustomerForSommelier?
	func forSeat(_ key: String) -> CustomerForSeat?
}



public protocol CustomerFacet {
	init(_ key: String, _ customer: Customer)
}

public protocol BasicCustomerForWaiter: class {}
	
// tood probable that some of these functions will be migrated into BasicCustomerForWaiter, same goes for rest of the CustomerFor... proats
public protocol CustomerForWaiter: BasicCustomerForWaiter, CustomerFacet {
	func approach()
	func present(dish dishId: String)
	func serveBill()
}

public extension CustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
	public func serveBill() {}
}



public protocol BasicCustomerForMaitreD: class {}

public protocol CustomerForMaitreD: BasicCustomerForMaitreD, CustomerFacet {
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



public protocol BasicCustomerForSeat: class {}

public protocol CustomerForSeat: BasicCustomerForSeat, CustomerFacet {
	func isSeated(_ key: String)
	func tableAssigned(_ key: String)
}

extension CustomerForSeat {
	public func isSeated(_ key: String) {
		rota[key]?.forMaitreD(key)?.layTable()
	}
	public func tableAssigned(_ key: String) {
		guard let customer = rota[key] else { return }
		customer.forMaitreD(key)?.showToTable()
		customer.forSommelier(key)?.regionChosen()
	}
}



public protocol BasicCustomerForSommelier: class {}

public protocol CustomerForSommelier: BasicCustomerForSommelier, CustomerFacet {
	func regionChosen()
}

extension CustomerForSommelier {
	public func regionChosen() {}
}



public class Customer {
	private let private_key: String
	private let restaurant_table: Seat
	
	fileprivate var for_restaurant_table: CustomerForSeat?
	fileprivate var for_maitre_d: CustomerForMaitreD?
	fileprivate var for_sommelier: CustomerForSommelier?
	fileprivate var for_waiter: CustomerForWaiter?
	fileprivate var waiter_: WaiterForCustomer?
	
	internal required init(
		_ key: String,
		_ restaurantTable: Seat,
		_ forSeatType: CustomerForSeat.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?) {
		private_key = key
		restaurant_table = restaurantTable
		for_restaurant_table = forSeatType.init(key, self)
		for_maitre_d = forMaitreDType.init(key, self)
		for_sommelier = forSommelierType.init(key, self)
		for_waiter = forWaiterType?.init(key, self)
		rota[private_key] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension Customer {
	public final var seat: Seat { return restaurant_table }
	
	public final func forWaiter(_ key: String) -> CustomerForWaiter? {
		return key == private_key ? for_waiter : nil
	}
}

extension Customer: WorkShiftable {
	public func beginShift() { lo() }
	public func endShift() { lo() }
}

extension Customer: CigaretteBreakable {
	public func beginBreak() { lo() }
	public func endBreak() { lo() }
}

extension Customer: Customerable {
	final public func waiter(_ key: String) -> BasicWaiterForCustomer? {
		return key == private_key ? waiter_ : nil
	}
}

extension Customer: CustomerInternal {
	final func inject(_ waiter: WaiterForCustomer?) {
		waiter_ = waiter
	}
	
	final func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		return key == private_key ? for_maitre_d : nil
	}
	
	final func forSommelier(_ key: String) -> CustomerForSommelier? {
		return key == private_key ? for_sommelier : nil
	}
	
	final func forSeat(_ key: String) -> CustomerForSeat? {
		return key == private_key ? for_restaurant_table : nil
	}
}
