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

public protocol FZCDEntityProtocol {
	var attributes: [String: FZCDAble] { get }
	var name: String { get }
	init (_ name: String, keys: [FZCDKey])
	mutating func add(_ attribute: FZCDAble, by key: String) -> Bool
//	mutating func add(_ attribute: FZCDAttribute)
//	mutating func add (attributes: [FZCDAttribute])
}

public protocol FZKeyringProtocol {
	var key: String { get }
}

public protocol FZObject: Hashable {}

public protocol FZRoutingEntityProtocol {
	var routing: FZRoutingService? { get set }
}

public protocol FZSignalBoxEntityProtocol {
	var signalBox: FZSignalsEntity { get }
}

public protocol FZSignalsEntityProtocol {
	var signals: FZSignalsService? { get set }
}

public protocol FZSignalProtocol: FZDeallocatableProtocol {
	typealias FZSignalCallback = ( String, Any? ) -> Void
	var hasScanners: Bool { get }
	init ( _ transmission: String )
	mutating func add ( _ scanner: FZSignalReceivableProtocol, scansContinuously: Bool, callback: @escaping FZSignalCallback ) -> Bool
	mutating func remove ( _ scanner: FZSignalReceivableProtocol )
	mutating func removeAllWavelengths()
	mutating func removeSingleUseWavelengths()
	func transmit ( with value: Any? )
}

// [seemingly] deprecated

//public protocol FZStopwatchEntityProtocol: FZDeallocatableProtocol {
//	func getStopwatchBy ( key: String ) -> FZStopwatch?
//	func set ( stopwatch: FZStopwatch )
//}

//public protocol FZWornClosetEntityProtocol {
//	var wornCloset: FZWornCloset { get }
//}

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
