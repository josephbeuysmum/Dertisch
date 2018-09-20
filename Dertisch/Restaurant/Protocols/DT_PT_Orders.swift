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
	func cancel(order key: String, orderer: AnyObject)
	func has(order key: String) -> Bool
	func take(order key: String, orderer: DTOrdererProtocol, callback: @escaping DTOrderCallback) -> Bool
//	func take(order key: String, orderer: DTOrdererProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool
	func takeSingle(order key: String, orderer: DTOrdererProtocol, callback: @escaping DTOrderCallback) -> Bool
//	func takeSingle(order key: String, orderer: DTOrdererProtocol, delegate: DTOrderCallbackDelegateProtocol) -> Bool
	func stopWaitingFor(order key: String)//, orderer: DTOrdererProtocol)
	func make(order key: String, with value: Any?)
}
