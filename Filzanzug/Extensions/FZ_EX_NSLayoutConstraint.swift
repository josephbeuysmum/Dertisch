//
//  FZ_EX_NSLayoutConstraint.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension NSLayoutConstraint {
	// useAndActivate allows us to forget about the hell that is translatesAutoresizingMaskIntoConstraints
	public class func useAndActivate ( constraints: [ NSLayoutConstraint ] ) {
		for constraint in constraints {
			if let view = constraint.firstItem as? UIView {
				view.translatesAutoresizingMaskIntoConstraints = false
			}
		}
		activate( constraints )
	}
}
