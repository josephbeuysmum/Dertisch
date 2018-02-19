//
//  FZ_PT_Interactor.swift
//  Hasenblut
//
//  Created by Richard Willis on 22/06/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorProtocol {
	public var className: String { return String( describing: self ) }
	public var presenter: FZPresenterProtocol? {
		guard let implementerKey = wornCloset.getClosetKey( by: _protocolKey ) else { return nil }
		return wornCloset.interactorEntities?.getPresenterBy( key: implementerKey )
	}
	
	fileprivate var _protocolKey: String { return "832DE159-7FCB-4CF3-B9CB-E0B7AC372DC0" }
	
	
	
	public func activate () {
		guard !wornCloset.isActivated else { return }
		wornCloset.activate( with: _protocolKey )
		guard
			let implementerKey = wornCloset.getClosetKey( by: _protocolKey ),
			let presenterClassName = wornCloset.interactorEntities?.getPresenterBy( key: implementerKey )?.className,
			let scopedSignals = wornCloset.signalBox?.getSignalsServiceBy( key: implementerKey )
			else { return }
		_ = scopedSignals.scanOnceFor( key: FZSignalConsts.presenterActivated, scanner: self ) {
			[ unowned self ] _, data in
			guard
				let presenter = data as? FZPresenterProtocol,
				presenter.className == presenterClassName
				else { return }
			scopedSignals.transmitSignalFor( key: FZSignalConsts.interactorActivated, data: self )
			self.postPresenterActivated() }
	}
	
	public func fillWornCloset () {
		guard let implementerKey = wornCloset.set( protocolKey: _protocolKey ) else { return }
		wornCloset.set( entities: FZInteractorEntities( implementerKey ) )
		wornCloset.set( signalBox: FZSignalsEntity( implementerKey ) )
	}
	
	public func getProtocolKey ( with implementerKey: String ) -> String? {
		return wornCloset.signalBox?.getSignalsServiceBy( key: implementerKey ) != nil ? _protocolKey : nil
	}
	
	// implemented just in case they are not required in their given implementer, so that a functionless function need not be added
	public func deallocate () { wornCloset.deallocate() }
	public func postPresenterActivated () {}
}

public protocol FZInteractorProtocol: FZWornClosetImplementerProtocol {
	var presenter: FZPresenterProtocol? { get }
	func postPresenterActivated ()
}
