//
//  FZ_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {
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
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		signals_service?.transmit(signal: FZSignalConsts.viewAppeared, with: self)
	}
	
	//	override open func viewDidDisappear(_ animated: Bool) {
	//		super.viewDidDisappear(animated)
	//	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		signals_service?.transmit(signal: FZSignalConsts.viewLoaded, with: self)
	}
}

open class FZViewController: UIViewController {
	fileprivate var
	signals_service: FZSignalsService?
	
//	required public init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
	
	deinit {}
}
