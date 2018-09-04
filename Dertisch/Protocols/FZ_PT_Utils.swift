//
//  FZ_PT_Utils.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

// todo deallocate in a better way, with weak vars etc
public protocol FZDeallocatableProtocol {
	mutating func deallocate ()
}

public protocol FZDescribableProtocol {
	var description: String { get }
}

public protocol FZPopulatableViewProtocol {
	mutating func populate<T>(with data: T?)
}

public protocol FZPresentableViewProtocol {
	func present(_ viewControllerId: String, animated: Bool)
}

public protocol FZSignalReceivableProtocol {}

public protocol FZSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T)
}

public protocol FZUpdatableProtocol {
	mutating func update<T>(with data: T?)
}

// todo the places where protocols and their extensions live is becoming increasingly messy, refactor into some sensible system
public extension FZSingleInstanceProtocol {
	func guaranteeSingleInstanceOfSelf<T>(within delegate: T) {
		let reflection = Mirror(reflecting: delegate)
		for (_, child) in reflection.children.enumerated() {
			if child.value is Self {
				fatalError("FZSingleInstanceProtocol delegates can only possess one instance of <T>.self")
			}
		}
	}
}
