//
//  DT_PT_Entities.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTCDEntityProtocol {
	var attributes: [String: DTStorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [DTCDKey])
	mutating func add(_ attribute: DTStorableDataType, by key: String) -> Bool
}

public protocol DTStorableDataType {}

extension Bool: DTStorableDataType {}
extension Double: DTStorableDataType {}
extension Float: DTStorableDataType {}
extension Int: DTStorableDataType {}
extension String: DTStorableDataType {}
