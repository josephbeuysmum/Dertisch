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
	public var entities: FZEntitiesCollectionProtocol? {
		get { return _entities }
		set {
			guard _entities == nil else { return }
			_entities = newValue
//			lo( _key, _entities )
		}
	}
	public var key: String { return _key }
	public var interactorEntities: FZInteractorEntities? { return _entities as? FZInteractorEntities }
	public var modelClassEntities: FZModelClassEntities? { return _entities as? FZModelClassEntities }
	public var presenterEntities: FZPresenterEntities? { return _entities as? FZPresenterEntities }
	
	fileprivate let _key: String
	
	fileprivate var _entities: FZEntitiesCollectionProtocol?
	
	
	
	required public init () {
		_key = NSUUID().uuidString
//		lo(_key)
	}

	public func deallocate () {
		_entities?.deallocate()
		_entities = nil
	}
}
