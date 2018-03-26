//
//  FZ_PT_Proxies.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData
import UIKit

public protocol FZCoreDataProxyProtocol: FZModelClassProtocol {
	var dataModelName: String? { get set }
	func delete ( entityName: String )
	func delete ( entityName: String, byCondition closure: @escaping ( NSManagedObject ) -> Bool )
	func retrieve ( entityName: String, byPredicate predicate: String? )
	func store ( entities entitiesData: FZCoreDataEntity )
	func update ( entityName: String, byPredicate predicate: String, updatingTo key: FZCoreDataKey )
}

public protocol FZTemporaryValuesProxyProtocol: FZModelClassProtocol {
	func getValue ( by key: String ) -> String?
	func set ( _ value: String, by key: String )
	func annulValue ( by key: String )
	func removeValues ()
//	// on device [deprecated]
//	func retrieveValue ( by key: String ) -> String?
//	func store ( value: String, by key: String, and caller: FZCaller? )
//	func deleteValue ( by key: String )
}

public protocol FZImageProxyProtocol: FZModelClassProtocol {
//	func clearStorage ()
	func getImage ( by url: String, callback: ( ( String, Any? ) -> Void )? ) -> UIImage?
	func loadImage ( by url: String )
}
