//
//  FZ_PT_Entities.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZBespokeEntitiesEntityProtocol {
	var bespokeRail: FZBespokeEntities { get }
}

public protocol FZCoreDataEntityProtocol {
	var allAttributes: [ [ FZCoreDataTypes ] ] { get }
	var name: String { get }
	init ( name: String, keys: [ FZCoreDataKey ] )
	mutating func add ( attributes: [ FZCoreDataTypes ] )
	mutating func add ( multipleAttributes: [ [ FZCoreDataTypes ] ] )
	func getKey ( by index: Int ) -> String?
}

public protocol FZKeyringProtocol {
	var key: String { get }
}

public protocol FZRoutingEntityProtocol {
	var routing: FZRoutingService? { get set }
}

public protocol FZSignalBoxEntityProtocol {
	var signalBox: FZSignalsEntity { get }
}

public protocol FZSignalsEntityProtocol {
	var signals: FZSignalsService? { get set }
}

public protocol FZStopwatchEntityProtocol: FZDeallocatableProtocol {
	func getStopwatchBy ( key: String ) -> FZStopwatch?
	func set ( stopwatch: FZStopwatch )
}

public protocol FZWornClosetEntityProtocol {
	var wornCloset: FZWornCloset { get }
}

// [seemingly] deprecated
//public protocol FZInteractorEntityProtocol {
//	func getInteractorBy ( key: String ) -> FZInteractorProtocol?
//	func set ( interactor: FZInteractorProtocol )
//}

//public protocol FZInteractorEntitiesEntityProtocol {
//	var entities: FZInteractorEntities! { get }
//}

//public protocol FZModelClassEntitiesEntityProtocol {
//	var entities: FZModelClassEntities! { get }
//}

//public protocol FZPresenterEntitiesEntityProtocol {
//	var entities: FZPresenterEntities! { get }
//}

//public protocol FZStopwatchCaseEntityProtocol {
//	var stopwatchCase: FZStopwatchEntity! { get }
//}
