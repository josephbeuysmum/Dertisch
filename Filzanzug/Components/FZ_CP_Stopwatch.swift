//
//  FZ_CP_Stopwatch.swift
//  Filzanzug
//
//  Created by Richard Willis on 24/08/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import Foundation

public class FZStopwatch: FZStopwatchProtocol {
	public var identifier: String { return "FZStopwatch_\( key_ ).Complete" }
	public var signalBox: FZSignalsEntity
	
	fileprivate var
	key_: String,
	timer: Timer?,
	data: Any?
	
	
	
	public init () {
		key_ = NSUUID().uuidString
		signalBox = FZSignalsEntity()
	}
	
	
	
	// the delay tells us how long to wait
	public func startWith ( delay: Double, andEndWith callback: @escaping ( String, Any? ) -> Void ) {
		data = nil
		_startWith( delay: delay, andEndWith: callback )
	}
	
	// the delay tells us how long to wait, and the data can be transmited at the
	public func startWith (
		delay: Double,
		andData data: AnyObject,
		andEndWith callback: @escaping ( String, Any? ) -> Void ) {
		self.data = data
		_startWith( delay: delay, andEndWith: callback )
	}
	
	// stop the count before it ends itself
	public func stop () {
		signalBox.signals?.stopScanningFor( key: identifier, scanner: self )
		timer!.invalidate()
		timer = nil
		data = nil
	}
	
	
	
	fileprivate func _startWith ( delay: Double, andEndWith callback: @escaping ( String, Any? ) -> Void ) {
		// we set signals to scan to for the internal key, then set a timer for the given delay.
		// If the timer runs its course, we transmit said key, which calls the external callback,
		// and then immediately call stop() in _onTimerComplete() to tidy everything up.
		stop()
		signalBox.signals?.scanOnceFor( key: identifier, scanner: self, callback: callback )
		timer = Timer.scheduledTimer( withTimeInterval: TimeInterval( delay ), repeats: false ) {
			[ unowned self ] timer in
			self.signalBox.signals?.transmitSignal( by: self.identifier, with: self.data as! String )
			timer.invalidate()
			self.stop() }
	}
}
