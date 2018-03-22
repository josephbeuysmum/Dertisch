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
	var imageProxy: FZImageProxy!
	var signalsService: FZSignalsService!
	var getImageExpectation: XCTestExpectation!
	var loadImageExpectation: XCTestExpectation!

    override func setUp () {
        super.setUp()
		imageProxy = FZImageProxy()
		signalsService = FZSignalsService()
		let urlSessionService = FZUrlSessionService()
		urlSessionService.wornCloset.set( signals: signalsService )
		let entities = FZModelClassEntities()
		entities.set( urlSession: urlSessionService )
		imageProxy.wornCloset.set( signals: signalsService )
		imageProxy.wornCloset.set( entities: entities )
    }
	
    override func tearDown () {
        super.tearDown()
		imageProxy.wornCloset.deallocate()
		imageProxy = nil
		getImageExpectation = nil
    }
	
    func testGetImage () {
		let url = "https://cdn0.iconfinder.com/data/icons/feather/96/clock-512.png"
		getImageExpectation = expectation( description: "getImage" )
		_ = imageProxy.getImage( by: url ) {
			[ unowned self ] _, data in
			if  data is UIImage,
				let _ = self.imageProxy.getImage( by: url ) {
				self.getImageExpectation.fulfill()
			}
		}
		wait( for: [ getImageExpectation ], timeout: 4 )
    }
	
	func testLoadImage () {
		let url = "http://www.photosinbox.com/download/clock-icon.jpg"
		loadImageExpectation = expectation( description: "loadImage" )
		signalsService.scanOnceFor( key: url, scanner: self ) {
			[ unowned self ] _, data in
			if  let result = data as? FZApiResult,
				result.success == true {
				self.loadImageExpectation.fulfill() } }
		imageProxy.loadImage( by: url )
		wait( for: [ loadImageExpectation ], timeout: 4 )
	}
}

