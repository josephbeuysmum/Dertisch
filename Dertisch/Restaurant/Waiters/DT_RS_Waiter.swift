//
//  DT_RS_Waiter.swift
//  Cirk
//
//  Created by Richard Willis on 05/11/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol DTCarteForCustomer {}

// todo see if we can make this procedure generic (specifically implemented in GameWaiter atm)
public protocol DTCarteForWaiter {
	func stock(with order: DTDishes)
	func empty()
}

// tood replace carte with a subscript in WaiterForCustomer that accepts a string id
public protocol DTCarte: DTCarteForCustomer, DTCarteForWaiter {
	init<T>(_ entrees: T?)
}

extension DTCarteForWaiter {
	func stock(with order: DTDishes) { lo() }
	func empty() {}
}

public protocol DTWaiterForCustomer: DTGiveOrderProtocol {
	var carte: DTCarteForCustomer? { get }
	var onShift: Bool { get }
}

//public protocol DTWaiterForTableCustomer {
//	func getCellDataFor<T>(_ indexPath: IndexPath) -> T?
//}

public protocol DTWaiterForHeadChef {//: DTServeCustomerProtocol {
	mutating func serve(entrees: DTDishes)
	mutating func hand(main: DTDishes)
}

public protocol DTWaiterForWaiter {
	mutating func fillCarte(with entrees: DTDishes)
	mutating func serve(dishes: DTDishes)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTWaiterForWaiter, DTStartShiftProtocol, DTEndShiftProtocol, DTCigaretteBreakProtocol {
	init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?)
}

public extension DTWaiter {
	public func endBreak() {}
	public func endShift() {}
	public func startBreak() {}
	public func startShift() {}
}

public extension DTWaiterForCustomer {
	public var onShift: Bool {
		let headChef = DTReflector().getFirst(DTHeadChefForWaiter.self, from: Mirror(reflecting: self))
		guard headChef != nil else { return true }
		return carte != nil
	}
	
	public func give(_ order: DTOrder) {
//		lo()
		guard var headChef = DTReflector().getFirst(DTHeadChefForWaiter.self, from: Mirror(reflecting: self)) else { return }
		headChef.give(order)
	}
}

public extension DTWaiterForWaiter {
	func fillCarte(with entrees: DTDishes) {}
	func serve(dishes: DTDishes) {
		let mirror = Mirror(reflecting: self)
		guard let carte = DTReflector().getFirst(DTCarte.self, from: mirror) else { return }
		carte.stock(with: dishes)
		guard let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: mirror) else { return }
		// if we don't use dispatch queue we will cause a simultaneous-mutating-access error in the carte
		DispatchQueue.main.async {
			customer.present(dish: dishes.ticket)
		}
	}
}

public extension DTWaiterForHeadChef {
	public func hand(main: DTDishes) {
		guard var waiter = self as? DTWaiterForWaiter else { return }
		waiter.serve(dishes: main)
	}
	
	public func serve(entrees: DTDishes) {
		guard
			let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: Mirror(reflecting: self)),
			var waiter = self as? DTWaiterForWaiter
			else { return }
		if let carte = DTReflector().getFirst(DTCarteForWaiter.self, from: Mirror(reflecting: self)) {
			carte.stock(with: entrees)
		} else {
			waiter.fillCarte(with: entrees)
		}
		customer.approach()
	}
}
