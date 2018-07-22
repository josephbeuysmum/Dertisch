//
//  FZ_UT_Colors.swift
//  Filzanzug
//
//  Created by Richard Willis on 28/09/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

import UIKit

public class FZColors {
	// tints a view's background color
	public static func color (views: [UIView], With color: UIColor) {
		_ = views.map { view in view.backgroundColor = color }
	}
	
	// converts a hex string to a UIColor
	public static func getColorBy (hex: String) -> UIColor? {
		let permittedChars = "0123456789ABCDEF"
		for char in hex.uppercased() {
			if permittedChars.index(of: char) == nil {
				return nil
			}
		}
		let adjustedHex: String?
		switch hex.count {
		case 6:		adjustedHex = "\(hex)FF"
		case 8:		adjustedHex = "\(hex)"
		default:	adjustedHex = nil
		}
		guard adjustedHex != nil else { return nil }
		return UIColor(hex: "#\(adjustedHex!)")
	}
	
	// gives the all passed views a transparent background
	public static func transparentize (views: [UIView]) {
		color(views: views, With: UIColor.clear)//( white: 0, alpha: 0 ) )
	}
	
	// gives the all passed views a white background
	public static func whiten (views: [UIView]) {
		color(views: views, With: UIColor.white)
	}
}
