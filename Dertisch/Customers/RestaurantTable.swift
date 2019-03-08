//
//  Seat.swift
//  Cirk
//
//  Created by Richard Willis on 01/02/2019.
//  Copyright © 2019 Rich Text Format Ltd. All rights reserved.
//

import UIKit

open class Seat: UIViewController {
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		ownKey = ""
	}
	
	final var customer: CustomerForSeat? {
		get { return nil }
		set { ownCustomer = newValue }
	}
	
	final var key: String? {
		get { return nil }
		set { ownKey = newValue }
	}
	
	private var
	ownCustomer: CustomerForSeat?,
	ownKey: String!
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard ownKey != nil else { return }
		ownCustomer?.isSeated(ownKey)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		guard ownKey != nil else { return }
		ownCustomer?.tableAssigned(ownKey)
	}
	
	override open func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		ownCustomer = nil
	}
}
