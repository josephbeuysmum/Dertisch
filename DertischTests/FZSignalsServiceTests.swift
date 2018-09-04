//
//  HasenblutTests.swift
//  HasenblutTests
//
//  Created by Richard Willis on 02/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

@testable import Dertisch
import XCTest

class FZSignalsServiceTests: XCTestCase, FZSignalReceivableProtocol {
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
		XCTAssertFalse( signals.hasSignal( for: key ) )
		signals.scanFor( key: key, scanner: self ) { _,_ in }
		signals.annulSignal( by: key, scanner: self )
		XCTAssertFalse( signals.hasSignal( for: key ) )
	}
	
	func testHasSignal () {
		let key = "hasSignalKey"
		XCTAssertFalse( signals.hasSignal( for: key ) )
		signals.scanFor( key: key, scanner: self ) { _,_ in }
		XCTAssertTrue( signals.hasSignal( for: key ) )
	}
	
	func testScanForRepeatingSignal () {
		let key = "repeatingSignalKey"
		var hasSignaled: Bool = false
		signals.scanFor( key: key, scanner: self ) {
			[ unowned self ] _,_ in
			if hasSignaled {
				lo()
				XCTAssertTrue( true )
				return
			}
			hasSignaled = true
			self.signals.transmitSignal( by: key )
		}
		signals.transmitSignal( by: key )
	}
	
//	func testScanForRepeatingSignals () {
//		let keys = [ "firstRepeatingSignalKey", "secondRepeatingSignalKey" ]
//		var countSignals = 0
//		signals.scanFor( key: keys, scanner: self ) {
//			[ unowned self ] _,_ in
//			countSignals += 1
//			switch countSignals {
//			case 5: 	XCTAssertTrue( false )
//			case 2:		self.signals.transmitSignalFor( key: keys[ 0 ] )
//						self.signals.transmitSignalFor( key: keys[ 1 ] )
//			default:	()
//			}
//		}
//		signals.transmitSignal( by: keys[ 0 ] )
//		signals.transmitSignal( by: keys[ 1 ] )
//	}
	
//	func testScanForSingleSignal () {
//		let key = "singleSignalKey"
//		var hasSignaled: Bool = false
//		signals.scanOnceFor( key: key, scanner: self ) {
//			[ unowned self ] _,_ in
//			if hasSignaled { XCTAssertTrue( false ) }
//			hasSignaled = true
//			self.signals.transmitSignal( by: key )
//		}
//		signals.transmitSignal( by: key )
//	}
	
//	func testStopSingleScan () {
//		let key = "singleScanKey"
//		signals.scanFor( key: key, scanner: self ) { _,_ in }
//		XCTAssertTrue( signals.hasSignal( for: key ) )
//		_ = signals.stopScanningFor( key: key, scanner: self )
//		XCTAssertFalse( signals.hasSignal( for: key ) )
//	}
}

