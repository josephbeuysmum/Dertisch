//
//  FZ_EX_NSObject.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension NSObject {
	// helps to identify classes by letting the wind out of their names
	var className: String? {
		guard
			let value = NSStringFromClass( type( of: self ) ).components( separatedBy: "." ).last
			else { return nil }
		return value
	}
}
