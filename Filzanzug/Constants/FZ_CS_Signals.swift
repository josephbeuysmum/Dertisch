//
//  FZ_UT_SignalConsts.swift
//  Filzanzug
//
//  Created by Richard Willis on 03/06/2016.
//  Copyright © 2016 Rich Text Format Ltd. All rights reserved.
//

public struct FZSignalConsts {
	fileprivate static let
	_namespace =				"FZSignals."
	
	// the [only] specific signal names used by FZ classes
	public static let
//	interactorActivated = "\( _namespace )Interactor\( FZCommonPhrasesConsts.Activated )",
//	modelClassActivated = "\( _namespace )ModelClass\( FZCommonPhrasesConsts.Activated )",
	presenterActivated = "\( _namespace )Presenter\( FZCommonPhrasesConsts.Activated )",
	valuesRemoved = "\( _namespace )\( FZPrefixConsts.value )s\( FZCommonPhrasesConsts.Removed )",
	valueSet = "\( _namespace )\( FZPrefixConsts.value )\( FZCommonPhrasesConsts.Set )",
	valueStored = "\( _namespace )\( FZPrefixConsts.value )\( FZCommonPhrasesConsts.Stored )",
	viewLoaded = "\( _namespace )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Loaded )",
	viewRemoved = "\( _namespace )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Removed )"
//	viewSet = "\( _namespace )\( FZCommonPhrasesConsts.View )\( FZCommonPhrasesConsts.Set )"
}
