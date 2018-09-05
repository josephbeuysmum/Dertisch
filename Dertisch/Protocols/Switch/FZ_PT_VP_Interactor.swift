//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension DTHeadChefProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
//	public var closet: DTHeadChefCloset? {
//		return DTFirstInstance().get(DTHeadChefCloset.self, from: mirror_)
//	}
	
//	private var key_: DTKey? {
//		return DTFirstInstance().get(DTKey.self, from: mirror_)
//	}
	
	private var mirror_: Mirror { return Mirror(reflecting: self) }
	private var waiter_: DTWaiterProtocol? { return DTFirstInstance().get(DTWaiterProtocol.self, from: mirror_) }
	private var orders_: DTOrders? { return DTFirstInstance().get(DTOrders.self, from: mirror_) }

	
	
	public func startShift() {
		guard
//			let key = key_,
//			let safeCloset = closet,
			let waiterClassName = waiter_?.instanceDescriptor,
			let orders = orders_
			else { return }
		_ = orders.listenFor(order: DTOrderConsts.waiterActivated, order: self) { _, data in
			guard
				let strongSelf = self as DTHeadChefProtocol?,
				let waiter = data as? DTWaiterProtocol,
				waiter.instanceDescriptor == waiterClassName
				else { return }
			var mutatingSelf = strongSelf
			mutatingSelf.waiterActivated()
		}
		// todo why is this not simply in the closure immediately above?
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) { timer in
			_ = orders.stopWaitingFor(order: DTOrderConsts.waiterActivated, order: self)
			timer.invalidate()
		}
	}
}

public protocol DTHeadChefProtocol: DTSwitchClassProtocol {
	init(orders: DTOrders, waiter: DTWaiterProtocol, kitchenStaff: [DTKitchenProtocol]?)
//	var closet: DTHeadChefCloset? { get }
	mutating func waiterActivated ()
}
