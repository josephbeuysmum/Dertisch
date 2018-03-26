//
//  FZ_UT_SignalConsts.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/06/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public struct FZSignalConsts {
	fileprivate static let
	name_space = "FZSignals.",
	navigate_ = "navigate",
	value_ = "value"

	// the [only] specific signal names used by FZ classes
	public static let
//	interactorActivated = "\( name_space )Interactor\( FZCommonPhrasesConsts.Activated )",
//	modelClassActivated = "\( name_space )ModelClass\( FZCommonPhrasesConsts.Activated )",
	presenterActivated = "\( name_space )Presenter\( FZCommonPhrasesConsts.Activated )",
	valuesRemoved = "\( name_space )\( value_ )s\( FZCommonPhrasesConsts.Removed )",
	valueSet = "\( name_space )\( value_ )\( FZCommonPhrasesConsts.Set )",
	valueStored = "\( name_space )\( value_ )\( FZCommonPhrasesConsts.Stored )",
	viewLoaded = "\( name_space )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Loaded )",
	viewRemoved = "\( name_space )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Removed )"
//	viewSet = "\( name_space )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Set )"
}
