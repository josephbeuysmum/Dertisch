//
//  HasenblutTests.swift
//  HasenblutTests
//
//  Created by Richard Willis on 02/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

@testable import Filzanzug
import XCTest

class FZSignalsServiceTests: XCTestCase {
	var signals: FZSignalsService!
	
	override func setUp () {
		super.setUp()
		signals = FZSignalsService()
	}
	
	override func tearDown () {
		super.tearDown()
		signals = nil
	}
	
	func testAnnulSignal () {
		let key = "annulSignalKey"
		XCTAssertFalse( signals.hasSignalFor( key: key ) )
		signals.scanFor( key: key, scanner: self ) { _,_ in }
		signals.annulSignalFor( key: key, scanner: self )
		XCTAssertFalse( signals.hasSignalFor( key: key ) )
	}
	
	func testHasSignal () {
		let key = "hasSignalKey"
		XCTAssertFalse( signals.hasSignalFor( key: key ) )
		signals.scanFor( key: key, scanner: self ) { _,_ in }
		XCTAssertTrue( signals.hasSignalFor( key: key ) )
	}
	
	func testScanForRepeatingSignal () {
		let key = "repeatingSignalKey"
		var hasSignaled: Bool = false
		signals.scanFor( key: key, scanner: self ) {
			[ unowned self ] _,_ in
			if hasSignaled {
				XCTAssertTrue( true )
				return
			}
			hasSignaled = true
			self.signals.transmitSignalFor( key: key )
		}
		signals.transmitSignalFor( key: key )
	}
	
	func testScanForRepeatingSignals () {
		let keys = [ "firstRepeatingSignalKey", "secondRepeatingSignalKey" ]
		var countSignals = 0
		signals.scanFor( keys: keys, scanner: self ) {
			[ unowned self ] _,_ in
			countSignals += 1
			switch countSignals {
			case 5: 	XCTAssertTrue( false )
			case 2:		self.signals.transmitSignalFor( key: keys[ 0 ] )
						self.signals.transmitSignalFor( key: keys[ 1 ] )
			default:	()
			}
		}
		signals.transmitSignalFor( key: keys[ 0 ] )
		signals.transmitSignalFor( key: keys[ 1 ] )
	}
	
	func testScanForSingleSignal () {
		let key = "singleSignalKey"
		var hasSignaled: Bool = false
		signals.scanOnceFor( key: key, scanner: self ) {
			[ unowned self ] _,_ in
			if hasSignaled { XCTAssertTrue( false ) }
			hasSignaled = true
			self.signals.transmitSignalFor( key: key )
		}
		signals.transmitSignalFor( key: key )
	}
	
	func testStopSingleScan () {
		let key = "singleScanKey"
		signals.scanFor( key: key, scanner: self ) { _,_ in }
		XCTAssertTrue( signals.hasSignalFor( key: key ) )
		_ = signals.stopScanningFor( key: key, scanner: self )
		XCTAssertFalse( signals.hasSignalFor( key: key ) )
	}
}

