//
//  FZ_PT_SV_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

protocol FZSignalsServiceProtocol {
	typealias FZSignalCallback = (String, Any?) -> Void
	func annulSignal (by key: String, scanner: AnyObject)
	func hasSignal (for key: String) -> Bool
	func scanFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback ) -> Bool
	func scanOnceFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback
		) -> Bool
	func stopScanningFor (key: String, scanner: AnyObject)
	func transmitSignal (by key: String, with value: Any?)
}
