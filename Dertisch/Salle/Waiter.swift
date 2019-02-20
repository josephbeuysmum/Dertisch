//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: Waiter] = [:]



public protocol WaiterFacet {
	init(_ waiter: Waiter)
}

//public protocol WaiterForMaitreD: class, WaiterFacet, SimpleColleagueProtocol {}

public protocol WaiterForCustomer: SimpleColleagueProtocol, WaiterFacet, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte(_ key: String)
}

public protocol WaiterForHeadChef: SimpleColleagueProtocol, WaiterFacet {
	func serve(entrees: FulfilledOrder, _ key: String)
	func serve(main: FulfilledOrder, _ key: String)
}

public protocol WaiterForWaiter: SimpleColleagueProtocol, WaiterFacet {
	func addToCarte(_ main: FulfilledOrder)
	func fillCarte(with entrees: FulfilledOrder)
}

//public protocol WaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}



public extension WaiterForCustomer {
	func emptyCarte(_ key: String) {}
	
	public func give(_ order: CustomerOrder, _ key: String) {
		rota[key]?._headChef?.give(order, key)
	}
}

//public extension WaiterForMaitreD {}

public extension WaiterForHeadChef {
	public func serve(main: FulfilledOrder, _ key: String) {
		guard let waiter = rota[key] else { return }
		if waiter._forCustomer?.carte == nil {
			waiter._forWaiter?.addToCarte(main)
		} else {
			waiter._forWaiter?.fillCarte(with: main)
		}
		DispatchQueue.main.async {
			waiter._customer?.present(dish: main.ticket)
		}
	}
	
	public func serve(entrees: FulfilledOrder, _ key: String) {
		rota[key]?._forWaiter?.fillCarte(with: entrees)
		rota[key]?._customer?.present(dish: entrees.ticket)
	}
}

public extension WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {}
	func fillCarte(with entrees: FulfilledOrder) {}
}



public protocol WaiterProtocol {
//	func forMaitreD(_ key: String) -> WaiterForMaitreD?
	func forCustomer(_ key: String) -> WaiterForCustomer?
	func forHeadChef(_ key: String) -> WaiterForHeadChef?
	func customer(_ key: String) -> CustomerForWaiter?
	func headChef(_ key: String) -> HeadChefForWaiter?
}

internal protocol WaiterInternalProtocol: ComplexColleagueProtocol, StaffMember {
	init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
//		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?)
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?)
}

public class Waiter {
	private let
	privateKey: String
	
	fileprivate var
	_forCustomer: WaiterForCustomer?,
//	_forMaitreD: WaiterForMaitreD?,
	_forHeadChef: WaiterForHeadChef?,
	_forWaiter: WaiterForWaiter?,
	_customer: CustomerForWaiter?,
	_headChef: HeadChefForWaiter?
	
	internal required init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
//		_ forMaitreD: WaiterForMaitreD.Type,
		_ forHeadChef: WaiterForHeadChef.Type?) {
		privateKey = key
		self._forCustomer = forCustomer.init(self)
//		self._forMaitreD = forMaitreD.init(self)
		self._forHeadChef = forHeadChef != nil ? forHeadChef!.init(self) : nil
		self._forWaiter = GeneralWaiterForWaiter(self)
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}

extension Waiter: WaiterProtocol {
//	public func forMaitreD(_ key: String) -> WaiterForMaitreD? {
//		return key == privateKey ? _forMaitreD : nil
//	}
	
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
