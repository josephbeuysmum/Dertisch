//
//  FZ_PT_SV_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZSignalCallbackDelegateProtocol {
	mutating func signalTransmission<T>(name: String, data: T?)
}

protocol FZSignalsServiceProtocol {
	func annul(signal key: String, scanner: AnyObject)
	func has(signal key: String) -> Bool
	func scanFor(signal key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool
	func scanFor(signal key: String, scanner: FZSignalReceivableProtocol, delegate: FZSignalCallbackDelegateProtocol) -> Bool
	func scanOnceFor( signal key: String, scanner: FZSignalReceivableProtocol, callback: @escaping FZSignalCallback) -> Bool
	func scanOnceFor(signal key: String, scanner: FZSignalReceivableProtocol, delegate: FZSignalCallbackDelegateProtocol) -> Bool
	func stopScanningFor(signal key: String, scanner: FZSignalReceivableProtocol)
	func transmit(signal key: String, with value: Any?)
}
