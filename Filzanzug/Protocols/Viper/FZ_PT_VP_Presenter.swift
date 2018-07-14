//
//  FZ_PT_VP_Presenter.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZPresenterProtocol {
	public var instanceDescriptor: String { return String(describing: self) }
	
	// todo this is repeated code, here and in FZInteractorProtocol, is there any way to avoid repeating it?
	public var closet: FZPresenterEntities? {
		let selfReflection = Mirror( reflecting: self )
		var ents: FZPresenterEntities?
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZPresenterEntities {
				if ents != nil { fatalError("FZPresenters can only possess one FZWornCloset") }
				ents = (child.value as? FZPresenterEntities)
			}
		}
		return ents
	}
	var closet_key: String? {
		let selfReflection = Mirror( reflecting: self )
		var key: String?
		for (_, child) in selfReflection.children.enumerated() {
			if child.value is FZKeyring {
				if key != nil { fatalError("FZPresenters can only possess one FZKeyring") }
				key = (child.value as? FZKeyring)?.hash
			}
		}
		return key
	}
	
	
	
	public func activate () {
		guard
			let closetKey = closet_key,
			let signals = closet?.signals(closetKey)
			else { return }
//		guard let scopedKey = closet_key else { return }
		_ = signals.scanOnceFor(signal: FZSignalConsts.viewLoaded, scanner: self) { _, data in
			guard
				let passedViewController = data as? FZViewController,
				let ownViewController = self.closet?.viewController(closetKey),
				passedViewController == ownViewController
				else { return }
			signals.scanOnceFor(signal: FZSignalConsts.navigateTo, scanner: self) { _, data in
				guard let viewName = data as? String else { return }
				self.present(viewName)
			}
			self.postViewActivated()
			signals.transmit(signal: FZSignalConsts.presenterActivated, with: self)
		}
	}
	
	public func present (_ viewName: String) {
		guard
			let closetKey = closet_key,
			let viewController = closet?.viewController(closetKey)
			else { return }
		closet?.routing(closetKey)?.present(viewController: viewName, on: viewController)
	}
	
	// todo use a mirror to run through objects checking if they are FZDeallocatable and deallocating if so, and same in interactor?
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () {}
	public func postViewActivated () {}
}

public protocol FZPresenterProtocol: FZViperClassProtocol {
	var closet: FZPresenterEntities? { get }
	mutating func postViewActivated()
	func present(_ viewName: String)
}
