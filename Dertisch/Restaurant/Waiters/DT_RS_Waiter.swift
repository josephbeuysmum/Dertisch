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
	func stockCarte(with dish: DTDish)
	func empty()
}

public protocol DTCarte: DTCarteForCustomer, DTCarteForWaiter {
	init<T>(_ entrees: T)
}

extension DTCarteForWaiter {
	func stockCarte(with dish: DTDish) {}
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
	mutating func serve(sideDish: DTDish)
	mutating func serve<T>(entrees: T?)
}

public protocol DTWaiterForWaiter {
	mutating func fillCarte<T>(with entrees: T?)
	mutating func serve(_ dish: DTDish)
}

public protocol DTWaiter: DTWaiterForCustomer, DTWaiterForHeadChef, DTWaiterForWaiter, DTStartShiftProtocol, DTEndShiftProtocol, DTCigaretteBreakProtocol {
	init(customer: DTCustomerForWaiter, headChef: DTHeadChefForWaiter?)
}

public extension DTWaiter {
	public func endBreak() {}
	public func endShift() { flagNonImplementation() }
	public func startBreak() {}
	public func startShift() { flagNonImplementation() }
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
	func serve(_ dish: DTDish) {
		let mirror = Mirror(reflecting: self)
		guard let carte = DTReflector().getFirst(DTCarte.self, from: mirror) else { return }
		carte.stockCarte(with: dish)
		guard let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: mirror) else { return }
		DispatchQueue.main.async { customer.present(dish: dish.ticket) }
	}
}

public extension DTWaiterForHeadChef {
	public func serve(sideDish: DTDish) {
//		lo(sideDish)
		guard var waiter = self as? DTWaiterForWaiter else { return }
		waiter.serve(sideDish)
	}
	
	public func serve<T>(entrees: T?) {
		guard
			let customer = DTReflector().getFirst(DTCustomerForWaiter.self, from: Mirror(reflecting: self)),
			var waiter = self as? DTWaiterForWaiter
			else { return }
		waiter.fillCarte(with: entrees)
		customer.approach()
	}
}
