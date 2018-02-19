//
//  FZ_EX_UIColor.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension UIColor {
	// allows creating colors from simple hex strings
	public convenience init? ( hexString: String ) {
		let red, green, blue, alpha: CGFloat
		
		if hexString.hasPrefix( "#" ) {
			let start = hexString.index( hexString.startIndex, offsetBy: 1 )
			let hexColor = String( hexString.suffix( from: start ) )
			//hexString.substring( from: start )
			
			if hexColor.count == 8 {
				let scanner = Scanner( string: hexColor )
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64( &hexNumber ) {
					red = CGFloat( ( hexNumber & 0xff000000 ) >> 24 ) / 255
					green = CGFloat( ( hexNumber & 0x00ff0000 ) >> 16 ) / 255
					blue = CGFloat( ( hexNumber & 0x0000ff00 ) >> 8 ) / 255
					alpha = CGFloat( hexNumber & 0x000000ff ) / 255
					
					self.init( red: red, green: green, blue: blue, alpha: alpha )
					return
				}
			}
		}
		return nil
	}
}
