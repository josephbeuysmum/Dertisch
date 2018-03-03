//
//  FZ_ET_CL_InteractorEntities.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

extension FZInteractorEntities: FZInteractorEntitiesCollectionProtocol {}

public class FZInteractorEntities {
	public var image: FZImageProxy? { return _image }
	public var presenter: FZPresenterProtocol? { return _presenter }
	
	fileprivate var
	_image: FZImageProxy?,
	_presenter: FZPresenterProtocol?
	
	
	
	public required init ( image: FZImageProxy? = nil, presenter: FZPresenterProtocol? = nil ) {
		_image = image
		_presenter = presenter
	}
	
	public func deallocate () {
		_image = nil
		_presenter = nil
	}
}
