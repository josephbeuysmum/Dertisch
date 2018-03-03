//
//  FZ_PX_Image.swift
//  Filzanzug
//
//  Created by Richard Willis on 25/11/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

public class FZImageProxy: FZImageProxyProtocol {
	public var wornCloset: FZWornCloset

	fileprivate let _keyring: FZKeyring

	fileprivate var
	urlsResolving: [ String ],
	rawImages: Dictionary< String, Data >

	
	
	required public init () {
		_keyring = FZKeyring()
		wornCloset = FZWornCloset( _keyring.key )
		urlsResolving = []
		rawImages = [:]
	}
	
	deinit {}
	
	public func activate () {
//		_wornCloset.modelClassEntities?.getApiServiceBy( key: key )?.call(
//			url: "http://localhost:8080/api/average_number_of_followers",
//			method: FZUrlSessionService.methods.GET,
//			parameters: nil,
//			scanner: self ) {
//			[ unowned self ] key, data in lo( data )
//		}
	}
	
//	public func initialiseSignals () {
//		signalBox.signals?.scanFor( key: FZInjectionConsts.urlSession, scanner: self ) {
//			_, data in
//			lo(data)
//			guard data is FZUrlSessionService else { return }
//			self._wornCloset.getModelClassEntities( by: self._keyring.key )?.urlSession = data as? FZUrlSessionService
//		_ = Timer.scheduledTimer( withTimeInterval: TimeInterval( 0.5 ), repeats: false ) {
//			[ unowned self ] timer in
//			lo(timer)
//			_ = self.signalBox.signals.stopScanningFor( key: FZInjectionConsts.urlSession, scanner: self )
//			timer.invalidate() } }
//	}
	

	
	public func getImage ( by url: String, block:( ( String, Any? ) -> Void )? = nil ) -> UIImage? {
		let image = getLocalImage( by: url )
		guard image == nil else { return image }
		guard
			block != nil,
			let scopedSignals = wornCloset.getSignals( by: _keyring.key )
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
			let scopedUrlSession = wornCloset.getModelClassEntities( by: _keyring.key )?.urlSession,
			let scopedSignals = wornCloset.getSignals( by: _keyring.key )
			else { return }
		_ = scopedSignals.scanOnceFor( key: url, scanner: self ) {
			[ unowned self ] _, data in
			if let urlIndex = self.urlsResolving.index( of: url ) { self.urlsResolving.remove( at: urlIndex ) }
			guard self.assess( result: data ) else { return }
			let result = data as! FZApiResult
			self.rawImages[ url ] = result.data as? Data
			scopedSignals.transmitSignalFor( key: self.getUrlKey( by: url ), data: result )
		}
		scopedUrlSession.call( url: url, method: FZUrlSessionService.methods.GET )
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
	
	fileprivate func getUrlKey ( by url: String ) -> String { return "\( _keyring.key )_\( url )" }
}
