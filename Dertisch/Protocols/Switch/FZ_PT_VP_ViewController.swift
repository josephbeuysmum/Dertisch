//
//  DT_PT_VP_Dish.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public protocol DTDishProtocol: class, DTOrderReceivableProtocol {//}, DTOrdersEntitySetterProtocol {
	func set(_ orders: DTOrders, and waiter: DTWaiterProtocol)
}
