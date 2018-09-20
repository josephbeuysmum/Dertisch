//
//  DT_PT_VP_Customer.swift
//  Dertisch
//
//  Created by Richard Willis on 12/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public protocol DTCustomerProtocol: class, DTOrdererProtocol {//}, DTOrdersEntitySetterProtocol {
	func pass(_ orders: DTOrders, to waiter: DTWaiterForCustomerProtocol)
}
