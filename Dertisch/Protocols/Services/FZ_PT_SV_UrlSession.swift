//
//  FZ_PT_SV_UrlSession.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

public protocol FZUrlSessionServiceProtocol: FZModelClassProtocol {
	func call (
		url: String,
		method: FZUrlSessionService.methods,
		parameters: Dictionary< String, String >?,
		scanner: FZSignalReceivableProtocol?,
		callback: ( ( String, Any? ) -> Void )? )
}
