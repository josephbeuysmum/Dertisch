//
//  FZImageProxy.swift
//  Boilerplate
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

public class FZImageProxy: FZImageProxyProtocol {
	public var className: String { return FZClassConsts.image }
	public var signalBox: FZSignalsEntity!
	public var entities: FZModelClassEntities!

	fileprivate let key: String
	
	fileprivate var
	urlsResolving: [ String ],
	rawImages: Dictionary< String, Data >

	
	
	init () {
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity( key )
		entities = FZModelClassEntities( key )
		urlsResolving = []
		rawImages = [:]
	}
	
	deinit {}
	
	public func activate () {
//		entities.getApiServiceBy( key: key )?.call(
//			url: "http://localhost:8080/api/average_number_of_followers",
//			method: FZUrlSessionService.methods.GET,
//			parameters: nil,
//			scanner: self ) {
//			[ unowned self ] key, data in lo( data )
//		}
	}
	
	
	
	public func getImage ( by url: String, block:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard
			block != nil,
			let scopedSignals = signalBox.getSignalsServiceBy( key: key )
			else { return nil }
		let urlKey = getUrlKey( by: url )
		scopedSignals.scanOnceFor( key: urlKey, scanner: self ) {
			[ unowned self ] _, data in
			guard self.assess( result: data ) else { return }
			block!( url, self.getLocalImage( by: url ) )
		}
		loadImage( by: url )
		return nil
	}
	
	public func loadImage ( by url: String ) {
		guard
			let scopedSignals = signalBox.getSignalsServiceBy( key: key ),
			let scopedApi = entities.getApiServiceBy( key: key )
			else { return }
		scopedSignals.scanOnceFor( key: url, scanner: self ) {
			[ unowned self ] _, data in
			if let urlIndex = self.urlsResolving.index( of: url ) { self.urlsResolving.remove( at: urlIndex ) }
			guard self.assess( result: data ) else { return }
			let result = data as! FZApiResult
			self.rawImages[ url ] = result.data as? Data
			scopedSignals.transmitSignalFor( key: self.getUrlKey( by: url ), data: result )
		}
		scopedApi.call( url: url, method: FZUrlSessionService.methods.GET )
	}
	
	
	
	fileprivate func assess ( result: Any? ) -> Bool {
		guard
			let result = result as? FZApiResult,
			let success = result.success,
			success,
			result.data is Data
			else { return false }
		return true
	}
	
	fileprivate func getLocalImage ( by url: String ) -> UIImage? {
		return rawImages[ url ] != nil ? UIImage( data: rawImages[ url ]! ) : nil
	}
	
	fileprivate func getUrlKey ( by url: String ) -> String { return "\( key )_\( url )" }
}
