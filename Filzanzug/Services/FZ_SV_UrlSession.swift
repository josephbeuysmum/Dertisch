//
//  FZ_SV_API.swift
//  Filzanzug
//
//  Created by Richard Willis on 19/10/2015.
//  Copyright © 2015 Richard Willis. All rights reserved.
//

import UIKit

extension FZUrlSessionService: FZUrlSessionServiceProtocol {
	public enum methods: String { case GET = "GET", POST = "POST", DELETE = "DELETE" }
	
	public var wornCloset: FZWornCloset { return worn_closet }
	
	
	
	public func activate () {}
	
	public func call (
		url: String,
		method: FZUrlSessionService.methods,
		parameters: Dictionary< String, String >? = nil,
		scanner: FZSignalReceivableProtocol? = nil,
		callback: ( ( String, Any? ) -> Void )? = nil ) {
		//		lo( url )
		//		lo( method, parameters, scanner, callback )
		guard
			ongoing_calls.index( of: url ) == nil,
			let validUrl = URL( string: url )
			else { return }
		ongoing_calls.append( url )
		if scanner != nil && callback != nil {
			wornCloset.getSignals( by: key_ring.key )?.scanOnceFor( key: url, scanner: scanner!, callback: callback! )
		}
		var request = URLRequest( url: validUrl )
		request.httpMethod = method.rawValue
		// todo serialise json for POSTs here?
		
		_ = URLSession.shared.dataTask( with: request ) {
			[ unowned self ] data, response, error in
			guard error == nil else {
				lo( "todo ERROR to be handled here", url )
				return
			}
			guard data != nil else {
				lo( "todo NO DATA to be handled here" )
				return
			}
			// todo reintroduce stopwatch so hanging calls can be cancelled?
			if let callIndex = self.ongoing_calls.index( of: url ) { self.ongoing_calls.remove( at: callIndex ) }
			do {
				switch data!.mimeType {
				case Data.mimeTypes.RTF:		try self.cast( richText: data!, with: url )
				case Data.mimeTypes.BMP,
					 Data.mimeTypes.GIF,
					 Data.mimeTypes.JPG,
					 Data.mimeTypes.PNG:		try self.cast( image: data!, with: url )
				default: ()						// todo process other mime types here as and when required...
				}
			} catch {
				self.transmit( success: false, with: url )
			}
			}.resume()
	}
	
	
	
	// unadulterated transmission because FZImageProxy deals with post-processing
	fileprivate func cast ( image data: Data, with url: String ) throws {
		transmit( success: true, with: url, and: data )
	}
	
	fileprivate func cast ( richText data: Data, with url: String ) throws {
		do {
			guard let json = try JSONSerialization.jsonObject( with: data, options: [] ) as? [ String: Any ] else { return }
			//			let success = json[ FZKeyConsts.success ] is Bool ? json[ FZKeyConsts.success ] as? Bool : nil
			let castArray: [ Dictionary< String, Any > ]
			if let rawData = json[ "data" ] {
				castArray = ( rawData is NSArray ? ( rawData as! NSArray ) as? [ Dictionary< String, AnyObject > ] : nil )!
			} else {
				castArray = [ json ]
			}
			transmit( success: true, with: url, and: castArray[ 0 ] )
		} catch {
			transmit( success: false, with: url )
		}
	}
	
	
	
	fileprivate func transmit ( success: Bool, with url: String, and data: Any? = nil ) {
		wornCloset.getSignals( by: key_ring.key )?.transmitSignal(
			by: url,
			with: FZApiResult( success: success, url: url, data: data ) )
	}
}

public class FZUrlSessionService {
//	public var time_out: TimeInterval

	fileprivate let
	key_ring: FZKeyring,
	worn_closet: FZWornCloset
	
	fileprivate var ongoing_calls: [ String ]
	
	required public init () {
		key_ring = FZKeyring()
		worn_closet = FZWornCloset( key_ring.key )
//		time_out = 3.0
		ongoing_calls = []
		lo()
	}
	
	deinit {}
	
	
	
//	fileprivate func annulCallFor ( _ url: String ) {
//		guard let callIndex = ongoing_calls.index( of: url ), callIndex > -1 else { return }
//		ongoing_calls.remove( at: callIndex )
////		lo( "calls remaining:", ongoing_calls.count )
//	}
	
//	fileprivate func _call (
//		url: String,
//		method: FZUrlSessionService.methods,
//		parameters: Dictionary< String, String >? = nil ) {
//		guard
//			ongoing_calls.index( of: url ) == nil,
//			let scopedSignals = signalBox.getSignalsServiceBy( key: key ),
//			let validUrl = URL( string: url )
//			else { return }
//		ongoing_calls.append( url )
//		Alamofire.request(
//			url,
//			method: method,
//			parameters: parameters,
//			encoding: JSONEncoding.default
//		).responseJSON {
//			[ unowned self ] response in
//			let responseResult = response.result
//			let apiResult: FZApiResult
//
//			// did we get a result?
//			// yes: but success is still decided upon by the server
//			if  let metaData = responseResult.value as? NSDictionary,
//				let success = metaData[ FZKeyConsts.success ] as? Bool,
//				let rawData = metaData.object( forKey: FZKeyConsts.data ) {
//				// "castArray" - DB data, essentially - could be nil if the DB had none of the objects requested
//				let castArray: [ Dictionary< String, AnyObject > ]?
//
//				if let rawArray = rawData as? NSArray {
//					castArray = rawArray as? Array< Dictionary< String, AnyObject > >
//				} else {
//					castArray = nil
//				}
//
//				apiResult = FZApiResult(
//					success: success,
//					data: castArray,
//					message: metaData[ FZKeyConsts.message ] as? String,
//					url: metaData[ FZKeyConsts.url ] as? String )
//
//			// no: report the failure
//			} else {
//				apiResult = FZApiResult( success: false, data: nil, message: nil, url: nil )
//			}
//
//			// call is OVER: annul it!
//			self.annulCallFor( url )
//
//			// transmit (signals deals with annulment internally)
//			scopedSignals.transmitSignalFor( key: url, data: apiResult )
//		}
//	}
}
