//
//  DT_PT_Proxies.swift
//  Dertisch
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData
import UIKit

// todo should these live here?
public typealias DTCDCallback = ([NSManagedObject]?) -> Void
public typealias DTCDDeletionCallback = (Bool) -> Void
public typealias DTOrderCallback = (String, Any?) -> Void

// todo make more funcs etc "final"
// todo? maybe move protocols into their implementing classes
public protocol DTCoreDataProtocol: DTKitchenProtocol {
	var dataModelName: String? { get set }
	func delete(entityName: String, _ callback: @escaping DTCDDeletionCallback)
	func delete(entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping DTCDDeletionCallback)
	func retrieve(_ entityName: String, by predicate: String?, _ callback: @escaping DTCDCallback)
	func store(_ entity: DTCDEntity, _ callback: @escaping DTCDCallback)
//	func update(_ entityName: String, to key: DTCDKey, by predicate: String?, _ callback: @escaping DTCDCallback)
	func update(_ entityName: String, to attribute: DTCDAttribute, by predicate: String?, _ callback: @escaping DTCDCallback)
}

public protocol DTTemporaryValuesProtocol: DTKitchenProtocol {
	func getValue(by key: String, andAnnul: Bool?) -> DTStorableDataType?
	func set(_ value: DTStorableDataType, by key: String)
	func annulValue(by key: String)
	func removeValues ()
}

public protocol DTImagesProtocol: DTKitchenProtocol {
	func getImage(by url: String, callback: ((String, Any?) -> Void)?) -> UIImage?
	func loadImage(by url: String)
}
