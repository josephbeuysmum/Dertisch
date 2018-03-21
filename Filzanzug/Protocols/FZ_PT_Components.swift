//
//  FZ_PT_Components.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZStopwatchProtocol: FZSignalBoxEntityProtocol {
	func startWith (
		delay: Double,
		andEndWith block: @escaping ( String, Any? ) -> Void )
	func startWith (
		delay: Double,
		andData userInfo: AnyObject,
		andEndWith block: @escaping ( String, Any? ) -> Void )
	func stop ()
}

public protocol FZWornClosetProtocol: FZDeallocatableProtocol {
	init ( _ key: String )
	func getInteractorEntities ( by key: String? ) -> FZInteractorEntities?
	func getModelClassEntities ( by key: String? ) -> FZModelClassEntities?
	func getPresenterEntities ( by key: String? ) -> FZPresenterEntities?
	func getSignals ( by key: String? ) -> FZSignalsService?
	func set ( entities: FZEntitiesCollectionProtocol )
	func set ( signals: FZSignalsService )
}