//
//  DT_UT_SignalConsts.swift
//  Dertisch
//
//  Created by Richard Willis on 03/06/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public struct DTOrderConsts {
	fileprivate static let
	name_space = "DTOrders.",
	navigate_ = "navigate",
	waiter_ = "Waiter",
	value_ = "value"

	// the [only] specific signal names used by DT classes
	public static let
	navigateTo = "\(name_space)NavigateTo",
	popoverAdded = "\(name_space)Popover\(DTCommonPhrasesConsts.Added)",
	popoverRemoved = "\(name_space)Popover\(DTCommonPhrasesConsts.Removed)",
	waiterActivated = "\(name_space)\(waiter_)\(DTCommonPhrasesConsts.Activated)",
	valuesRemoved = "\(name_space)\(value_)s\(DTCommonPhrasesConsts.Removed)",
	valueSet = "\(name_space)\(value_)\(DTCommonPhrasesConsts.Set)",
	valueStored = "\(name_space)\(value_)\(DTCommonPhrasesConsts.Stored)",
	viewAppeared = "\(name_space)\(DTCommonPhrasesConsts.View )Appeared",
	viewLoaded = "\(name_space)\(DTCommonPhrasesConsts.View )\(DTCommonPhrasesConsts.Loaded)",
	viewRemoved = "\(name_space)\(DTCommonPhrasesConsts.View )\(DTCommonPhrasesConsts.Removed)",
	viewWarnedAboutMemory = "\(name_space)\(DTCommonPhrasesConsts.View )WarnedAboutMemory"
//	viewSet = "\(name_space)\(DTCommonPhrasesConsts.View )\(DTCommonPhrasesConsts.Set )"
	
	internal static let
	waiterUpdated = "\(name_space)\(waiter_)\(DTCommonPhrasesConsts.Updated)"
}
