//
//  Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: Customer] = [:]



public protocol CustomerFacet {
	init(_ customer: Customer, _ key: String)
}



public protocol CustomerForMaitreD: SimpleColleagueProtocol, CustomerFacet {
	func layTable()
	func showToTable()
	func peruseMenu()
	func returnMenuToWaiter(_ order: CustomerOrder?)
	func menuReturnedToWaiter(_ order: CustomerOrder?)
}

public protocol CustomerForSommelier: SimpleColleagueProtocol, CustomerFacet {
	func regionChosen()
}

public protocol CustomerForRestaurantTable: SimpleColleagueProtocol, CustomerFacet {
	func tableAssigned(_ key: String)
	func isSeated(_ key: String)
}

public protocol CustomerForWaiter: SimpleColleagueProtocol, CustomerFacet {
	func approach()
	func present(dish dishId: String)
	func serveBill()
}



public extension CustomerForMaitreD {
	public func layTable() {}
	public func showToTable() {}
	public func peruseMenu() {}
	public func returnMenuToWaiter(_ order: CustomerOrder? = nil) {}
	public func menuReturnedToWaiter(_ order: CustomerOrder? = nil) {}
}

public extension CustomerForRestaurantTable {
	public func tableAssigned(_ key: String) {
		guard let customer = rota[key] else { return }
		customer.forMaitreD(key)?.showToTable()
		customer.forSommelier(key)?.regionChosen()
	}
	
	public func isSeated(_ key: String) {
		rota[key]?.forMaitreD(key)?.layTable()
	}
}

public extension CustomerForSommelier {
	public func regionChosen() {}
}

public extension CustomerForWaiter {
	public func approach() {}
	public func present(dish dishId: String) {}
	public func serveBill() {}
}



public protocol CustomerProtocol {
	var restaurantTable: RestaurantTable { get }
	func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable?
	func forMaitreD(_ key: String) -> CustomerForMaitreD?
	func forSommelier(_ key: String) -> CustomerForSommelier?
	func forWaiter(_ key: String) -> CustomerForWaiter?
	func waiter(_ key: String) -> WaiterForCustomer?
}

internal protocol CustomerInternalProtocol: ComplexColleagueProtocol {
	init(
		_ key: String,
		_ table: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?)
	func inject(_ waiter: WaiterForCustomer?)
}

public class Customer {
	private let
	privateKey: String,
	table: RestaurantTable
	
	fileprivate var
	_forRestaurantTable: CustomerForRestaurantTable?,
	_forMaitreD: CustomerForMaitreD?,
	_forSommelier: CustomerForSommelier?,
	_forWaiter: CustomerForWaiter?,
	_waiter: WaiterForCustomer?
	
	internal required init(
		_ key: String,
		_ table: RestaurantTable,
		_ forRestaurantTableType: CustomerForRestaurantTable.Type,
		_ forMaitreDType: CustomerForMaitreD.Type,
		_ forSommelierType: CustomerForSommelier.Type,
		_ forWaiterType: CustomerForWaiter.Type?) {
		privateKey = key
		self.table = table
		_forRestaurantTable = forRestaurantTableType.init(self, key)
		_forMaitreD = forMaitreDType.init(self, key)
		_forSommelier = forSommelierType.init(self, key)
		_forWaiter = forWaiterType != nil ? forWaiterType!.init(self, key) : nil
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit {
		lo("AU REVOIR", self)
		
	}
}

extension Customer: CustomerProtocol {
	public var restaurantTable: RestaurantTable {
		return table
	}
	
	public func forRestaurantTable(_ key: String) -> CustomerForRestaurantTable? {
		return key == privateKey ? _forRestaurantTable : nil
	}
	
	public func forMaitreD(_ key: String) -> CustomerForMaitreD? {
		return key == privateKey ? _forMaitreD : nil
	}
	
	public func forSommelier(_ key: String) -> CustomerForSommelier? {
		return key == privateKey ? _forSommelier : nil
	}
	
	public func forWaiter(_ key: String) -> CustomerForWaiter? {
		return key == privateKey ? _forWaiter : nil
	}
	
	public func waiter(_ key: String) -> WaiterForCustomer? {
		return key == privateKey ? _waiter : nil
	}
}

extension Customer: CustomerInternalProtocol {
	internal var internalKey: String {
		return privateKey
	}
	
	internal func inject(_ waiter: WaiterForCustomer?) {
		self._waiter = waiter
	}
	
	internal func beginShift() {
		lo()
	}
	
	internal func endShift() {
		lo()
	}
}
