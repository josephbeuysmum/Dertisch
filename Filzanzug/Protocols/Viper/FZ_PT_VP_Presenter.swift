//
//  FZ_PT_Presenter.swift
//  Hasenblut
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZPresenterProtocol {
	var className: String { return String( describing: self ) }
	var viewController: FZViewController? {
		guard let implementerKey = wornCloset.getClosetKey( by: _protocolKey ) else { return nil }
		return wornCloset.presenterEntities?.getViewControllerBy( key: implementerKey )
	}
	
	fileprivate var _protocolKey: String { return "CE1DD38A-A355-4FA7-87D5-7A888112CF11" }
	
	
	
	public func activate () {
		guard !wornCloset.isActivated else { return }
		wornCloset.activate( with: _protocolKey )
		guard
			let implementerKey = wornCloset.getClosetKey( by: _protocolKey ),
			let viewController = wornCloset.presenterEntities?.getViewControllerBy( key: implementerKey ),
			let scopedSignals = wornCloset.signalBox?.getSignalsServiceBy( key: implementerKey )
			else { return }
		_ = scopedSignals.scanOnceFor( key: FZSignalConsts.viewLoaded, scanner: self ) {
			[ unowned self ] _, data in
			guard data as? FZViewController == viewController else { return }
			scopedSignals.transmitSignalFor( key: FZSignalConsts.presenterActivated, data: self )
			self.postViewActivated() }
	}
	
	public func fillWornCloset () {
		guard let implementerKey = wornCloset.set( protocolKey: _protocolKey ) else { return }
		wornCloset.set( entities: FZPresenterEntities( implementerKey ) )
		wornCloset.set( signalBox: FZSignalsEntity( implementerKey ) )
	}
	
	public func getProtocolKey ( with implementerKey: String ) -> String? {
		return wornCloset.signalBox?.getSignalsServiceBy( key: implementerKey ) != nil ? _protocolKey : nil
	}
	
	public func present ( viewName: String ) {
		guard
			let implementerKey = wornCloset.getClosetKey( by: _protocolKey ),
			let viewController = wornCloset.presenterEntities?.getViewControllerBy( key: implementerKey )
			else { return }
		wornCloset.presenterEntities?.getRoutingServiceBy( key: implementerKey )?.present(
			viewController: viewName,
			on: viewController )
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postViewActivated () {}
}

public protocol FZPresenterProtocol: FZWornClosetImplementerProtocol {
	var viewController: FZViewController? { get }
	func postViewActivated ()
	func present ( viewName: String )
}
