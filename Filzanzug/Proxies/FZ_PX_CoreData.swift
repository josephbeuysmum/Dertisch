//
//  FZ_PX_CoreData.swift
//  Filzanzug
//
//  Created by Richard Willis on 21/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import CoreData

extension FZCoreDataProxy: FZCoreDataProxyProtocol {
	public var wornCloset: FZWornCloset { get { return worn_closet } set {} }
	
	
	
	public func delete ( entityName: String ) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
//		lo( "start deleteAll" )
		let
		request = NSFetchRequest< NSFetchRequestResult >( entityName: entityName ),
		deleteRequest = NSBatchDeleteRequest( fetchRequest: request )
		do { try privateContext.execute( deleteRequest )
		} catch let error {
			lo( "delete error: \( error )" )
		}
//		lo( "end deleteAll" )
	}
	
	public func delete ( entityName: String, byCondition closure: @escaping ( NSManagedObject ) -> Bool ) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
//		lo( "start deleteSome" )
		let
		request = NSFetchRequest< NSFetchRequestResult >( entityName: entityName ),
		asyncRequest = NSAsynchronousFetchRequest( fetchRequest: request ) { asyncResult in
			guard let managedObjects = asyncResult.finalResult as? [ NSManagedObject ] else { return }
//			lo( "no. of objects: \( managedObjects.count )" )
			managedObjects.forEach { managedObject in
				if closure( managedObject ) {
//					lo( "deleting object: \( String( describing: managedObject ) )" )
					privateContext.delete( managedObject )
				}
			}
			do { try privateContext.save()
			} catch let error {
				lo( "delete save error: \( error )" )
			}
		}
		do {
			try privateContext.execute( asyncRequest )
		} catch let error {
			lo( "asyncRequest error: \( error )" )
		}
//		lo( "end deleteSome" )
	}
	
	public func retrieve ( entityName: String, byPredicate predicate: String? = nil ) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
//		lo("retrieveAll start")
		let
		fetchRequest = NSFetchRequest< NSFetchRequestResult >( entityName: entityName )
		if predicate != nil { fetchRequest.predicate = NSPredicate( format: predicate! ) }
		let asyncFetchRequest = NSAsynchronousFetchRequest( fetchRequest: fetchRequest ) { asyncFetchResult in
			guard let result = asyncFetchResult.finalResult as? [ NSManagedObject ] else { return }
			lo( "no. of results: \( result.count )" )
			DispatchQueue.main.async {
				// Create a new queue-safe array of copied dogs on the main thread
				var safeManagedObjects = [ NSManagedObject ]()
				for managedObject in result {
					let safeManagedObject = privateContext.object( with: managedObject.objectID )
					lo( safeManagedObject )
					safeManagedObjects.append( safeManagedObject )
				}
			}
		}
		do { try privateContext.execute( asyncFetchRequest )
		} catch let error {
			lo("NSAsynchronousFetchRequest error: \(error)")
		}
//		lo("retrieveAll end")
	}
	
	public func store ( entities entitiesData: FZCoreDataEntity ) {
//		lo( "start store" )
		persistentContainer?.performBackgroundTask { privateContext in
			entitiesData.allAttributes.forEach { attributes in
				let entity = NSEntityDescription.insertNewObject( forEntityName: entitiesData.name, into: privateContext )
				let count = attributes.count
				var val: Any
				for i in 0..<count {
					val = self.getCoreDataValue( by: attributes[ i ] )
					lo( val, entitiesData.getKey( by: i ) as Any )
					entity.setValue( val, forKey: entitiesData.getKey( by: i )! )
				}
//				lo( "new \( entitiesData.name )" )
			}
			do {
				try privateContext.save()
			} catch {
				fatalError("Failure to save context: \(error)")
			}
		}
//		lo("end store")
	}
	
	public func update ( entityName: String, byPredicate predicate: String, updatingTo key: FZCoreDataKey ) {
		guard let privateContext = persistentContainer?.newBackgroundContext() else { return }
//		lo( "start update" )
		privateContext.perform {
			let updateRequest = NSBatchUpdateRequest( entityName: entityName )
			updateRequest.predicate = NSPredicate( format: predicate )
			updateRequest.propertiesToUpdate = [ key.key: self.getCoreDataValue( by: key.type ) ]
			updateRequest.resultType = .updatedObjectIDsResultType
			do {
				let result = try privateContext.execute( updateRequest ) as? NSBatchUpdateResult
				guard let objectIDs = result?.result as? [ NSManagedObjectID ] else { return }
				lo( objectIDs.count )

				// Iterates the object IDs
//				objectIDs.forEach { objectID in
//					// Retrieve a `Dog` object queue-safe
//					let dog = self.mainManagedObjectContext.object( with: objectID ) as! Dog
//					lo( dog.name as Any )
//
//					// Updates the main context
//					self.mainManagedObjectContext.refresh( dog, mergeChanges: false )
//				}
			} catch {
				fatalError( "request error: \( error )" )
			}
		}
//		lo( "end update" )
	}
	
	
	
	fileprivate func getCoreDataValue ( by type: FZCoreDataTypes ) -> Any {
		switch type {
		case let .string( string ):		return string
		case let .int( int ):			return int
		case let .bool( bool ):			return bool
		}
	}
}

public class FZCoreDataProxy {
	public var dataModelName: String?
	
	lazy var persistentContainer: NSPersistentContainer? = {
		guard dataModelName != nil else { return nil }
		let ccontainer = NSPersistentContainer( name: dataModelName! )
		ccontainer.loadPersistentStores { thing, error in
//			lo( thing, error )
			if error != nil { fatalError( " Core Data error: \( error! )" ) }
		}
		return ccontainer
	}()
	
	fileprivate let
	key_ring: FZKeyring,
	worn_closet: FZWornCloset
	
	fileprivate var _isActivated: Bool
	
	required public init () {
		_isActivated = false
		key_ring = FZKeyring()
		worn_closet = FZWornCloset( key_ring.key )
	}
	
	deinit {}
}

