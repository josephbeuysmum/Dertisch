//
//  FZ_PT_ET_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 17/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZInteractorEntitiesCollectionProtocol: FZEntitiesCollectionProtocol {
	var image: FZImageProxy? { get }
	var presenter: FZPresenterProtocol? { get }
	init ( image: FZImageProxy?, presenter: FZPresenterProtocol? )
}
