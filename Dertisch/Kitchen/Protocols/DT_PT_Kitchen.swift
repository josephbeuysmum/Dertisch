//
//  DT_PT_VP_ModelClass.swift
//  Dertisch
//
//  Created by Richard Willis on 11/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public extension DTKitchenProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	static public var staticId: String { return String(describing: self) }
	
	
	
	public func startShift() {}
	
	public mutating func cleanUp() {}
}

public protocol DTKitchenProtocol: DTSwitchClassProtocol {
	init(orders: DTOrders, kitchenStaffMembers: [String: DTKitchenProtocol]?)
//	init()
//	var closet: DTKitchenCloset { get }
}
