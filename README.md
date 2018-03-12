Filzanzug
=========

A lightweight VIPER framework for Swift apps
--------------------------------------------

Filzanzug is lightweight VIPER framework for Swift built using a 'write once, read never', or **WORN** dependency injection system, meaning properties are injected once and not publicly accessible thereafter.

Filzanzug Interactors, Presenters, and Model Classes each have a fileprivate **worn_closet** property that grants access to singleton-with-a-small-s proxies and services, including the **FZSignalsService**, which is used to transmit and receive events throughout implementing apps.

Filzanzug is specifically structured with the goal of **minimising code resuse**, which simultaneously taking advantage of the **Protocol Orientated** nature of Swift. It is designed to provide the functionality common to most apps, which specifically (at present) means:

-   API calls;
-   management of external images;
-   simplified access to Core Data; and
-   the capacity to add custom proxies and services.

Filzanzug interactors work by implementing the *FZInteractorProtocol* protocol; presenters by implementing the *FZPresenterProtocol* protocol; and viewControllers by subclassing *FZViewController*. It uses the **dependency injection** framework [Swinject](https://github.com/Swinject/Swinject) to register Interactor/Presenter/ViewController relationships at start-up.

Using Filzanzug
---------------

A boilerplate Filzanzug Interactor looks like this:

	import Filzanzug

	struct SomeInteractor: FZInteractorProtocol {
		var wornCloset: FZWornCloset { get { return worn_closet } set {} }

		fileprivate let keyring_: FZKeyring
		fileprivate let worn_closet: FZWornCloset
		fileprivate var _presenter: SomePresenter? {
			return wornCloset.getInteractorEntities( by: keyring_.key )?.presenter as? SomePresenter
		}

		init () {
			keyring_ = FZKeyring()
			worn_closet = FZWornCloset( keyring_.key )
		}

		func postPresenterActivated () {}
	}

A boilerplate Filzanzug Presenter looks like this:

	import Filzanzug

	struct SomePresenter: FZPresenterProtocol {
		var wornCloset: FZWornCloset { get { return worn_closet } set {} }

		fileprivate let keyring_: FZKeyring, worn_closet: FZWornCloset
		fileprivate var _viewController: SomeViewController? {
			return wornCloset.getPresenterEntities( by: keyring_.key )?.viewController as? SomeViewController
		}

		init () {
			keyring_ = FZKeyring()
			worn_closet = FZWornCloset( keyring_.key )
		}

		func postViewActivated () {}

		func show ( pageName: String ) {}
	}

And a basic, boilerplate Filzanzug ViewController looks like this:

	import Filzanzug

	class SomeViewController: FZViewController {}`

A basic, boilerplate Filzanzug Proxy (or Service) looks like this:

	import Filzanzug

	protocol SomeProxyProtocol: FZModelClassProtocol {
		func someFunction ( someData: Any )
	}

	class SomeProxy: SomeProxyProtocol {
		public var wornCloset: FZWornCloset { get { return worn_closet } set {} }

		fileprivate let
		keyring_: FZKeyring,
		worn_closet: FZWornCloset

		required init () {
			keyring_ = FZKeyring()
			worn_closet = FZWornCloset( keyring_.key )
		}

		func activate () {}

		func deallocate () {}

		func someFunction ( someData: Any ) {}
	}

Extend `SwinjectStoryboard` to register your Interactor/Presenter/ViewController relationships:

	import Filzanzug
	import SwinjectStoryboard

	extension SwinjectStoryboard {
		@objc class func postSetup () {
			var viewController: FZViewController?
			defaultContainer.storyboardInitCompleted( SomeViewController.self ) {
				resolvable, instance in
				viewController = instance
				instance.signalBox.signals = defaultContainer.resolve( FZSignalsService.self )!
				_ = resolvable.resolve( SomeInteractor.self )! }
			defaultContainer.register( SomePresenter.self ) {
				resolvable in SomePresenter()
				}.inObjectScope( .container ).initCompleted( {
					resolvable, instance in
					instance.wornCloset.set( signals: defaultContainer.resolve( FZSignalsService.self )! )
					instance.wornCloset.set(
						entities: FZPresenterEntities(
							routing: resolvable.resolve( FZRoutingService.self )!,
							viewController: viewController ) )
					viewController = nil
					instance.activate() } )
			defaultContainer.register( SomeInteractor.self ) {
				resolvable in SomeInteractor()
				}.inObjectScope( .transient ).initCompleted( {
					resolvable, instance in
					instance.wornCloset.set( signals: defaultContainer.resolve( FZSignalsService.self )! )
					instance.wornCloset.set(
						entities: FZInteractorEntities(
							image: resolvable.resolve( FZImageProxy.self )!,
							presenter: resolvable.resolve( SomePresenter.self )! ) )
					instance.activate() } )
		}
	}

An example repo will follow this brief, introductory documentation.
