//
//  FZ_EX_SwinjectStoryboard.swift
//  Filzanzug
//
//  Created by Richard Willis on 18/02/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
	@objc class func postSetup () {}
	
	// herehere add assertions throughout (see https://andybargh.com/swift-assertions/)`
	
	@objc class func setup () {
		// signals first, and all classes depend on it
		defaultContainer.register( FZSignalsService.self ) { _ in FZSignalsService() }.inObjectScope( .container )
		
		// next all the model classes that only depend on signals
		// todo uh... this --v
//		defaultContainer.register( FZLocalAccessProxy.self ) {
//			_ in FZLocalAccessProxy()
//			}.inObjectScope( .container ).initCompleted( {
//				resolvable, instance in
//				instance.signals = resolvable.resolve( FZSignalsService.self )!
//				instance.activate() } )
		defaultContainer.register( FZRoutingService.self ) {
			_ in FZRoutingService()
			}.inObjectScope( .container ).initCompleted( {
				resolvable, instance in
				instance.signalBox.signals = resolvable.resolve( FZSignalsService.self )!
				instance.activate() } )
		defaultContainer.register( FZStopwatch.self ) {
			_ in FZStopwatch()
			}.inObjectScope( .transient ).initCompleted( {
				resolvable, instance in
				instance.signalBox.signals = resolvable.resolve( FZSignalsService.self )! } )
		defaultContainer.register( FZUrlSessionService.self ) {
			_ in FZUrlSessionService()
			}.inObjectScope( .container ).initCompleted( {
				resolvable, instance in
				instance.signalBox.signals = resolvable.resolve( FZSignalsService.self )!
				instance.activate() } )
		
		// finally image as it also needs URLSession
		defaultContainer.register( FZImageProxy.self ) {
			_ in FZImageProxy()
			}.inObjectScope( .container ).initCompleted( {
				resolvable, instance in
				let signals = defaultContainer.resolve( FZSignalsService.self )!
				instance.signalBox.signals = signals
				signals.transmitSignalFor( key: FZInjectionConsts.api, data: resolvable.resolve( FZUrlSessionService.self )! )
				instance.activate() } )
		
		// dead implementations of two UI management classes so as to silence unnecessary Swinject warnings
		defaultContainer.storyboardInitCompleted( UINavigationController.self ) { resolvable, instance in }
		defaultContainer.storyboardInitCompleted( UIPageViewController.self ) { resolvable, instance in }
		
		// calling postSetup then allows the user to create bespoke DI relationships for their IA-PS-VC combinations
		postSetup()
	}
}
