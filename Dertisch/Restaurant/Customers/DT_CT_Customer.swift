//
//  DT_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public protocol DTCustomerForWaiter {
	func approach()
	func mealServed()
	func placeOrder()
	func peruseMenu()
	func present(hotDish dishId: String)
	func returnMenuToWaiter()
}

public protocol DTCustomerProtocol: class, DTCustomerForWaiter {
	func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier)
}

open class DTCustomer: UIViewController {
	// these can only be overridden if they are here as opposed to the extension below
	open func assign(_ waiter: DTWaiterForCustomer, maitreD: DTMaitreD, and sommelier: DTSommelier) { flagNonImplementation() }
	open func finishMeal() { flagNonImplementation() }
	open func mealServed() { flagNonImplementation() }
	open func returnMenuToWaiter() {}
	open func peruseMenu() {}
	open func placeOrder() { flagNonImplementation() }
	open func present(hotDish dishId: String) { flagNonImplementation() }

	override final public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		mealServed()
	}
	
	override final public func viewDidLoad() {
		super.viewDidLoad()
		checkReadinessToOrder()
	}
	
	private final func checkReadinessToOrder() {
		guard
			isViewLoaded,
			let waiter = DTFirstInstance().get(DTWaiterForCustomer.self, from: Mirror(reflecting: self)),
			waiter.onShift
			else { return }
		placeOrder()
	}
}

extension DTCustomer: DTCustomerProtocol {
	public final func approach() {
		checkReadinessToOrder()
	}
}
