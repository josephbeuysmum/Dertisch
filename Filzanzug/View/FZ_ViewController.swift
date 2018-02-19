//
//  FZ_ViewController.swift
//  Hasenblut
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {}

public class FZViewController: UIViewController {
	public var signalBox: FZSignalsEntity!
	
	open let key: String
	
	public required init? ( coder aDecoder: NSCoder ) {
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity( key )
		super.init( coder: aDecoder )
	}
	
	deinit { lo() }
	
	public override func viewDidLoad () {
		super.viewDidLoad()
		signalBox.getSignalsServiceBy( key: key )?.transmitSignalFor( key: FZSignalConsts.viewLoaded, data: self )
	}
	
	public func deallocate () {
		signalBox.deallocate()
	}
}
