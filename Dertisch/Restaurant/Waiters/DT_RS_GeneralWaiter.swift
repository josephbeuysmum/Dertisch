//
//  DT_WT_Simple.swift
//  Dertisch
//
//  Created by Richard Willis on 09/10/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

class GeneralWaiter: Waiter {
	var carte: CarteForCustomer? { return nil }
	
	fileprivate let maitreD: MaitreD
	
	fileprivate var
	customer: CustomerForWaiter?,
	headChef: HeadChefForWaiter?
	
	required init(maitreD: MaitreD, customer: CustomerForWaiter, headChef: HeadChefForWaiter? = nil) {
		lo("bonjour general waiter")
		self.maitreD = maitreD
		self.customer = customer
		self.headChef = headChef
	}
	
	deinit { lo("au revoir general waiter") }
	
	public func endShift() {
		lo()
		customer = nil
		headChef = nil
	}
	
	public func beginShift() { lo() }
}

extension GeneralWaiter: WaiterForHeadChef {
	public func serve(entrees: FulfilledOrder) { lo() }
}

extension GeneralWaiter: WaiterForWaiter {
	func addToCarte(_ main: FulfilledOrder) { lo() }
	func fillCarte(with entrees: FulfilledOrder) { lo() }
	func serve(dishes: FulfilledOrder) { lo() }
}
