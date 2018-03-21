//
//  FZ_PT_SV_Signals.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZSignalsServiceProtocol {
	func annulSignalFor ( key: String, scanner: AnyObject )
	func hasSignalFor ( key: String ) -> Bool
	func logSignatures ()
	func scanFor (
		key: String,
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void ) -> Bool
	func scanFor (
		keys: [ String ],
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void ) -> FZGradedBool
	func scanOnceFor (
		key: String,
		scanner: AnyObject,
		block: @escaping ( String, Any? ) -> Void ) -> Bool
	func stopScanningFor ( key: String, scanner: AnyObject ) -> Bool
	func stopScanningFor ( keys: [ String ], scanner: AnyObject ) -> FZGradedBool
	func transmitSignalFor ( key: String, data: Any? )
}
