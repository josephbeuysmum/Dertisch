//
//  FZ_ET_WornCloset.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// we have to make the WornCloset a class not a struct because we access it from a protocol extension and in that context will simply be copied if it is a struct
public class FZWornCloset: FZWornClosetProtocol {
//	public var signals: FZSignalsService? {
//		get { return nil }
//		set {
//			guard _signals == nil else { return }
//			_signals = newValue
//		}
//	}
//	public var entities: FZEntitiesCollectionProtocol? {
//		get { return _entities }
//		set {
//			guard _entities == nil else { return }
//			_entities = newValue
//		}
//	}
	
	fileprivate let _key: String
	
	fileprivate var
	_signals: FZSignalsService?,
	_entities: FZEntitiesCollectionProtocol?

	
	
	required public init ( _ key: String ) { _key = key }
	
	public func deallocate () {
		_entities?.deallocate()
		_entities = nil
		_signals = nil
	}
	
	
	
	public func getInteractorEntities ( by key: String? ) -> FZInteractorEntities? {
		return key == _key ? _entities as? FZInteractorEntities : nil
	}
	
	public func getModelClassEntities ( by key: String? ) -> FZModelClassEntities? {
		return key == _key ? _entities as? FZModelClassEntities : nil
	}
	
	public func getPresenterEntities ( by key: String? ) -> FZPresenterEntities? {
		return key == _key ? _entities as? FZPresenterEntities : nil
	}
	
	public func getSignals ( by key: String? ) -> FZSignalsService? { return key == _key ? _signals : nil }
	
	public func set ( entities: FZEntitiesCollectionProtocol ) {
		guard _entities == nil else { return }
		_entities = entities
	}
	
	public func set ( signals: FZSignalsService ) {
		guard _signals == nil else { return }
		_signals = signals
	}
}
