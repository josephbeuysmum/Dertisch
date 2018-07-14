//
//  FZ_PT_Components.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZStopwatchProtocol: FZSignalsEntityProtocol, FZSignalReceivableProtocol {
	func startWith(delay: Double, andData data: Any?, _ callback: @escaping(String, Any?) -> Void)
	func stop()
}

//public protocol FZWornClosetProtocol: FZDeallocatableProtocol {
//	init(_ key: String)
////	func getInteractorEntities(by key: String?) -> FZInteractorCloset?
//	func getModelClassEntities(by key: String?) -> FZModelClassCloset?
//	func getPresenterEntities(by key: String?) -> FZPresenterCloset?
//	func getSignals(by key: String?) -> FZSignalsService?
//	func set(entities: FZEntitiesCollectionProtocol)
//	func set(signals: FZSignalsService)
//}
