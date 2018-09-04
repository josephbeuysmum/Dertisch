//
//  DT_PT_SV_UrlSession.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol DTUrlSessionSousChefProtocol: DTKitchenProtocol {
	func call (
		url: String,
		method: DTUrlSessionSousChef.methods,
		parameters: Dictionary< String, String >?,
		order: DTOrderReceivableProtocol?,
		callback: ( ( String, Any? ) -> Void )? )
}
