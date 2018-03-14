//
//  FZ_ET_CL_InteractorEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorEntities: FZInteractorEntitiesCollectionProtocol {
	public var bespokeRail: FZBespokeEntities { return bespoke_entities! }
	public var presenter: FZPresenterProtocol { return presenter_ }
	public var image: FZImageProxy? { return image_ }
	
	public func deallocate () {
		bespoke_entities?.deallocate()
		image_?.deallocate()
		presenter_.deallocate()
		bespoke_entities = nil
		image_ = nil
//		presenter_ = nil
	}
	
	public func set ( image newValue: FZImageProxy ) {
		guard image_ == nil else { return }
		image_ = newValue
	}
	
//	public func set ( presenter newValue: FZPresenterProtocol ) {
//		guard presenter_ == nil else { return }
//		presenter_ = newValue
//	}
}

public class FZInteractorEntities {
	fileprivate let presenter_: FZPresenterProtocol
	
	fileprivate var image_: FZImageProxy?
	
	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
	
	public required init ( presenter: FZPresenterProtocol ) {
		presenter_ = presenter
	}
}
