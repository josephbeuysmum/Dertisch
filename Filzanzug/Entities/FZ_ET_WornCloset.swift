//
//  FZ_ETworn_closet.swift
//  Filzanzug
//
//  Created by Richard Willis on 12/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import Foundation

// we have to make the WornCloset a class not a struct because we access it from a protocol extension and in that context will simply be copied if it is a struct
extension FZWornCloset: FZWornClosetProtocol {
	public func deallocate () {
		entities_?.deallocate()
		entities_ = nil
		signals_ = nil
	}
	
	public func getInteractorEntities ( by key: String? ) -> FZInteractorEntities? {
		return key == key_ ? entities_ as? FZInteractorEntities : nil
	}
	
	public func getModelClassEntities ( by key: String? ) -> FZModelClassEntities? {
		return key == key_ ? entities_ as? FZModelClassEntities : nil
	}
	
	public func getPresenterEntities ( by key: String? ) -> FZPresenterEntities? {
		return key == key_ ? entities_ as? FZPresenterEntities : nil
	}
	
	public func getSignals ( by key: String? ) -> FZSignalsService? { return key == key_ ? signals_ : nil }
	
	public func set ( entities: FZEntitiesCollectionProtocol ) {
		guard entities_ == nil else { return }
		entities_ = entities
	}
	
	public func set ( signals: FZSignalsService ) {
		guard signals_ == nil else { return }
		signals_ = signals
	}
}

public class FZWornCloset {
	fileprivate let key_: String
	
	fileprivate var
	signals_: FZSignalsService?,
	entities_: FZEntitiesCollectionProtocol?
	
	required public init ( _ key: String ) { key_ = key }
}
