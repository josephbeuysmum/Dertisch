//
//  FZ_UT_Math.swift
//  Filzanzug
//
//  Created by Richard Willis on 15/02/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class FZMath {
	static fileprivate var _primaryKey: Int32 = 0
	
	// gives your app an endless supply of unique Ints
	public static func getPrimaryKey () -> Int32 {
		_primaryKey += 1
		return _primaryKey
	}
	
	// returns a random Int between "start" and "end"
	public static func getRandomInt ( from start: Int32, to: Int32 ) -> Int32? {
		let end = to < Int32.max ? to : to - 1
		guard start < end else { return nil }
		return Int32( arc4random_uniform( UInt32( ( end + 1 ) - start ) ) ) + start
	}
	
	public static func roundDouble ( _ double: Double, toNumberOfPlaces places: Int ) -> Double {
		let rounding = pow( 10.0, Double( places ) )
//		roundedDouble = round( double * rounding ) / rounding
//		lo(roundedDouble)
		return round( double * rounding ) / rounding
	}
}
