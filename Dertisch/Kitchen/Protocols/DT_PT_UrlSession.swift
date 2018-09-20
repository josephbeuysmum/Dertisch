//
//  DT_PT_SV_UrlSession.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTUrlSessionProtocol: DTKitchenProtocol {
	func call (
		url: String,
		method: DTUrlSession.methods,
		parameters: Dictionary< String, String >?,
		order: DTOrdererProtocol?,
		callback: ( ( String, Any? ) -> Void )? )
}
