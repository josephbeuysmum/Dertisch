//
//  FZ_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {}

open class FZViewController: UIViewController {
	public var signalBox: FZSignalsEntity
	
//	open let key: String
	
	required public init? ( coder aDecoder: NSCoder ) {
//		key = NSUUID().uuidString
		signalBox = FZSignalsEntity()
		super.init( coder: aDecoder )
	}
	
	deinit {}
	
	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		signalBox.signals?.transmit(signal: FZSignalConsts.viewWarnedAboutMemory, with: self)
	}
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		signalBox.signals?.transmit(signal: FZSignalConsts.viewAppeared, with: self)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		signalBox.signals?.transmit(signal: FZSignalConsts.viewLoaded, with: self)
	}
	
	public func deallocate () {
//		signalBox = nil
	}
}
