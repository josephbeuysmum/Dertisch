//
//  FZ_ET_TimePeriod.swift
//  Filzanzug
//
//  Created by Richard Willis on 16/05/2017.
//  Copyright © 2017 Rich Text Format Ltd. All rights reserved.

import Foundation

extension FZTimePeriod: FZDescribableProtocol {
	public var description: String { return _getDescription(simplified: false, andTranslate: true) }
	public var numericDescription: String { return _getDescription(simplified: false, andTranslate: false) }
	public var simplifiedDescription: String { return _getDescription(simplified: true, andTranslate: true) }
	public var simplifiedNumericDescription: String { return _getDescription(simplified: true, andTranslate: false) }
	
	public var daysTotal: Int { return _secondsTotal / 86400 }
	public var hoursRemainder: Int { return hoursTotal % 24 }
	public var hoursTotal: Int { return _secondsTotal / 3600 }
	public var minutesRemainder: Int { return minutesTotal % 60 }
	public var minutesTotal: Int { return _secondsTotal / 60 }
	public var secondsRemainder: Int { return _secondsTotal % 60 }
	public var secondsTotal: Int { return _secondsTotal }
	
	
	
	fileprivate func _getDescription(simplified: Bool, andTranslate translate: Bool) -> String {
		var serialisations: [ String] = []
		if let days = _serialise(metric: "day", by: daysTotal, andTranslate: translate) { serialisations.append(days) }
		if let hours = _serialise(metric: "hour", by: hoursRemainder, andTranslate: translate) { serialisations.append(hours) }
		if  (!simplified || (simplified && serialisations.count < 2)),
			let minutes = _serialise(metric: "minute", by: minutesRemainder, andTranslate: translate) {
			serialisations.append(minutes)
		}
		if  (!simplified || (simplified && serialisations.count < 2)),
			let seconds = _serialise(metric: "second", by: secondsRemainder, andTranslate: translate) {
			serialisations.append(seconds)
		}
		
		let countMetrics = serialisations.count
		switch countMetrics {
		case 0:		return ""
		case 1:		return serialisations[ 0 ]
		
		default:
			var
			conjuction = "",
			value = ""
			for i in 0..<countMetrics {
				conjuction = i + 1 < countMetrics ? "" : "and "
				value = "\(value)\(conjuction)\(serialisations[i])"
				// avoid oxford comma
				if i + 2 < countMetrics { value = "\(value)," }
				// add space
				if i + 1 < countMetrics { value = "\(value) " }
			}
			return value
		}
	}
	
	fileprivate func _serialise(metric: String, by value: Int, andTranslate translate: Bool) -> String? {
		guard value > 0 else { return nil }
		let serialisedValue = translate ? FZString.translate(intToText: value) : "\(value)"
		let serialisedMetric = "\(String(describing: serialisedValue)) \(metric)"
		return value == 1 ? serialisedMetric : "\(serialisedMetric)s"
	}
}

struct FZTimePeriod {
	fileprivate var _secondsTotal: Int
	
	public init(interval: TimeInterval) {
		_secondsTotal = Int(interval)
	}
	
	public init (interval: Int) {
		_secondsTotal = interval
	}
}
