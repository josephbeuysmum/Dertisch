//
//  FZ_PT_UT_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZInteractorProtocol {
	public var instanceDescriptor: String { return String( describing: self ) }
	
	// todo this is repeated code, here and in FZPresenterProtocol, is there any way to avoid repeating it?
	public var closet: FZInteractorCloset? {
		let selfReflection = Mirror( reflecting: self )
		var ents: FZInteractorCloset?
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZInteractorCloset {
				if ents != nil { fatalError("FZInteractors can only possess one FZInteractorCloset") }
				ents = (child.value as? FZInteractorCloset)
			}
		}
		return ents
	}
	fileprivate var key_: String? {
		let selfReflection = Mirror( reflecting: self )
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZKey {
				return (child.value as? FZKey)?.hash
			}
		}
		return nil
	}

	
	
	public func activate () {
		guard
			let scopedKey = key_,
			let scopedEntities = closet,
			let presenterClassName = scopedEntities.presenter(scopedKey)?.instanceDescriptor,
			let signals = scopedEntities.signals(scopedKey)
			else { return }
		_ = signals.scanFor(signal: FZSignalConsts.presenterActivated, scanner: self) { _, data in
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.instanceDescriptor == presenterClassName
				else { return }
			self.postPresenterActivated()
		}
		// todo why is this not simply in the closure immediately above?
		_ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) { timer in
			_ = signals.stopScanningFor(signal: FZSignalConsts.presenterActivated, scanner: self)
			timer.invalidate()
		}
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { closet?.deallocate() }
	public func postPresenterActivated () {}
}

public protocol FZInteractorProtocol: FZViperClassProtocol {
	var closet: FZInteractorCloset? { get }
	func postPresenterActivated ()
}
