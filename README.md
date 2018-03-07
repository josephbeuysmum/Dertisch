Filzanzug
=========

A lightweight VIPER framework for Swift apps
--------------------------------------------

Filzanzug is lightweight VIPER framework for Swift built using a 'write once, read never', or **WORN** dependency injection system, meaning properties are injected once and not publicly accessible thereafter.

Filzanzug Interactors, Presenters, and Model Classes each have a fileprivate **_wornCloset** property that grants access to singleton-with-a-small-s proxies and services, including the **FZSignalsService**, which is used to transmit and receive events throughout implementing apps.

Filzanzug is specifically structured with the goal of **minimising code resuse**, which simultaneously taking advantage of the **Protocol Orientated** nature of Swift. It is designed to provide the functionality common to most apps, which specifically (at present) means:

-   API calls
-   Management of external images
-   Simplified access to Core Data

Filzanzug interactors work by implementing the *FZInteractorProtocol* protocol; presenters by implementing the *FZPresenterProtocol* protocol; and viewControllers by subclassing *FZViewController*. It uses the **dependency injection** framework [Swinject](https://github.com/Swinject/Swinject) to register Interactor/Presenter/ViewController relationships at start-up.

Using Filzanzug
---------------

A basic, boilerplate Filzanzug Interactor looks like this:

	import Filzanzug
	
	extension SomeInteractor: FZInteractorProtocol {
		var wornCloset: FZWornCloset { get { return _wornCloset } set {} }
	
		func postPresenterActivated () {}
	}
	
	struct SomeInteractor {
		fileprivate let _keyring: FZKeyring
		fileprivate let _wornCloset: FZWornCloset
		fileprivate var _presenter: SomePresenter? {
			return wornCloset.getInteractorEntities( by: _keyring.key )?.presenter as? SomePresenter
		}
	
		init () {
			_keyring = FZKeyring()
			_wornCloset = FZWornCloset( _keyring.key )
		}
	}

A basic, boilerplate Filzanzug Presenter looks like this:

	import Filzanzug

	extension SomePresenter: FZPresenterProtocol {
		var wornCloset: FZWornCloset { get { return _wornCloset } set {} }
		
		func postViewActivated () {}
		
		func show ( pageName: String ) { }
	}

	struct SomePresenter {
		fileprivate let _keyring: FZKeyring
		fileprivate let _wornCloset: FZWornCloset
		fileprivate var _viewController: SomeViewController? {
			return wornCloset.getPresenterEntities( by: _keyring.key )?.viewController as? SomeViewController
		}
		
		init () {
			_keyring = FZKeyring()
			_wornCloset = FZWornCloset( _keyring.key )
		}
	}

And a basic, boilerplate Filzanzug ViewController looks like this:

	import Filzanzug
	
	class SomeViewController: FZViewController {}`

Extend `SwinjectStoryboard` to register your Interactor/Presenter/ViewController relationships:

`	
	import Filzanzug
	import SwinjectStoryboard

	extension SwinjectStoryboard {
		@objc class func postSetup () {
			var viewController: FZViewController?
			let signals: FZSignalsService = defaultContainer.resolve( FZSignalsService.self )!
			defaultContainer.storyboardInitCompleted( SomeViewController.self ) {
				resolvable, instance in
				viewController = instance
				instance.signalBox.signals = signals
				_ = resolvable.resolve( SomeInteractor.self )! }
			defaultContainer.register( SomePresenter.self ) {
				resolvable in SomePresenter()
				}.inObjectScope( .container ).initCompleted( {
					resolvable, instance in
					instance.signalBox.signals = signals
					signals.transmitSignalFor( key: FZInjectionConsts.routing, data: resolvable.resolve( FZRoutingService.self )! )
					signals.transmitSignalFor( key: FZInjectionConsts.viewController, data: viewController )
					viewController = nil
					instance.activate() } )
			defaultContainer.register( SomeInteractor.self ) {
				resolvable in SomeInteractor()
				}.inObjectScope( .transient ).initCompleted( {
					resolvable, instance in
					instance.signalBox.signals = signals
					signals.transmitSignalFor( key: FZInjectionConsts.image, data: resolvable.resolve( FZImageProxy.self )! )
					signals.transmitSignalFor( key: FZInjectionConsts.presenter, data: resolvable.resolve( SomePresenter.self )! )
					instance.activate() } )
		}
	}

An example repo will follow this brief, introductory documentation.
