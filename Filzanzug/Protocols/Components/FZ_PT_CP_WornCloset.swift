//
//  FZ_PT_ET_WornCloset.swift
//  Hasenblut
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZWornClosetProtocol: FZDeallocatableProtocol, FZInitableProtocol {
	var entities: FZEntitiesCollectionProtocol? { get set }
	var key: String { get }
	var interactorEntities: FZInteractorEntities? { get }
	var modelClassEntities: FZModelClassEntities? { get }
	var presenterEntities: FZPresenterEntities? { get }
}
