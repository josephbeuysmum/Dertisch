//
//  FZCoreDataProxyTests.swift
//  FilzanzugTests
//
//  Created by Richard Willis on 22/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import XCTest
@testable import Filzanzug

class FZCoreDataProxyTests: XCTestCase {
	var signalsService: FZSignalsService!
	var coreDataProxy: FZCoreDataProxy!
	
	override func setUp () {
		super.setUp()
		signalsService = FZSignalsService()
		coreDataProxy = FZCoreDataProxy()
		coreDataProxy.dataModelName =  "FilzanzugTests"
		coreDataProxy.wornCloset.set( signals: signalsService )
	}
	
	override func tearDown () {
		super.tearDown()
		coreDataProxy.wornCloset.deallocate()
		coreDataProxy = nil
	}
	
	func testStoreEntities () {
		var entities = FZCoreDataEntity(
			name: "Cat",
			keys: [
				FZCoreDataKey( key: "name", type: FZCoreDataTypes.string( "" ) ),
				FZCoreDataKey( key: "isFavourite", type: FZCoreDataTypes.bool( true ) ) ] )
		entities.add( multipleAttributes: [
			[ FZCoreDataTypes.string( "Nursemaid" ), FZCoreDataTypes.bool( true ) ],
			[ FZCoreDataTypes.string( "Urik" ), FZCoreDataTypes.bool( false ) ],
			[ FZCoreDataTypes.string( "Feelings" ), FZCoreDataTypes.bool( true ) ],
			[ FZCoreDataTypes.string( "Vhom" ), FZCoreDataTypes.bool( false ) ],
			[ FZCoreDataTypes.string( "Erskin" ), FZCoreDataTypes.bool( false ) ],
			[ FZCoreDataTypes.string( "Plapp" ), FZCoreDataTypes.bool( false ) ] ] )
		coreDataProxy.store( entities: entities )
	}
}
