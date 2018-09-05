//
//  DT_PT_SV_Signals.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTOrderCallbackDelegateProtocol {
	mutating func orderTransmission<T>(name: String, data: T?)
}

protocol DTOrdersProtocol {
	func cancel(order key: String, order: AnyObject)
	func has(order key: String) -> Bool
	func listenFor(order key: String, order: DTOrderReceivableProtocol, callback: @escaping DTOrderCallback) -> Bool
//	func listenFor(order key: String, order: DTOrderReceivableProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool
	func listenForOneOff(order key: String, order: DTOrderReceivableProtocol, callback: @escaping DTOrderCallback) -> Bool
//	func listenForOneOff(order key: String, order: DTOrderReceivableProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool
	func stopWaitingFor(order key: String, order: DTOrderReceivableProtocol)
	func make(order key: String, with value: Any?)
}