//
//  fz_EX_UILabel.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension UILabel {
	// simply makes UILabels sizeToFit()-able
	func makeWrappable () {
		numberOfLines = 0
		lineBreakMode = .byWordWrapping
	}
}
