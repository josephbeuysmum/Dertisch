//
//  DT_PT_UT_Interactor.swift
//  Dertisch
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public protocol DTHeadChefForKitchenMember {
	func hand(_ dish: DTDish)
}

public protocol DTHeadChefForWaiter: DTGiveOrderProtocol {}
	
public protocol DTHeadChef: DTHeadChefForWaiter, DTHeadChefForKitchenMember, DTCleanUp, DTStartShiftProtocol {
	init(_ sousChefs: [String: DTKitchenMember]?)
	var waiter: DTWaiterForHeadChef? { get set }
}

public extension DTHeadChef {
	//	public var instanceDescriptor: String { return String(describing: self) }
	public mutating func give(_ order: DTOrder) { flagNonImplementation() }
	public func hand(_ dish: DTDish) { flagNonImplementation() }
	public func startShift() { flagNonImplementation() }
}
