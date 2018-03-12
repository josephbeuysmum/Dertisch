//
//  FZ_ET_CL_InteractorEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorEntities: FZInteractorEntitiesCollectionProtocol {
	public var bespokeRail: FZBespokeEntities { return bespoke_entities! }
	public var image: FZImageProxy? { return image_ }
	public var presenter: FZPresenterProtocol? { return presenter_ }
	
	public func deallocate () {
		bespoke_entities?.deallocate()
		image_?.deallocate()
		presenter_?.deallocate()
		bespoke_entities = nil
		image_ = nil
		presenter_ = nil
	}
}

public class FZInteractorEntities {
	fileprivate var
	image_: FZImageProxy?,
	presenter_: FZPresenterProtocol?
	
	fileprivate lazy var bespoke_entities: FZBespokeEntities? = FZBespokeEntities()
	
	public required init ( image: FZImageProxy? = nil, presenter: FZPresenterProtocol? = nil ) {
		image_ = image
		presenter_ = presenter
	}
}
