//
//  BT_UT_Time.swift
//  Boilerplate
//
//  Created by Richard Willis on 19/04/2016.
//  Copyright © 2016 EoID Ltd. All rights reserved.
//

import Foundation

public class FZTime {
	public enum IntervalFormats { case full, withoutHours, withoutMilliseconds, withoutHoursAndMilliseconds, withoutHoursAndMinutes }
	
	static fileprivate var _startTime: Date?
	
	// returns a timestamp based upon the IntervalFormats case passed 
	// (assumes full case if none passed)
	public static func getInterval ( format: IntervalFormats = .full ) -> String {
		let rawInterval = _getRawInterval()
		let interval = Int( rawInterval )
		
		switch format {
		case .withoutHours:
			return String(
				format: "%0.2d:%0.2d.%0.2d",
				_getMinutesBy( interval: interval ),
				_getSecondsBy( interval: interval ),
				_getMillisecondsBy( rawInterval: rawInterval ) )
			
		case .withoutMilliseconds:
			return String(
				format: "%0.2d:%0.2d:%0.2d",
				_getHoursBy( interval: interval ),
				_getMinutesBy( interval: interval ),
				_getSecondsBy( interval: interval ) )
			
		case .withoutHoursAndMinutes:
			return String(
				format: "%0.2d:%0.2d",
				_getSecondsBy( interval: interval ),
				_getMillisecondsBy( rawInterval: rawInterval ) )
			
		case .withoutHoursAndMilliseconds:
			return String(
				format: "%0.2d:%0.2d",
				_getMinutesBy( interval: interval ),
				_getSecondsBy( interval: interval ) )
			
		// included to catch case .full
		default:
			return String(
				format: "%0.2d:%0.2d:%0.2d.%0.2d",
				_getHoursBy( interval: interval ),
				_getMinutesBy( interval: interval ),
				_getSecondsBy( interval: interval ),
				_getMillisecondsBy( rawInterval: rawInterval ) )
		}
	}
	
	public static func getDateComponents ( from date: Date ) -> DateComponents? {
		let gregorian = Calendar( identifier: Calendar.Identifier.gregorian )
		let flags = NSCalendar.Unit.init( rawValue: UInt.max )
		return ( gregorian as NSCalendar ).components( flags, from: date )
	}
	
	// _startTime acts as "zero hour" so setting it to nil basically restarts the clock
	public static func resetInterval () { _startTime = nil }
	
	
	
	// hours and milliseconds have accessor functions because they aren't used in all cases
	static fileprivate func _getHoursBy ( interval: Int ) -> Int { return interval / 3600 }
	
	static fileprivate func _getMillisecondsBy ( rawInterval: TimeInterval ) -> Int {
		return Int( ( rawInterval.truncatingRemainder( dividingBy: 1 ) ) * 1000 )
	}
	
	static fileprivate func _getMinutesBy ( interval: Int ) -> Int { return ( interval / 60 ) % 60 }
	
	static fileprivate func _getSecondsBy ( interval: Int ) -> Int { return interval % 60 }
	
	
	// raw interval has its own accessor function as it *might* need to restart the _startTime clock
	static fileprivate func _getRawInterval () -> TimeInterval {
		if _startTime == nil { _startTime = Date() }
		return Date().timeIntervalSince( _startTime! )
	}
}
