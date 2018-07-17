//
//  FZ_PT_VPworn_closet.swift
//  Filzanzug
//
//  Created by Richard Willis on 13/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

//extension FZFirstInstanceProtocol {
//	func get<T>(firstInstanceOf: T.Type) -> T? {
//		let mirror = Mirror(reflecting: self)
//		for (_, child) in mirror.children.enumerated() {
//			if let t = child.value as? T {
//				return t
//			}
//		}
//		return nil
//	}
//}

public protocol FZViperClassProtocol: FZDeallocatableProtocol, FZSignalReceivableProtocol {
	var instanceDescriptor: String { get }
	init()
	func activate()
}

//public protocol FZViperSignalTransmissionProtocol {
//	mutating func signalReceived<T>(name: String, data: T?)
//}

//protocol FZFirstInstanceProtocol {
//	func get<T>(firstInstanceOf: T.Type) -> T?
//}
