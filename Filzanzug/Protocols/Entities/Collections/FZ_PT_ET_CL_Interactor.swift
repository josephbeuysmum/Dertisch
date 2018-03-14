//
//  FZ_PT_ET_Interactor.swift
//  Filzanzug
//
//  Created by Richard Willis on 17/08/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.
//

public protocol FZInteractorEntitiesCollectionProtocol: FZBespokeEntitiesEntityProtocol, FZEntitiesCollectionProtocol {
	var image: FZImageProxy? { get }
	var presenter: FZPresenterProtocol { get }
	func set ( image newValue: FZImageProxy )
//	func set ( presenter newValue: FZPresenterProtocol )

	init ( presenter: FZPresenterProtocol )
//	func add ( modelClass: FZModelClassProtocol )
//	func getModelClass ( by type: FZModelClassProtocol.Type? ) -> FZModelClassProtocol?
}
