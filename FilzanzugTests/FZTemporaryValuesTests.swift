//
//  FZTemporaryValuesTests.swift
//  FilzanzugTests
//
//  Created by Richard Willis on 22/03/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

@testable import Filzanzug
import XCTest

class FZTemporaryValuesTests: XCTestCase {
	var temporaryValues: FZTemporaryValuesProxy!
	
    override func setUp () {
        super.setUp()
		temporaryValues = FZTemporaryValuesProxy()
		temporaryValues.wornCloset.set( signals: FZSignalsService() )
    }
    
    override func tearDown () {
        super.tearDown()
		temporaryValues.deallocate()
		temporaryValues = nil
    }

	func testAnnulValue () {
		let
		key = "testAnnulValueKey",
		value = "testAnnulValueValue"
		temporaryValues.set( value: value, by: key )
		temporaryValues.annulValue( by: key )
		XCTAssertNil( temporaryValues.getValue( by: key ) )
	}
	
    func testGetNilValue () {
		XCTAssertNil( temporaryValues.getValue( by: "someNonExistantValue" ) )
    }
	
	func testGetValue () {
		let
		key = "testGetValueKey",
		value = "testGetValueValue"
		temporaryValues.set( value: value, by: key )
		XCTAssertTrue( temporaryValues.getValue( by: key ) == value )
	}
	
	func testRemoveValues () {
		let
		key1 = "testRemoveValuesKey1",
		key2 = "testRemoveValuesKey2",
		value1 = "testRemoveValuesValue1",
		value2 = "testRemoveValuesValue2"
		temporaryValues.set( value: value1, by: key1 )
		temporaryValues.set( value: value2, by: key2 )
		temporaryValues.removeValues()
		XCTAssertTrue( temporaryValues.getValue( by: key1 ) == nil && temporaryValues.getValue( by: key2 ) == nil )
	}
}
