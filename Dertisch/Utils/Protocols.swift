//
//  Protocols.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol CigaretteBreakable {
	func beginBreak()
	func endBreak()
}

extension CigaretteBreakable {
	public func beginBreak() {}
	public func endBreak() {}
}

public protocol Describable {
	var description: String { get }
}

//public protocol Initializable {
//	init()
//}

internal protocol ComplexColleagueProtocol: StaffRelatable {
	var internalKey: String { get }
	func beginShift()
	func endShift()
}

public protocol StaffHead {}

public protocol SimpleColleagueProtocol {}

public protocol Shiftable {
	func beginShift()
	func endShift()
}

public protocol GiveCustomerOrderable {
	func give(_ key: String, _ order: CustomerOrder)
}

public protocol KitchenResource: Shiftable {
	init(_ resources: [String: KitchenResource]?)
}

extension KitchenResource {
	static public var staticId: String { return String(describing: self) }
	public func beginShift() {}
	public func endShift() {}
}

public protocol StaffMember: CigaretteBreakable {}

public protocol FreezerEntitiable {
	var attributes: [String: StorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [FreezerKey])
	mutating func add(_ attribute: StorableDataType, _ key: String) -> Bool
}

public protocol StorableDataType {}

internal protocol StaffRelatable: class {
//	var isInjected: Bool { get }
}

extension Bool: StorableDataType {}
extension Double: StorableDataType {}
extension Float: StorableDataType {}
extension Int: StorableDataType {}
extension String: StorableDataType {}
