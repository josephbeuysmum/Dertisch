//
//  FZ_PT_SV_API.swift
//  Boilerplate
//
//  Created by Richard Willis on 17/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public protocol FZUrlSessionServiceProtocol: FZModelClassProtocol {
	func call (
		url: String,
		method: FZUrlSessionService.methods,
		parameters: Dictionary< String, String >?,
		scanner: AnyObject?,
		block: ( ( String, Any? ) -> Void )? )
}
