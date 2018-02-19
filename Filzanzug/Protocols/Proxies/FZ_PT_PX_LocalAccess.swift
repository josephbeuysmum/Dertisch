//
//  FZ_PT_PX_LocalAccess.swift
//  Filzanzug
//
//  Created by Richard Willis on 15/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public protocol FZLocalAccessProxyProtocol: FZModelClassProtocol {
	// locally (for lifetime of app)
	func getValue ( by key: String ) -> String?
	func set ( value: String, by key: String, and caller: FZCaller? )
	func annulValue ( by key: String ) -> String?
	func removeValues ()
	// on device
	func retrieveValue ( by key: String ) -> String?
	func store ( value: String, by key: String, and caller: FZCaller? )
	func deleteValue ( by key: String )
}
