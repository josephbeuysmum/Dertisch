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
	
	deinit { lo() }
	
	override open func viewDidLoad () {
		super.viewDidLoad()
		signalBox.signals?.transmitSignalFor( key: FZSignalConsts.viewLoaded, data: self )
	}
	
	public func deallocate () {
//		signalBox = nil
	}
}
