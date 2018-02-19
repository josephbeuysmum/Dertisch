//
//  FZ_ET_Padlock.swift
//  Hasenblut
//
//  Created by Richard Willis on 12/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// we have to make the WornCloset a class not a struct because we access it from a protocol extension and in that context it can only be mutable if it is a class not a struct
public class FZWornCloset: FZWornClosetProtocol {
	public var isActivated: Bool { return _isActivated }
	public var interactorEntities: FZInteractorEntities? {
		get { return _entities as? FZInteractorEntities }
		set {} // herehere these set funcs might be great places for assertions
	}
	public var modelClassEntities: FZModelClassEntities? {
		get { return _entities as? FZModelClassEntities }
		set {}
	}
	public var presenterEntities: FZPresenterEntities? {
		get { return _entities as? FZPresenterEntities }
		set {}
	}
	public var signalBox: FZSignalsEntity? {
		get { return _signalBox }
		set {}
	}
	
	fileprivate let _implementerKey: String
	
	fileprivate var
	_isActivated: Bool,
	_entities: FZEntitiesCollectionProtocol!,
	_signalBox: FZSignalsEntity!,
	_protocolKey: String!
	
	
	
	public required init () {
		_implementerKey = NSUUID().uuidString
		_isActivated = false
	}
	
	public func activate ( with protocolKey: String ) { if protocolKey == _protocolKey { _isActivated = true } }
	
	public func deallocate () {}
	
	public func getClosetKey ( by protocolKey: String ) -> String? {
		guard _isActivated, protocolKey == _protocolKey else { return nil }
		return _implementerKey
	}
	
	public func set ( entities: FZEntitiesCollectionProtocol ) {
		guard _entities == nil else { return }
		_entities = entities
	}
	
	public func set ( protocolKey: String ) -> String? {
		guard _protocolKey == nil else { return nil }
		_protocolKey = protocolKey
		return _implementerKey
	}
	
	public func set ( signalBox: FZSignalsEntity? ) {
		guard _signalBox == nil else { return }
		_signalBox = signalBox
	}
}
