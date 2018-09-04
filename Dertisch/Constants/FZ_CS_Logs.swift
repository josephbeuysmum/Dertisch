//
//  FZ_UT_LogConsts.swift
//  Dertisch
//
//  Created by Richard Willis on 03/06/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public struct FZLogConsts {
	// used by log functions to decide what to log or not
	public struct logLevel {
		static let
		output = 0,
		info = 1,
		feedback = 2,
		warning = 3,
		error = 4
	}
	
	// the current list of types of logs that should be written to the output window
	// add logLevel.feedback if you want signals output
	public static let logModes = [ logLevel.output, logLevel.info, logLevel.warning ]//, logLevel.feedback ]
}
