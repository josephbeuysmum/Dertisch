Filzanzug
=========

A lightweight VIPER framework for Swift apps
--------------------------------------------

Filzanzug is lightweight VIPER framework for Swift built using a "write once, read never", or **WORN** dependency injection system, meaning properties are injected once and not publicly accessible thereafter.

Filzanzug Interactors, Presenters, and Model Classes each have a fileprivate `worn_closet` property that grants access to singleton-with-a-small-s proxies and services, including the `FZSignalsService`, which is used to transmit and receive events throughout implementing apps.

Filzanzug is specifically structured with the goal of **minimising code resuse**, which simultaneously taking advantage of the **Protocol Orientated** nature of Swift. It is designed to provide the functionality common to most apps, which specifically (at present) means the following.

On the Model side:

-   API calls;
-   management of external images;
-   simplified access to Core Data; and
-   the capacity to add custom proxies and services.

And on the View side:

-	registration and presentation of ViewControllers with related Presenters and Interactors.

`Filzanzug` Interactors work by implementing the `FZInteractorProtocol` protocol; Presenters by implementing the `FZPresenterProtocol` protocol; and ViewControllers by subclassing `FZViewController`. It uses **dependency injection** to register Interactor/Presenter/ViewController/ModelClass relationships at start-up.

---------------
Using Filzanzug
---------------

Filzanzug comes with seven in-built model classes:

	FZBundledJsonService
	// provides simplified access to json config data bundled with the app

	FZCoreDataProxy
	// provides simplified access to Core Data data storage

	FZImageProxy
	// provides capacity to load and get copies of images

	FZRoutingService
	// manages the addition and removal of ViewControllers and their relationships with Interactors and Presenters

	FZSignalsService
	// provides an independent and scoped app-wide communications mechanism

	FZTemporaryValuesProxy
	// provides temporary storage for simple data in runtime memory

	FZUrlSessionService
	// provides access to RESTful APIs

These - and all model classes - in `Filzanzug` are injected as *singleton-with-a-small-s* single instances. For instance, this mean that two separate Interactors that both have an instance of `FZTemporaryValuesProxy` injected have *the same instance* of `FZTemporaryValuesProxy` injected, so any properties set on that instance by one of the Interactors will be readable by the other, and vice versa. And the same goes for all subsequent injections of `FZTemporaryValuesProxy` elsewhere.

Amongst other things, `FZRoutingService` is responsible for starting `Filzanzug` apps, and `FZSignalsService` is a mandatory requirement for all `Filzanzug` apps, and so they are instantiated by default. The others are instantiated on a **need-to-use** basis.

Start up your `Filzanzug` app by calling `FZRoutingService.start()` from your `AppDelegate`:

	import Filzanzug
	import UIKit

	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {

		var window: UIWindow?

		func application(
			_ application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
			window = UIWindow(frame: UIScreen.main.bounds)
			FZRoutingService(with: FZKey()).start(rootViewController: Consts.introViewController, window: window!)
			return true
		}
	}

`FZRoutingService`'s start up routine includes a call to its own `registerDependencies()` function, which is where the app's required dependencies must be registered. Extend `FZRoutingService` to implement this function:

	import Filzanzug

	extension FZRoutingService: FZRoutingServiceExtensionProtocol {
		public func registerDependencies(with key: String) {
	//		register(FZCoreDataProxy.self, with: key)
			register(FZTemporaryValuesProxy.self, with: key)
			register(FZUrlSessionService.self, with: key)
	//		register(FZImageProxy.self, with: key, injecting: [FZUrlSessionService.self])
			register(SomeProxy.self, with: key)
			register(SomeService.self, with: key, injecting: [SomeProxy.self])
			register(
				viewControllerId: "SomeViewController",
				viewControllerType: SomeViewController.self,
				interactorType: SomeInteractor.self,
				presenterType: SomePresenter.self,
				with: key,
				injecting: [SomeProxy.self])
		}
	}

In the above example, because `FZCoreDataProxy` and `FZImageProxy` are commented out, injectable instances of these two model classes will not be instantiated, as whatever app it is that is utilising this code presumably has no need of their functionality.^

^ *it would make more sense to simply delete these two lines, but they are included here to demonstrate how they would be used if they were needed.*

All `Filzanzug` model classes have `FZSignalsService` injected by default, and it is also possible to inject other model classes into each other. For instance, in the code example above `FZImageProxy` has `FZUrlSessionService` injected as it depends upon it to load external images.

The above code example features the two model classes `SomeProxy` and `SomeService`. These are bespoke model classes not included in `Filzanzug` but written specifically for the implementing app in question. The boilerplate code for `SomeProxy` would look like this:

	import Filzanzug

	protocol SomeProxyProtocol: FZModelClassProtocol {
		func someFunction(someData: Any)
	}

	extension SomeProxy: SomeProxyProtocol {
		var wornCloset: FZWornCloset { return worn_closet }

		func activate() {}

		func deallocate() {}

		func someFunction(someData: Any) {}
	}

	class SomeProxy {
		fileprivate let
		key_: FZKey,
		worn_closet: FZWornCloset

		required init() {
			key_ = FZKey()
			worn_closet = FZWornCloset(key_.hash)
		}
	}

`key_` and `worn_closet` are private properties which allow dependencies to be injected by `FZRoutingService`, whilst simultaneously ensuring they are locked privately inside thereafter, and only available to - in this case - `SomeProxy`.

`Filzanzug` Interactors and Presenters have identical `key_` and `worn_closet` properties for the same purpose.

A boilerplate `Filzanzug` Interactor looks like this:

	import Filzanzug

	extension SomeInteractor: FZInteractorProtocol {
		var wornCloset: FZWornCloset { return worn_closet }

		func postPresenterActivated() {}
	}

	struct SomeInteractor {
		fileprivate let
		key_: FZKey,
		worn_closet: FZWornCloset
		fileprivate var presenter_: SomePresenter? {
			return worn_closet.getInteractorEntities(by: key_.hash)?.presenter as? SomePresenter
		}

		init() {
			key_ = FZKey()
			worn_closet = FZWornCloset(key_.hash)
		}
	}

And a boilerplate `Filzanzug` Presenter looks like this:

	import Filzanzug

	extension SomePresenter: FZPresenterProtocol {
		var wornCloset: FZWornCloset { return worn_closet }

		func postViewActivated() {}

		func show(pageName: String) {}
	}

	struct SomePresenter {
		fileprivate let
		key_: FZKey,
		worn_closet: FZWornCloset
		fileprivate var view_controller: SomeViewController? {
			return worn_closet.getPresenterEntities(by: key_.hash)?.viewController as? SomeViewController
		}

		init() {
			key_ = FZKey()
			worn_closet = FZWornCloset(key_.hash)
		}
	}

The `worn_closet` property in a model class, interactor, or presenter needs the `key` property^ from its accompanying `key_` property to access the properties stored within it, and because `key_` is a private property, only the owning struct - `SomeInteractor` in the above example, say - can access it.

^ *a `NSUUID().uuidString` generated at runtime.*

A boilerplate `Filzanzug` ViewController looks like this:

	import Filzanzug

	class SomeViewController: FZViewController {}

ViewControllers are the only classes in `Filzanzug` to utilise inheritance, each `Filzanzug` ViewController being required to extend the `FZViewController` class. This is because Swift view components are already built on multiple layers on inheritance, so there is nothing more to be lost by using inheritance. The rest of the library, uses `protocol`s and `extension`s exclusively.

---------------------
Developmental Roadmap
---------------------

No official timescale exists for ongoing dev, but presently suggested developments are as follows:

-	privately instantiate `FZKey`s rather than inject them;
-	make access to the `bespokeRail` a lot less wordy;
-	work out which classes, structs, and protocols can be made internal and/or final, and make them internal and/or final;
-	allow multiple `FZInteractorProtocol` instances to be associated with a single `FZPresenterProtocol` instance;
-	instigate Redux-style 'reducer' process for model classes so they can become structs that overwrite themselves;
-	new `MetricsProxy` for serving device-specific numeric constants?;
-	move off-the-peg proxies and services into their own individual repos so the core framework is as minimal as possible;
-	add Firebase service;
-	create example boilerplate app;
-	replace `deallocate()` functions with an improved method of garbage collection;
-	try to find a way to ensure the repeated `fileprivate var closet_key: String?` code can be written just once;
-	reintroduce timeout stopwatch to `FZUrlSessionService`;
-	complete list of MIME types in `FZUrlSessionService`;

-----------------------
On the name "Filzanzug"
-----------------------

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be a self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" extremely well. Richard is the author of `Filzanzug`, and was born the same year that the real Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting.

"Filzanzug" means "felt suit" in Deutsche, and is the name of an artwork by Joseph Beuys, which consists of 100 identical felt suits. [One of the suits](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) is in the collection of the Tate Gallery in the UK. If you'll permit me a bad pun, given that `Filzanzug` (the Swift library) is built around a "WORN closet" object, from all of Beuys' works, [Filzanzug](http://www.tate.org.uk/art/artworks/beuys-felt-suit-ar00092) (the artwork) is "tailor-made" as a name.
