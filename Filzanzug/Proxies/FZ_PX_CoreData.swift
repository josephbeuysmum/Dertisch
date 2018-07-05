//
//  FZ_PX_CoreData.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData

public enum FZCDOperationTypes { case delete, retrieve, store, update }

extension FZCoreDataProxy: FZCoreDataProxyProtocol {
	public var dataModelName: String? {
		get { return data_model_name }
		set {
			guard data_model_name == nil else { fatalError("Currently FZCoreDataProxy dataModelName can only be set once") }
			data_model_name = newValue
		}
	}
	
	public var wornCloset: FZWornCloset? { return worn_closet }
	
	
	
	public func delete(entityName: String, _ callback: @escaping FZCDDeletionCallback) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let
		request = NSFetchRequest< NSFetchRequestResult >(entityName: entityName),
		deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
		do {
			try privateContext.execute(deleteRequest)
			DispatchQueue.main.async { callback(true) }
		} catch {
			DispatchQueue.main.async { callback(false) }
		}
	}
	
	public func delete(entityName: String, by condition: @escaping (NSManagedObject) -> Bool, _ callback: @escaping FZCDDeletionCallback) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let
		request = NSFetchRequest< NSFetchRequestResult >(entityName: entityName),
		asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) { asyncResult in
			guard let managedObjects = asyncResult.finalResult as? [NSManagedObject] else { return }
			managedObjects.forEach { managedObject in
				if condition(managedObject) {
					privateContext.delete(managedObject)
				}
			}
			do { try privateContext.save()
			} catch {
				DispatchQueue.main.async { callback(false) }
				return
			}
		}
		do {
			try privateContext.execute( asyncRequest )
			DispatchQueue.main.async { callback(true) }
		} catch {
			DispatchQueue.main.async { callback(false) }
		}
	}
	
	public func retrieve(_ entityName: String, by predicate: String? = nil, _ callback: @escaping FZCDCallback) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		if let scopedPredicate = predicate {
			fetchRequest.predicate = NSPredicate(format: scopedPredicate)
		}
		let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asyncFetchResult in
			guard let result = asyncFetchResult.finalResult as? [NSManagedObject] else { return }
			DispatchQueue	.main.async {
				// create queue-safe array on the main thread
				var safeManagedObjects = [NSManagedObject]()
				for managedObject in result {
					let safeManagedObject = privateContext.object(with: managedObject.objectID)
					safeManagedObjects.append(safeManagedObject)
				}
				callback(safeManagedObjects.count > 0 ? safeManagedObjects : nil)
//				self.worn_closet.getSignals(by: self.key_ring.key)?.transmitSignal(
//					by: self.getSignalKey(by: entityName, and: FZCDOperationTypes.retrieve),
//					with: safeManagedObjects.count > 0 ? safeManagedObjects : nil)
			}
		}
		do { try privateContext.execute(asyncFetchRequest)
		} catch let error {
			loWarning("NSAsynchronousFetchRequest error: \(error)")
		}
	}
	
	public func store(_ entity: FZCDEntity, _ callback: @escaping FZCDCallback) {
		var managedEntity: NSManagedObject?
		persistentContainer?.performBackgroundTask { privateContext in
			managedEntity = NSEntityDescription.insertNewObject( forEntityName: entity.name, into: privateContext )
			for (key, value) in entity.attributes {
				managedEntity?.setValue(value, forKey: key)
			}
			do {
				try privateContext.save()
				DispatchQueue.main.async {
					callback(managedEntity != nil ? [managedEntity!] : nil)
				}
			} catch {
				fatalError("Failure to save context: \(error)")
			}
		}
	}
	
	public func update(_ entityName: String, to attribute: FZCDAttribute, by predicate: String? = nil, _ callback: @escaping FZCDCallback) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
		privateContext.perform {
			let updateRequest = NSBatchUpdateRequest(entityName: entityName)
			updateRequest.propertiesToUpdate = [attribute.key: attribute.value]
			updateRequest.resultType = .updatedObjectIDsResultType
			if let scopedPredicate = predicate {
				updateRequest.predicate = NSPredicate(format: scopedPredicate)
			}
			do {
				let result = try privateContext.execute(updateRequest) as? NSBatchUpdateResult
				DispatchQueue.main.async {
					guard let objectIDs = result?.result as? [NSManagedObjectID] else { return }
					var objects = [NSManagedObject]()
					objectIDs.forEach { objectID in
						let object = privateContext.object(with: objectID)
						privateContext.refresh(object, mergeChanges: false)
						objects.append(object)
					}
					callback(objects)
				}
			} catch {
				fatalError( "request error: \(error)")
			}
		}
	}
	
	
	
//	fileprivate func getCoreDataValue(by type: FZCDTypes) -> Any {
//		switch type {
//		case let .string:	return string
//		case let .int:			return int
//		case let .bool:		return bool
//		}
//	}
}

public class FZCoreDataProxy {
	lazy var persistentContainer: NSPersistentContainer? = {
		guard let dmn = dataModelName else {
			loWarning("FZCoreDataProxy dataModelName is nil")
			return nil
		}
		let container = NSPersistentContainer(name: dmn)
		container.loadPersistentStores { _, error in
			guard error == nil else { fatalError(" Core Data error: \(error!)") }
		}
		return container
	}()
	
	fileprivate let
	key_ring: FZKeyring,
	worn_closet: FZWornCloset
	
	fileprivate var
	is_activated: Bool,
	data_model_name: String?

	required public init(with keyring: FZKeyring) {
		is_activated = false
		key_ring = keyring
		worn_closet = FZWornCloset(key_ring.key)
	}
	
	deinit {}
}
