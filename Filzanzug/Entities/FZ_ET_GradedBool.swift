//
//  FZ_ET_FZGradedBool.swift
//  Hasenblut
//
//  Created by Richard Willis on 17/11/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

// a FZGradedBool delivers a figure between 0.0 and 1.0 to indicate the degree of success in function calls that attempt multiple things
public struct FZGradedBool {
	public var value: Double { return _value }
	
	fileprivate let _value: Double
	
	init ( _ value: Double ) {
		guard 0.0...1.0 ~= value else { fatalError( "FZGradedBool value must be from 0.0 to 1.0" ) }
		_value = value
	}
}
