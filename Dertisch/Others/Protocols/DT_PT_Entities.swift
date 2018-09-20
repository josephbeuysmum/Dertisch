//
//  DT_PT_Entities.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//public protocol DTBespokeEntitiesEntityProtocol {
//	var bespoke: DTBespokeEntities { get }
//}

public protocol DTCDEntityProtocol {
	var attributes: [String: DTStorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [DTCDKey])
	mutating func add(_ attribute: DTStorableDataType, by key: String) -> Bool
}

//public protocol DTKeyProtocol: DTSingleInstanceProtocol {
//	var teeth: String { get }
//	init(_ delegate: DTSwitchClassProtocol)
//}

//public protocol DTObject: Hashable {}

public protocol DTOrderProtocol: DTDeallocatableProtocol {
	var hasOrders: Bool { get }
	init ( _ transmission: String )
	mutating func add(callback: @escaping DTOrderCallback, order: DTOrdererProtocol, isContinuous: Bool) -> Bool
	mutating func add(delegate: DTOrderCallbackDelegateProtocol, order: DTOrdererProtocol, isContinuous: Bool) -> Bool
	mutating func cancel(order: DTOrdererProtocol)
	mutating func removeAllDetails()
	mutating func removeSingleUseWavelengths()
	func transmit ( with value: Any? )
}

public protocol DTStorableDataType {}

extension Bool: DTStorableDataType {}
extension Double: DTStorableDataType {}
extension Float: DTStorableDataType {}
extension Int: DTStorableDataType {}
extension String: DTStorableDataType {}
