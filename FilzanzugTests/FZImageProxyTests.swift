//
//  ImageProxyTests.swift
//  HasenblutTests
//
//  Created by Richard Willis on 04/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import XCTest
@testable import Filzanzug

class FZImageProxyTests: XCTestCase {
	var image: FZImageProxy!
	var getImageExpectation: XCTestExpectation!

    override func setUp () {
        super.setUp()
		image = FZImageProxy()
		let sigs = FZSignalsService()
		image.signalBox.delegate = image
		image.signalBox.signals = sigs
		sigs.transmitSignalFor( key: FZInjectionConsts.urlSession, data: FZUrlSessionService() )
    }
	
    override func tearDown () {
        super.tearDown()
//		image.signalBox.deallocate()
		image = nil
		getImageExpectation = nil
    }
	
    func testGetImage () {
		lo()
		getImageExpectation = expectation( description: "getImage" )
		_ = image.getImage( by: "https://cdn0.iconfinder.com/data/icons/feather/96/clock-512.png" ) {
			[ unowned self ] _,_ in
			self.getImageExpectation.fulfill()
		}
		wait( for: [ getImageExpectation ], timeout: 10 )
    }
}

