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

	extension SomeInteractor: FZInteractorProtocol {
		var wornCloset: FZWornCloset { get { return worn_closet } set {} }
		
		func postPresenterActivated () {}
	}

	struct SomeInteractor {
		fileprivate let key_ring: FZKeyring
		fileprivate let worn_closet: FZWornCloset
		fileprivate var presenter_: SomePresenter? {
			return worn_closet.getInteractorEntities( by: key_ring.key )?.presenter as? SomePresenter
		}
		
		init () {
			key_ring = FZKeyring()
			worn_closet = FZWornCloset( key_ring.key )
		}
	}

A boilerplate Filzanzug Presenter looks like this:

	import Filzanzug

	extension SomePresenter: FZPresenterProtocol {
		var wornCloset: FZWornCloset { get { return worn_closet } set {} }
		
		func postViewActivated () {}
		
		func show ( pageName: String ) {}
	}

	struct SomePresenter {
		fileprivate let key_ring: FZKeyring, worn_closet: FZWornCloset
		fileprivate var _viewController: SomeViewController? {
			return worn_closet.getPresenterEntities( by: key_ring.key )?.viewController as? SomeViewController
		}
		
		init () {
			key_ring = FZKeyring()
			worn_closet = FZWornCloset( key_ring.key )
		}
	}

And a basic, boilerplate Filzanzug ViewController looks like this:

	import Filzanzug

	class SomeViewController: FZViewController {}`

A basic, boilerplate Filzanzug Proxy (or Service) looks like this:

	import Filzanzug

	protocol SomeProxyProtocol: FZModelClassProtocol {
		func someFunction ( someData: Any )
	}

	extension SomeProxy: SomeProxyProtocol {
		public var wornCloset: FZWornCloset { get { return worn_closet } set {} }
		
		func activate () {}
		
		func deallocate () {}
		
		func someFunction ( someData: Any ) {}
	}

	class SomeProxy {
		fileprivate let
		key_ring: FZKeyring,
		worn_closet: FZWornCloset
		
		required init () {
			key_ring = FZKeyring()
			worn_closet = FZWornCloset( key_ring.key )
		}
	}

Presently `Filzanzug` uses the cocoapod dependency `SwinjectStoryboard` to register and dependency-inject  ModelClass/Interactor/Presenter/ViewController relationships, the next version of `Filzanzug` aims to remove this dependency:

	import Filzanzug
	import SwinjectStoryboard

	extension SwinjectStoryboard {
		
		@objc class func postSetup () {
			
			defaultContainer.register( SomeService.self ) {
				_ in SomeService()
				}.inObjectScope( .container ).initCompleted( {
					resolvable, instance in
					instance.wornCloset.set( signals: resolvable.resolve( FZSignalsService.self )! )
					instance.activate() } )
			defaultContainer.register( SomeProxy.self ) {
				_ in SomeProxy()
				}.inObjectScope( .container ).initCompleted( {
					resolvable, instance in
					instance.wornCloset.set( signals: resolvable.resolve( FZSignalsService.self )! )
					let entities = FZModelClassEntities()
					entities.bespokeRail.add( modelClass: defaultContainer.resolve( SomeService.self )! )
					instance.wornCloset.set( entities: entities )
					instance.activate() } )

			var viewController: FZViewController?
			defaultContainer.storyboardInitCompleted( SomeViewController.self ) {
				resolvable, instance in
				viewController = instance
				instance.signalBox.signals = defaultContainer.resolve( FZSignalsService.self )!
				_ = resolvable.resolve( SomeInteractor.self )! }
			defaultContainer.register( SomePresenter.self ) {
				resolvable in SomePresenter()
				}.inObjectScope( .transient ).initCompleted( {
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
					let entities = FZInteractorEntities(
						image: resolvable.resolve( FZImageProxy.self )!,
						presenter: resolvable.resolve( SomePresenter.self )! )
					entities.bespokeRail.add( modelClass: defaultContainer.resolve( SomeProxy.self )! )
					instance.wornCloset.set( entities: entities )
					instance.activate() } )
		}
	}

An example repo will follow this brief, introductory documentation.

-----------------------
On the name "Filzanzug"
-----------------------

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" very well. Richard is the author of `Filzanzug`, and was born the same year that Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting. 

"Filzanzug" means "felt suit" in Deutsche, and is the name of an artwork by Joseph Beuys, which consists of 100 identical felt suits. [One of the suits](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) is in the collection of the Tate Gallery in the UK. If you'll permit me a bad pun, given that `Filzanzug` (the Swift library) is built around a "WORN closet" object, from all of Beuys' works, [Filzanzug](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) (the artwork) is "tailor-made" as a name. 
