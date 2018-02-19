//
//  FZ_EX_Date.swift
//  Filzanzug
//
//  Created by Richard Willis on 14/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

extension Date {
	func years ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .year, from: date, to: self, options: [] ).year!
	}
	
	func months ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .month, from: date, to: self, options: [] ).month!
	}
	
	func weeks ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .weekOfYear, from: date, to: self, options: [] ).weekOfYear!
	}
	
	func days ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .day, from: date, to: self, options: [] ).day!
	}
	
	func hours ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .hour, from: date, to: self, options: [] ).hour!
	}
	
	func minutes ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .minute, from: date, to: self, options: [] ).minute!
	}
	
	func seconds ( from date: Date ) -> Int {
		return ( Calendar.current as NSCalendar ).components( .second, from: date, to: self, options: [] ).second!
	}
	
	func offset ( from date: Date ) -> String {
		if years ( from: date )   > 0 { return "\(years ( from: date ))y"   }
		if months ( from: date )  > 0 { return "\(months ( from: date ))M"  }
		if weeks ( from: date )   > 0 { return "\(weeks ( from: date ))w"   }
		if days ( from: date )  > 0 { return "\(days ( from: date ))d"  }
		if hours ( from: date )   > 0 { return "\(hours ( from: date ))h"   }
		if minutes ( from: date ) > 0 { return "\(minutes ( from: date ))m" }
		if seconds ( from: date ) > 0 { return "\(seconds ( from: date ))s" }
		return FZCharConsts.emptyString
	}
}
