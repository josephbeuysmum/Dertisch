//
//  FZ_PT_UT_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZInteractorProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
	public var closet: FZInteractorCloset? {
		return FirstInstance().get(FZInteractorCloset.self, from: mirror_)
	}
	
	private var mirror_: Mirror { return Mirror(reflecting: self) }
	

	
	public func activate () {
		guard
			let key = FirstInstance().get(FZKey.self, from: Mirror(reflecting: self))?.teeth,
			let safeCloset = closet,
			let presenterClassName = safeCloset.presenter(key)?.instanceDescriptor,
			let signals = safeCloset.signals(key)
			else { return }
		_ = signals.scanFor(signal: FZSignalConsts.presenterActivated, scanner: self) { _, data in
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.instanceDescriptor == presenterClassName
				else { return }
			self.presenterActivated()
		}
		// todo why is this not simply in the closure immediately above?
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) { timer in
			_ = signals.stopScanningFor(signal: FZSignalConsts.presenterActivated, scanner: self)
			timer.invalidate()
		}
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { closet?.deallocate() }
	public func presenterActivated () {}
}

public protocol FZInteractorProtocol: FZViperClassProtocol {
	var closet: FZInteractorCloset? { get }
	func presenterActivated ()
}
