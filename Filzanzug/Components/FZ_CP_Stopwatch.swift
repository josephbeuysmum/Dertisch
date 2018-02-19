//
//  FZ_CP_Timer.swift
//  Hasenblut
//
//  Created by Richard Willis on 24/08/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public class FZStopwatch: FZStopwatchProtocol {
	public var identifier: String { return "FZStopwatch_\( key ).Complete" }
	public var signalBox: FZSignalsEntity!
	
	fileprivate var
	key: String,
	timer: Timer?,
	data: Any?
	
	
	
	init () {
		key = NSUUID().uuidString
		signalBox = FZSignalsEntity( key )
	}
	
	
	
	// the delay tells us how long to wait
	public func startWith ( delay: Double, andEndWith block: @escaping ( String, Any? ) -> Void ) {
		data = nil
		_startWith( delay: delay, andEndWith: block )
	}
	
	// the delay tells us how long to wait, and the data can be transmited at the
	public func startWith (
		delay: Double,
		andData data: AnyObject,
		andEndWith block: @escaping ( String, Any? ) -> Void ) {
		self.data = data
		_startWith( delay: delay, andEndWith: block )
	}
	
	// stop the count before it ends itself
	public func stop () {
		guard let signals = signalBox.getSignalsServiceBy( key: key ) else { return }
		let _ = signals.stopScanningFor( key: identifier, scanner: self )
		guard timer != nil else { return }
		timer!.invalidate()
		timer = nil
		data = nil
	}
	
	
	
	fileprivate func _startWith ( delay: Double, andEndWith block: @escaping ( String, Any? ) -> Void ) {
		// we set signals to scan to for the internal key, then set a timer for the given delay.
		// If the timer runs its course, we transmit said key, which calls the external callback,
		// and then immediately call stop() in _onTimerComplete() to tidy everything up.
		guard let signals = signalBox.getSignalsServiceBy( key: key ) else { return }
		stop()
		signals.scanOnceFor( key: identifier, scanner: self, block: block )
		timer = Timer.scheduledTimer(
			timeInterval: TimeInterval( delay ),
			target: self,
			selector: #selector( _onTimerComplete ),
			userInfo: nil,
			repeats: false )
	}
	
	
	
	@objc fileprivate func _onTimerComplete () {
		guard let signals = signalBox.getSignalsServiceBy( key: key ) else { return }
		signals.transmitSignalFor( key: identifier, data: data )
		stop()
	}
}
