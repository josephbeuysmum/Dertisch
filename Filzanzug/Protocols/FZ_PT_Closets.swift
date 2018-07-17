//
//  FZ_PT_ET_Collections.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZClosetProtocol: FZInitViperClassProtocol {}

public protocol FZInitViperClassProtocol {
	init(_ delegate: FZViperClassProtocol, key: FZKey)
}

public protocol FZSignalsEntityGetterProtocol {
	func signals(_ key: FZKey?) -> FZSignalsService?
}

public protocol FZSignalsEntitySetterProtocol: FZDeallocatableProtocol {
	func set (signalsService: FZSignalsService)
}

public protocol FZSignalsEntityProtocol: FZSignalsEntityGetterProtocol, FZSignalsEntitySetterProtocol {}

public protocol FZBespokeEntitiesProtocol: FZDeallocatableProtocol {
	func add(_ modelClass: FZModelClassProtocol)
	subscript(type: FZModelClassProtocol.Type) -> FZModelClassProtocol? { get }
}

public protocol FZInteractorClosetProtocol: FZClosetProtocol, FZBespokeEntitiesEntityProtocol, FZSignalsEntityProtocol, FZSingleInstanceProtocol {
	func imageProxy(_ key: FZKey?) -> FZImageProxy?
	func presenter(_ key: FZKey?) -> FZPresenterProtocol?
	func set(imageProxy: FZImageProxy)
	func set(presenter: FZPresenterProtocol)
}

public protocol FZModelClassClosetProtocol: FZClosetProtocol, FZBespokeEntitiesEntityProtocol, FZSignalsEntityProtocol, FZSingleInstanceProtocol {
	func bundledJson(_ key: FZKey?) -> FZBundledJsonService?
	func coreData(_ key: FZKey?) -> FZCoreDataProxy?
	func urlSession(_ key: FZKey?) -> FZUrlSessionService?
	func set(bundledJson: FZBundledJsonService)
	func set(coreData: FZCoreDataProxy)
	func set(urlSession: FZUrlSessionService)
}

public protocol FZPresenterClosetProtocol: FZClosetProtocol, FZSignalsEntityProtocol, FZSingleInstanceProtocol {
	func routing(_ key: FZKey?) -> FZRoutingService?
	func viewController(_ key: FZKey?) -> FZViewController?
	func set(routing: FZRoutingService)
	func set(viewController: FZViewController)
}
