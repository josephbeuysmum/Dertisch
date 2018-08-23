//
//  FZ_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {
	public var key: String? {
		guard key_ == nil else { return nil }
		key_ = NSUUID().uuidString
		return key_!
	}
	
	public func deallocate() {}
	
	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		signals_service?.transmit(signal: FZSignalConsts.viewWarnedAboutMemory, with: self)
	}
	
	// todo? some sort of [key'ed] way of ensuring this can only be called by FZRoutingService
	public func set(signalsService: FZSignalsService) {
		guard signals_service == nil else { return }
		signals_service = signalsService
	}
	
	public func signals(_ key: String?) -> FZSignalsService? {
		guard key != nil else { return nil }
		return key == key_ ? signals_service : nil
	}
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		signals_service?.transmit(signal: FZSignalConsts.viewAppeared, with: self)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		signals_service?.transmit(signal: FZSignalConsts.viewLoaded, with: self)
	}
}

open class FZViewController: UIViewController {
	fileprivate var
	key_: String?,
	signals_service: FZSignalsService?
	
//	required public init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
	
	deinit {}
}
