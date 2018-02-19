//
//  FZ_PT_CP_Stopwatch.swift
//  Filzanzug
//
//  Created by Richard Willis on 24/08/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

//import Foundation

public protocol FZStopwatchProtocol: FZSignalBoxEntityProtocol {
	func startWith (
		delay: Double,
		andEndWith block: @escaping ( String, Any? ) -> Void )
	func startWith (
		delay: Double,
		andData userInfo: AnyObject,
		andEndWith block: @escaping ( String, Any? ) -> Void )
	func stop ()
}
