//
//  FZ_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {
	public func set(signalsService: FZSignalsService) {
		guard signals_service == nil else { return }
		signals_service = signalsService
	}

	public func deallocate () {}
}

open class FZViewController: UIViewController {
	fileprivate var signals_service: FZSignalsService?
	
	deinit {}
	
	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		signals_service?.transmit(signal: FZSignalConsts.viewWarnedAboutMemory, with: self)
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
