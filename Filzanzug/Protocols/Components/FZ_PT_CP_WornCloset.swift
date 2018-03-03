//
//  FZ_PT_ET_WornCloset.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZWornClosetProtocol: FZDeallocatableProtocol {
	init ( _ key: String )
	func getInteractorEntities ( by key: String? ) -> FZInteractorEntities?
	func getModelClassEntities ( by key: String? ) -> FZModelClassEntities?
	func getPresenterEntities ( by key: String? ) -> FZPresenterEntities?
	func getSignals ( by key: String? ) -> FZSignalsService?
	func set ( entities: FZEntitiesCollectionProtocol )
	func set ( signals: FZSignalsService )
}
