//
//  FZ_VC_Page.swift
//  Dertisch
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZPageViewController: FZSignalsEntitySetterProtocol {
	public func set(signals: FZSignalsService) {
		guard signals_service == nil else { return }
		signals_service = signals
	}
	
	public func deallocate() {}
}

open class FZPageViewController: UIPageViewController {
	fileprivate var signals_service: FZSignalsService?
}
