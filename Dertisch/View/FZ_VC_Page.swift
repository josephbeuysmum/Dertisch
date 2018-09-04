//
//  DT_VC_Page.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension DTPageDish {//}: DTOrdersEntitySetterProtocol {
	public func set(orders: DTOrders) {
		guard orders_ == nil else { return }
		orders_ = orders
	}
	
	public func cleanUp() {}
}

open class DTPageDish: UIPageViewController {
	fileprivate var orders_: DTOrders?
}
