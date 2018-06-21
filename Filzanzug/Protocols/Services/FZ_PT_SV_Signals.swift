//
//  FZ_PT_SV_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

protocol FZSignalsServiceProtocol {
	typealias FZSignalCallback = (String, Any?) -> Void
	func annul(signal key: String, scanner: AnyObject)
	func has(signal key: String) -> Bool
	func scanFor (
		signal key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback ) -> Bool
	func scanOnceFor (
		signal key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback
		) -> Bool
	func stopScanningFor(signal key: String, scanner: FZSignalReceivableProtocol)
	func transmit(signal key: String, with value: Any?)
}
