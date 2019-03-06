//
//  Waiter.swift
//  Dertisch
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

fileprivate var rota: [String: DtWaiter] = [:]







public protocol WaiterFacet: class {
	init(_ key: String, _ waiter: Waiterable)
}

internal protocol WaiterInternalProtocol {
	func forCustomer(_ key: String) -> WaiterForCustomer?
	func forHeadChef(_ key: String) -> WaiterForHeadChef?
}

public protocol WaiterForCustomer: WaiterFacet {}

public protocol WaiterForHeadChef: WaiterFacet {}

public protocol WaiterForWaiter: WaiterFacet {}

public protocol Waiterable {
	func customer(_ key: String) -> CustomerForWaiter?
	func headChef(_ key: String) -> HeadChefForWaiter?
}

internal protocol WaiterableInternal: Waiterable, WaiterInternalProtocol {
	init(_ key: String, _ forCustomer: WaiterForCustomer.Type, _ forHeadChef: WaiterForHeadChef.Type?)
}







internal class Waiter {
	private let key: String
	private let head: WaiterableInternal?
	private var customer_: CustomerForWaiter?
	private var headChef_: HeadChefForWaiter?
	
	required init(_ key: String, _ waiter: Waiterable) {
		self.key = key
		self.head = waiter as? WaiterableInternal
	}
}

extension Waiter: WaiterFacet {}

extension Waiter: WaiterInternalProtocol {
	func forCustomer(_ key: String) -> WaiterForCustomer? {
		return head?.forCustomer(key)
	}
	
	func forHeadChef(_ key: String) -> WaiterForHeadChef? {
		return head?.forHeadChef(key)
	}
}

extension Waiter: WaiterInjectable {
	public final func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?) {
		customer_ = customer
		headChef_ = headChef
	}
}

extension Waiter: WorkShiftable {
	final func beginShift() {
		lo()
	}
	
	final func endShift() {
		lo()
	}
}

extension Waiter: CigaretteBreakable {
	final func beginBreak() {
		lo()
	}
	
	final func endBreak() {
		lo()
	}
}






public protocol DtWaiterForCustomer: WaiterForCustomer, GiveCustomerOrderable {
	var carte: CarteForCustomer? { get }
	func emptyCarte()
}

public protocol DtWaiterForHeadChef: WaiterForHeadChef {
	func serve(entrees: FulfilledOrder, _ key: String)
	func serve(main: FulfilledOrder, _ key: String)
}

public protocol DtWaiterForWaiter: WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder)
	func fillCarte(with entrees: FulfilledOrder)
}







public extension DtWaiterForCustomer {
	func emptyCarte() {}
	
	public func give(_ order: CustomerOrder, _ key: String) {
		rota[key]?._headChef?.give(order, key)
	}
}

public extension DtWaiterForHeadChef {
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

public extension DtWaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) {}
	func fillCarte(with entrees: FulfilledOrder) {}
}






public protocol DtWaiterProtocol: WorkShiftable, CigaretteBreakable {
	func forCustomer(_ key: String) -> DtWaiterForCustomer?
	func forHeadChef(_ key: String) -> DtWaiterForHeadChef?
}

internal protocol WaiterInjectable {
	func inject(_ customer: CustomerForWaiter?, _ headChef: HeadChefForWaiter?)
}







public class DtWaiter {
	private let
	privateKey: String
	
	fileprivate var
	_forCustomer: DtWaiterForCustomer?,
	_forHeadChef: DtWaiterForHeadChef?,
	_forWaiter: DtWaiterForWaiter?,
	_customer: CustomerForWaiter?,
	_headChef: HeadChefForWaiter?
	
	internal required init(
		_ key: String,
		_ forCustomer: WaiterForCustomer.Type,
		_ forHeadChef: WaiterForHeadChef.Type?) {
		privateKey = key
		self._forCustomer = forCustomer.init(key, self) as? DtWaiterForCustomer
		self._forHeadChef = forHeadChef != nil ? forHeadChef!.init(key, self) as? DtWaiterForHeadChef : nil
		self._forWaiter = GeneralWaiterForWaiter(key, self)
		rota[privateKey] = self
		lo("BONJOUR  ", self)
	}
	
	deinit { lo("AU REVOIR", self) }
}







extension DtWaiter: WaiterableInternal {
	func forCustomer(_ key: String) -> WaiterForCustomer? {
		return key == privateKey ? _forCustomer : nil
	}
	
	func forHeadChef(_ key: String) -> WaiterForHeadChef? {
		return key == privateKey ? _forHeadChef : nil
	}
}

extension DtWaiter: Waiterable {
	public final func customer(_ key: String) -> CustomerForWaiter? {
		return key == privateKey ? _customer : nil
	}
	
	public final func headChef(_ key: String) -> HeadChefForWaiter? {
		return key == privateKey ? _headChef : nil
	}
}

extension DtWaiter: DtWaiterProtocol {
	public final func forCustomer(_ key: String) -> DtWaiterForCustomer? {
		return key == privateKey ? _forCustomer : nil
	}
	
	public final func forHeadChef(_ key: String) -> DtWaiterForHeadChef? {
		return key == privateKey ? _forHeadChef : nil
	}
}

extension DtWaiter: WorkShiftable {
	public final func beginShift() {
		lo()
	}
	
	public final func endShift() {
		lo()
	}
}
