//
//  FZ_PT_ET_Collections.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//public protocol FZEntitiesCollectionProtocol: FZDeallocatableProtocol {}

public protocol FZInitableWithKeyProtocol {
	init (_ key: String)
}

public protocol FZSignalsEntityGetterProtocol {
	func signals(_ key: String?) -> FZSignalsService?
}

public protocol FZSignalsEntitySetterProtocol: FZDeallocatableProtocol {
	func set (signalsService: FZSignalsService)
}

public protocol FZSignalsEntityProtocol: FZSignalsEntityGetterProtocol, FZSignalsEntitySetterProtocol {}

public protocol FZBespokeEntitiesProtocol: FZDeallocatableProtocol {
	func add(_ modelClass: FZModelClassProtocol)
	subscript(type: FZModelClassProtocol.Type) -> FZModelClassProtocol? { get }
//	func get(_ type: FZModelClassProtocol.Type?) -> FZModelClassProtocol?
}

public protocol FZInteractorEntitiesProtocol: FZInitableWithKeyProtocol, FZBespokeEntitiesEntityProtocol, FZSignalsEntityProtocol {
	func imageProxy(_ key: String?) -> FZImageProxy?
	func presenter(_ key: String?) -> FZPresenterProtocol?
	func set(imageProxy: FZImageProxy)
	func set(presenter: FZPresenterProtocol)
}

public protocol FZModelClassEntitiesProtocol: FZInitableWithKeyProtocol, FZBespokeEntitiesEntityProtocol, FZSignalsEntityProtocol {
	func bundledJson(_ key: String?) -> FZBundledJsonService?
	func coreData(_ key: String?) -> FZCoreDataProxy?
	func urlSession(_ key: String?) -> FZUrlSessionService?
	func set(bundledJson: FZBundledJsonService)
	func set(coreData: FZCoreDataProxy)
	func set(urlSession: FZUrlSessionService)
}

public protocol FZPresenterEntitiesProtocol: FZInitableWithKeyProtocol, FZSignalsEntityProtocol {
	func routing(_ key: String?) -> FZRoutingService?
	func viewController(_ key: String?) -> FZViewController?
	func set(routing: FZRoutingService)
	func set(viewController: FZViewController)
}
