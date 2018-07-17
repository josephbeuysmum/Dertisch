//
//  FZ_PT_Entities.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZBespokeEntitiesEntityProtocol {
	var bespoke: FZBespokeEntities { get }
}

public protocol FZCDEntityProtocol {
	var attributes: [String: FZCDAble] { get }
	var name: String { get }
	init (_ name: String, keys: [FZCDKey])
	mutating func add(_ attribute: FZCDAble, by key: String) -> Bool
}

public protocol FZKeyProtocol: FZSingleInstanceProtocol {
	var teeth: String { get }
	init(_ delegate: FZViperClassProtocol)
}

public protocol FZObject: Hashable {}

public protocol FZSignalProtocol: FZDeallocatableProtocol {
	var hasScanners: Bool { get }
	init ( _ transmission: String )
	mutating func add(callback: @escaping FZSignalCallback, scanner: FZSignalReceivableProtocol, scansContinuously: Bool) -> Bool
	mutating func add(delegate: FZSignalCallbackDelegateProtocol, scanner: FZSignalReceivableProtocol, scansContinuously: Bool) -> Bool
	mutating func remove(scanner: FZSignalReceivableProtocol)
	mutating func removeAllWavelengths()
	mutating func removeSingleUseWavelengths()
	func transmit ( with value: Any? )
}
