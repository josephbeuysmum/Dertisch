//
//  FZ_ViewController.swift
//  Filzanzug
//
//  Created by Richard Willis on 30/07/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import UIKit

extension FZViewController: FZViewControllerProtocol {
//	public var key: String? {
//		guard key_ == nil else { return nil }
//		key_ = NSUUID().uuidString
//		return key_!
//	}
}

open class FZViewController: UIViewController {
	fileprivate var
	key_: String?,
	signals_: FZSignalsService?
	
	public func deallocate() {}
	
	override open func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		signals_?.transmit(signal: FZSignalConsts.viewWarnedAboutMemory, with: self)
	}
	
	open func set(_ signals: FZSignalsService, and presenter: FZPresenterProtocol) {}
	
	//	public func signals(_ key: String?) -> FZSignalsService? {
	//		guard key != nil else { return nil }
	//		return key == key_ ? signals_ : nil
	//	}
	
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		signals_?.transmit(signal: FZSignalConsts.viewAppeared, with: self)
	}
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		signals_?.transmit(signal: FZSignalConsts.viewLoaded, with: self)
	}
}
