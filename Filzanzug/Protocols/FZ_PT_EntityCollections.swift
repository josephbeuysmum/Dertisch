//
//  FZ_PT_ET_Collections.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZEntitiesCollectionProtocol: FZDeallocatableProtocol {}

public protocol FZBespokeEntitiesCollectionProtocol: FZEntitiesCollectionProtocol {
	func add ( modelClass: FZModelClassProtocol )
	func getModelClass ( by type: FZModelClassProtocol.Type? ) -> FZModelClassProtocol?
}

public protocol FZInteractorEntitiesCollectionProtocol: FZBespokeEntitiesEntityProtocol, FZEntitiesCollectionProtocol {
	var image: FZImageProxy? { get }
	var presenter: FZPresenterProtocol { get }
	func set ( image newValue: FZImageProxy )
	//	func set ( presenter newValue: FZPresenterProtocol )
	init ( presenter: FZPresenterProtocol )
	//	func add ( modelClass: FZModelClassProtocol )
	//	func getModelClass ( by type: FZModelClassProtocol.Type? ) -> FZModelClassProtocol?
}

public protocol FZModelClassEntitiesCollectionProtocol: FZBespokeEntitiesEntityProtocol, FZEntitiesCollectionProtocol {
	var coreData: FZCoreDataProxy? { get }
	var urlSession: FZUrlSessionService? { get }
	func set ( coreData newValue: FZCoreDataProxy )
	func set ( urlSession newValue: FZUrlSessionService )
	//	init ( coreData: FZCoreDataProxy?, urlSession: FZUrlSessionService? )
}

public protocol FZPresenterEntitiesCollectionProtocol: FZEntitiesCollectionProtocol {
	var routing: FZRoutingService? { get }
	var viewController: FZViewController? { get }
	init ( routing: FZRoutingService?, viewController: FZViewController? )
}
