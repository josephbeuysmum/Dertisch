//
//  FZ_VC_Page.swift
//  Hasenblut
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZPageViewController: FZSignalBoxEntityProtocol {}

public class FZPageViewController: UIPageViewController {
	public var signalBox: FZSignalsEntity
	
	open let key: String
	
	required public init? ( coder: NSCoder ) {
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity()
		super.init( coder: coder )
	}
}
