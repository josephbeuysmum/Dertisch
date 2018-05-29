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
//	public var viewController: FZViewController? { return wornCloset.getPresenterEntities( by: closet_key )?.viewController }
	// todo this is repeated code, is there any way to avoid repeating it?
	fileprivate var closet_key: String? {
		let selfReflection = Mirror( reflecting: self )
		var key: String?
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZKeyring {
				if key != nil { fatalError("FZPresenters can only possess one FZKeyring") }
				key = (child.value as? FZKeyring)?.key
			}
		}
		return key
	}
	
	
	
	public func activate () {
		guard
			let scopedClosetKey = closet_key,
			let scopedSignals = wornCloset.getSignals(by: scopedClosetKey)
			else { return }
//		guard let scopedKey = closet_key else { return }
		_ = scopedSignals.scanOnceFor(key: FZSignalConsts.viewLoaded, scanner: self) { _, data in
			guard
				let passedVC = data as? FZViewController,
				passedVC == self.wornCloset.getPresenterEntities(by: scopedClosetKey)?.viewController
				else { return }
			scopedSignals.transmitSignal(by: FZSignalConsts.presenterActivated, with: self)
			scopedSignals.scanOnceFor(key: FZSignalConsts.navigateTo, scanner: self) { _, data in
				guard let viewName = data as? String else { return }
				self.present(viewName)
			}
			self.postViewActivated() }
	}
	
	public func present (_ viewName: String) {
		guard
			let presenterEntities = wornCloset.getPresenterEntities(by: closet_key) else {
				return }
		presenterEntities.routing?.present(viewController: viewName, on: presenterEntities.viewController!)
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postViewActivated () {}
}

public protocol FZPresenterProtocol: FZWornClosetImplementerProtocol {
//	var viewController: FZViewController? { get }
	func postViewActivated()
	func present(_ viewName: String)
}
