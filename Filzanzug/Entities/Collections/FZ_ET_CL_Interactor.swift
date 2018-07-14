//
//  FZ_ET_CL_InteractorEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorEntities: FZInteractorEntitiesProtocol {
	public var bespoke: FZBespokeEntities { return bespoke_entities! }
	
	// todo make these (and equivs in Presenter and ModelClass files) into optional subscripts
	public func imageProxy(_ key: String?) -> FZImageProxy? {
		return key == key_ ? image_proxy : nil
	}

	public func presenter(_ key: String?) -> FZPresenterProtocol? {
		return key == key_ ? presenter_ : nil
	}
	
	public func signals(_ key: String?) -> FZSignalsService? {
		return key == key_ ? signals_service : nil
	}
	
	public func deallocate () {
		bespoke_entities?.deallocate()
		image_proxy?.deallocate()
		presenter_?.deallocate()
		bespoke_entities = nil
		image_proxy = nil
		presenter_ = nil
		signals_service = nil
	}
	
	public func set(imageProxy: FZImageProxy) {
		guard image_proxy == nil else { return }
		image_proxy = imageProxy
	}

	public func set(presenter: FZPresenterProtocol) {
		guard presenter_ == nil else { return }
		presenter_ = presenter
	}
	
	public func set(signalsService: FZSignalsService) {
		guard signals_service == nil else { return }
		signals_service = signalsService
	}
}

public class FZInteractorEntities {
	fileprivate let key_: String
	
	fileprivate var
	image_proxy: FZImageProxy?,
	presenter_: FZPresenterProtocol?,
	signals_service: FZSignalsService?
	
	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
	
	required public init (_ key: String) {
		key_ = key
	}
}
