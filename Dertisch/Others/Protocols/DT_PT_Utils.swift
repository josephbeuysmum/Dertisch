//
//  DT_PT_Utils.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo cleanUp in a better way, with weak vars etc
public protocol DTDeallocatableProtocol {
	mutating func cleanUp ()
}

public protocol DTDescribableProtocol {
	var description: String { get }
}

public protocol DTServeCustomerProtocol {
	mutating func serve<T>(with data: T?)
}

//public protocol DTServeCustomerAgainProtocol {
//	mutating func serveAgain<T>(with data: T?)
//}

// todo: the presenter Model presenting a viewController: bad code smell
public protocol DTPresentCustomerProtocol {
	func serve(_ customerId: String, animated: Bool)
}

public protocol DTOrdererProtocol {}

public protocol DTSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T)
}

// todo the places where protocols and their extensions live is becoming increasingly messy, refactor into some sensible system
public extension DTSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T) {
		let reflection = Mirror(reflecting: delegate)
		for (_, child) in reflection.children.enumerated() {
			if child.value is Self {
				fatalError("DTSingleInstanceProtocol delegates can only possess one instance of <T>.self")
			}
		}
	}
}
