//
//  DT_UT_Protocols.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol CigaretteBreakProtocol {
	mutating func startBreak ()
	mutating func endBreak ()
}

public protocol DescribableProtocol {
	var description: String { get }
}

// todo endShift in a better way, with weak vars etc
public protocol EndShiftProtocol {
	mutating func endShift ()
}

public protocol GiveOrderProtocol {
	mutating func give(_ order: Order)
}

public protocol StartShiftProtocol {
	func startShift()
}

// todo: the presenter Model presenting a viewController: bad code smell
//public protocol DTPresentCustomerProtocol {
//	func serve(_ customerId: String, animated: Bool)
//}

//public protocol DTSingleInstanceProtocol {
//	func guaranteeSingleInstanceOfSelf<T>(within delegate: T)
//}
//
//
//
//// todo the places where protocols and their extensions live is becoming increasingly messy, refactor into some sensible system
//public extension DTSingleInstanceProtocol {
//	func guaranteeSingleInstanceOfSelf<T>(within delegate: T) {
//		let reflection = Mirror(reflecting: delegate)
//		for (_, child) in reflection.children.enumerated() {
//			if child.value is Self {
//				fatalError("DTSingleInstanceProtocol delegates can only possess one instance of <T>.self")
//			}
//		}
//	}
//}

public protocol FreezerEntityProtocol {
	var attributes: [String: StorableDataType] { get }
	var name: String { get }
	init (_ name: String, keys: [FreezerKey])
	mutating func add(_ attribute: StorableDataType, by key: String) -> Bool
}

public protocol StorableDataType {}

extension Bool: StorableDataType {}
extension Double: StorableDataType {}
extension Float: StorableDataType {}
extension Int: StorableDataType {}
extension String: StorableDataType {}
