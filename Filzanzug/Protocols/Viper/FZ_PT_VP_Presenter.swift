//
//  FZ_PT_VP_Presenter.swift
//  Filzanzug
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public extension FZPresenterProtocol {
	public var className: String { return String( describing: self ) }
//	public var viewController: FZViewController? { return wornCloset.getPresenterEntities( by: _closetKey )?.viewController }
	fileprivate var _closetKey: String? {
		let selfReflection = Mirror( reflecting: self )
		for ( _, child ) in selfReflection.children.enumerated() {
			if child.value is FZKeyring { return ( child.value as? FZKeyring )?.key }
		}
		return nil
	}

	
	
	public func activate () {
		guard
			let scopedClosetKey = _closetKey,
			let scopedSignals = wornCloset.getSignals( by: scopedClosetKey )
			else { return }
//		guard let scopedKey = _closetKey else { return }
		_ = scopedSignals.scanOnceFor( key: FZSignalConsts.viewLoaded, scanner: self as AnyObject ) {
//			[ unowned self ]
			_, data in
			guard data as? FZViewController == self.wornCloset.getPresenterEntities( by: scopedClosetKey )?.viewController else { return }
			scopedSignals.transmitSignalFor( key: FZSignalConsts.presenterActivated, data: self )
			self.postViewActivated() }
	}
	
	public func present ( viewName: String ) {
		guard let presenterEntities = wornCloset.getPresenterEntities( by: _closetKey ) else { return }
		presenterEntities.routing?.present( viewController: viewName, on: presenterEntities.viewController! )
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postViewActivated () { lo() }
}

public protocol FZPresenterProtocol: FZWornClosetImplementerProtocol {
//	var viewController: FZViewController? { get }
	func postViewActivated ()
	func present ( viewName: String )
}
