 //
//  FZ_SVsignals_.swift
//  Filzanzug
//
//  Created by Richard Willis on 11/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

//import Signals

extension FZSignalsService: FZSignalsServiceProtocol {
	public typealias FZSignalCallback = ( String, Any? ) -> Void
	
	// removes a signal
	public func annulSignal ( by key: String, scanner: AnyObject ) {
		_annulSignal( by: key )
	}
	
	public func hasSignal ( for key: String ) -> Bool { return signals_[ key ] != nil }
	
	// can be called from without to check current list of signals and scanners
//	public func logSignatures () {
//		var output = "CURRENT SIGNATURES:"
//		for ( _, signatures ) in signatures_ {
//			_ = signatures.map { signature in output = "\( output ) \( signature.description )" }
//		}
//	}
	
	// adds a scanner
	@discardableResult
	public func scanFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback ) -> Bool {
		return _scanFor( key: key, scanner: scanner, scanContinuously: true, callback: callback )
	}
	
	// adds many scanners
//	@discardableResult
//	public func scanFor (
//		keys: [ String ],
//		scanner: AnyObject,
//		callback: @escaping ( String ) -> Void
//		) -> FZGradedBool {
//		let len = keys.count
//		var successes = 0.0
//		_ = keys.map { key in
//			if !_scanFor( key: key, scanner: scanner, scanContinuously: true, callback: callback ) { successes += 1 }
//		}
//		// FZGradedBool allows us to show what percent of additions were successful
//		return FZGradedBool( successes / Double( len ) )
//	}
	
	// adds a scanner once
	@discardableResult
	public func scanOnceFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		callback: @escaping FZSignalCallback
		) -> Bool {
		return _scanFor( key: key, scanner: scanner, scanContinuously: false, callback: callback )
	}
	
	// removes a scanner
	public func stopScanningFor ( key: String, scanner: AnyObject ) {
//		guard !hasSignal( for: key ) else { return }
//		guard signals_[ key ] != nil else { return false }
		_annulSignal( by: key )
	}
	
	// removes multiple scanners
//	public func stopScanningFor ( keys: [ String ], scanner: AnyObject ) -> FZGradedBool {
//		var successes = 0.0
//		_ = keys.map { key in if _stopScanningFor( key: key, scanner: scanner ) { successes += 1 } }
//		// FZGradedBool allows us to show what percent of additions were successful
//		return FZGradedBool( successes / Double( keys.count ) )
//	}
	
	// transmits a signal
	public func transmitSignal ( by key: String, with value: Any? = nil ) {
		signals_[ key ]?.transmit( with: value )
	}
	
	
	
	// create a scanning relationship
	fileprivate func _scanFor (
		key: String,
		scanner: FZSignalReceivableProtocol,
		scanContinuously: Bool,
		callback: @escaping FZSignalCallback
		) -> Bool {
//		guard !_scannerExistsFor( key: key, scanner: scanner ) else { return false }
		_createSignalIfNecessary( by: key )
		return signals_[ key ]!.add( scanner, scansContinuously: scanContinuously, callback: callback )
//		return true
		
//		if var signal = _getSignalBy( key: key, createIfMissing: true ) as FZSignal? {
//			let signature = FZSignalWaveform(
//				key: key,
//				scanner: scanner,
//				scansContinuously: scanContinuously )
			
			// register the scanner to the signal
//			if signatures_[ key ] == nil { signatures_[ key ] = [ FZSignalWaveform ]() }
//			signatures_[ key ]!.append( signature )
			
			// then scan
//			if scanContinuously {
//				_ = signal.add( scanner, callback: callback, scansContinuously: scanContinuously )
//			} else {
//				// _onOneOffSignalFired scans to annul single-firing scanners and signals
//				signal.subscribeOnce(
//					with: scanner,
//					callback: {
//						[ unowned self ] key, _ in
//						guard let scopedSignatures = self.signatures_[ key ] else { return }
//						//							let len = scopedSignatures.count as Int?
//						//						var scopedSignature: FZSignalWaveform
//
//						// loop through all scopedSignatures
//						_ = scopedSignatures.map {
//							scopedSignature in
//							// if we found the one to annul, then do so
//							if scopedSignature.scansContinuously == false && scopedSignature.key == key {
//								// this is a bit hacky: signals take maybe 0.01 secs to fire, so we have to delay the removal of their scanners for at least this length of time so that they still have time to scan before being annulled
//								DispatchQueue.main.asyncAfter(
//									deadline: DispatchTime.now() + 0.1,
//									execute: {
//										loFeedback( "REMOVING ONE-OFF LISTENER key: \( key ) scanner: \( scopedSignature.scanner )" )
//										_ = self._stopScanningFor( key: key, scanner: scopedSignature.scanner )
//								} )
//							}
//						} } )
//				signal.subscribeOnce( with: scanner, callback: callback )
//			}
//			success = true
//		}
//		loFeedback( "ADD LISTENER key: \( key ) scanner: \( String( describing: FZString.simplify( description: scanner.description ) ) ) signals:  \( _getFZSignalWaveformsDescription() )" )
//
//		return success
	}
	
	// if nothing is left scanning to this signal, it might as well be deleted
	fileprivate func _annulEmpty ( signal: FZSignal, key: String, scanner: AnyObject ) {
//		loFeedback( "ANNUL EMPTY key: \( key ) signals: \( _getFZSignalWaveformsDescription() )" )
		guard !signal.hasScanners else { return }
		_annulSignal( by: key )
	}
	
	// annuls a signal
	fileprivate func _annulSignal ( by key: String ) {
		guard hasSignal( for: key ) else { return }
		signals_[ key ]!.removeAllScanners()
		signals_.removeValue( forKey: key )
//		signatures_.removeValue( forKey: key )
	}
	
	// returns a signal by a key; creates the signal if it's missing
	fileprivate func _createSignalIfNecessary ( by key: String ) {
		guard !hasSignal( for: key ) else { return }
		signals_[ key ] = FZSignal( key )
	}
	
	// logging function
//	fileprivate func _getFZSignalWaveformsDescription () -> String {
//		var signaturesDescription = FZCharConsts.emptyString
//		for ( key, _ ) in signals_ { signaturesDescription = "\( signaturesDescription )\n^                           \( key )" }
//		return signaturesDescription
//	}
	
	// checks for existence of a scanner
//	fileprivate func _scannerExistsFor ( key: String, scanner: AnyObject ) -> Bool {
//		guard
//			let scanners = signatures_[ key ] as [ FZSignalWaveform ]?,
//			let countScanners = scanners.count as Int?
//			else { return false }
//		for i in 0..<countScanners { if scanners[ i ].scanner === scanner { return true } }
//		return false
//	}
	
//	fileprivate func _stopScanningFor ( key: String, scanner: AnyObject ) {
//		guard signals_[ key ] != nil else { return false }
//		_annulSignal( by: key )
//		signals_[ key ]!.removeAllScanners()
		
		// stop scanning
//		signal.clearLastData()
//		signal.cancelSubscription( for: scanner )
		
		// if nothing is left scanning to this signal, we might as well delete it
//		_annulEmpty( signal: signal, key: key, scanner: scanner )
		
//		if let scopedSignatures = signatures_[ key ] {
//			let countScopedSignatures = scopedSignatures.count
//			var scopedSignature: FZSignalWaveform
//			for i in 0..<countScopedSignatures {
//				scopedSignature = scopedSignatures[ i ]
//
//				// any signature with the signal's key that belongs to the calling object can also be deleted
//				if  scopedSignature.key == key,
//					scopedSignature.scanner === scanner {
//					signatures_[ key ]!.remove( at: i )
//					break
//				}
//			}
//		}
//		loFeedback( "ANNUL LISTENER key: \( key ) scanner: \( String( describing: FZString.simplify( description: scanner.description ) ) ) signals: \( _getFZSignalWaveformsDescription() )" )
//		return true
//	}
	
//	fileprivate func _transmitSignalFor ( key: String, data: Any? = nil ) {
//		guard let signal = _getSignalBy( key: key, createIfMissing: false ) as FZSignal? else {
//			loFeedback( "no signal for: \( key )" )
//			return
//		}
//		loFeedback( "TRANSMITTING key: \( key )" )
////		signal => ( key, data: data )
//		//		if _logs { _log() }
//	}
}

public class FZSignalsService {
	// signals_ are the actual signals, whilst signatures_ are references to the classes that observer them
	// a signal may have many signatures, but a signature only has one signal
	fileprivate var
	signals_: Dictionary < String, FZSignal >
//	, signatures_: Dictionary < String, [ FZSignalWaveform ] >
	
	required public init () {
		signals_ = Dictionary < String, FZSignal >()
//		signatures_ = Dictionary < String, [ FZSignalWaveform ] >()
		lo()
	}
	
	deinit {}
}
