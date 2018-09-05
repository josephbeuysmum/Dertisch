Dertisch
========

NOTE
----

*The last update has made much of the following documentation out-of-date. It will be updated as soon as possible.*


A lightweight framework for Swift apps
--------------------------------------

Dertisch is a lightweight part-MVVM, part-VIPER framework for Swift built around dependency injection. It is specifically structured with the goal of **minimising code resuse**, which simultaneously taking advantage of the **Protocol Orientated** nature of Swift.

The following `SWITCH` acronym presents a culinary example which illustrates `Dertisch`'s hybrid `MV/IPER` nature.

-   `S` Sous Chefs
-   `W` Waiters
-   `I` Ingredients
-   `T` Tables
-   `C` Customers
-   `H` Head Chefs

Ingredients
-----------

The raw materials of any dish. Ingredients are classically `services`, which query APIs etc. for data.

Sous Chefs
----------

The second-in-command chefs who take the ingredients and combine them into dishes. Sous Chefs are classically `proxies`, which get and set data internally.

Head Chefs
----------

The people who control the staff and the menu. Head Chefs are classically VIPER `interactors`, which have access to specific `Sous Chefs` in order to create particular combinations of data.

Waiters
-------

The people who take dishes from kitchen to table. Waiters are classically VIPER `presenters`, which are given data by `Head Chefs` in order to populate and control views.

Tables
------

The literal, physical tables in the restaurant upon which the dishes are served. Tables are classically `views`, the screens the user sees. However, it should be noted that because of the frequent use of the word "table" in Cocoa components, internally `Dertisch` uses the word "dish" instead, so as to avoid confusion.

Customers
---------

The people ordering the food. Customers are users: the actual people using the actual app.

How MV/IPER works in Dertisch
-----------------------------------

-   A customer makes an order (a `user` interacts with their device);
-   the head chef instructs their staff as to the required dishes (the `interactor` queries its `proxies`);
-   the staff cook ingredients and present the head chef with the dishes (the `proxies` combine data they already have with data they need asynchronously from their `services`);
-   the head chef gives the dishes to the waiter (the `interactor` calls its `presenter` with data);
-   the waiter takes the dishes to the table (the `presenter` populates its `view` with data); and
-   the table is laid with dishes (the `view` updates in accordance with the original interaction of the `user`).

Dertisch is designed to provide the functionality common to most apps, which specifically (at present) means the following.

On the Model side:

-   API calls;
-   management of external images;
-   simplified access to Core Data;
-   simplified integration of bundled json files; and
-   the capacity to add bespoke proxies and services.

And on the View side:

-	registration and presentation of Dishs with related Waiters and Interactors.

`Dertisch` Head Chefs work by implementing the `DTHeadChefProtocol` protocol; Waiters by implementing the `DTWaiterProtocol` protocol; and Dishes by subclassing `DTDish`.

---------------
Using Dertisch
---------------

Dertisch allows you to create bespoke proxies and services tailored towards your app's specific needs, and it also comes with seven in-built model classes tailored towards functionality common to all apps:

	DTBundledJson
	// provides simplified access to json config data bundled with the app

	DTCoreData
	// provides simplified access to Core Data data storage

	DTImages
	// provides capacity to load and get copies of images

	DTMaitreD
	// manages the addition and removal of Dishs and their relationships with Interactors and Waiters (maitre Ds are classically VIPER routings)

	DTOrders
	// provides an independent and scoped app-wide communications mechanism

	DTTemporaryValues
	// provides app-wide storage for simple data in runtime memory

	DTUrlSession
	// provides access to RESTful APIs

These - and all model classes - in `Dertisch` are injected as *singleton-with-a-small-s* single instances. For instance, this mean that two separate Interactors that both have an instance of `DTTemporaryValuesSousChef` injected have *the same instance* of `DTTemporaryValuesSousChef` injected, so any properties set on that instance by one of the Interactors will be readable by the other, and vice versa. And the same goes for all subsequent injections of `DTTemporaryValuesSousChef` elsewhere.^

^ *this currently means that all `Dertisch` model classes are exactly that: classes, although the longer term goal to make `Dertisch` class-free (with the exception of View classes, which are already unavoidably class-based).*

Amongst other things, `DTMaitreD` is responsible for starting `Dertisch` apps, and `DTOrders` is a mandatory requirement for all `Dertisch` apps, and so they are instantiated by default. The others are instantiated on a **need-to-use** basis.

Start up your `Dertisch` app by calling `DTMaitreD.start()` from your `AppDelegate`:

	import Dertisch
	import UIKit

	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {

		var window: UIWindow?

		func application(
			_ application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
			window = UIWindow(frame: UIScreen.main.bounds)
			DTMaitreD().start(rootDish: "SomeDish", window: window!)
			return true
		}
	}

`DTMaitreD`'s start up routine includes a call to its own `registerDependencies()` function, which is where the app's required kitchenStaff must be registered. Extend `DTMaitreD` to implement this function:

	import Dertisch

	extension DTMaitreD: DTMaitreDExtensionProtocol {
		public func registerDependencies(with key: String) {
	//		register(DTCoreDataSousChef.self, with: key)
			register(DTTemporaryValuesSousChef.self, with: key)
			register(DTUrlSession.self, with: key)
	//		register(DTImageSousChef.self, with: key, injecting: [DTUrlSession.self])
			register(SomeSousChef.self, with: key)
			register(SomeIngredient.self, with: key, injecting: [SomeSousChef.self])
			register(
				"SomeDish",
				as: SomeDish.self,
				with: SomeInteractor.self,
				and: SomeWaiter.self,
				lockedBy: key,
				andInjecting: [SomeSousChef.self])
		}
	}

In the above example, because `DTCoreDataSousChef` and `DTImageSousChef` are commented out, injectable instances of these two model classes will not be instantiated, as whatever app it is that is utilising this code presumably has no need of their functionality.^^

^^ *it would make more sense to simply delete these two lines, but they are included here to demonstrate how they would be used if they were needed.*

All `Dertisch` model classes have `DTOrders` injected by default, and it is also possible to inject other model classes into each other. For instance, in the code example above `DTImageSousChef` has `DTUrlSession` injected as it depends upon it to load external images.

The above code example features the two model classes `SomeSousChef` and `SomeIngredient`. These are bespoke model classes not included in `Dertisch` but written specifically for the implementing app in question. The boilerplate code for `SomeSousChef` looks like this:

	import Dertisch

	extension SomeSousChef: DTKitchenProtocol {
		var closet: DTKitchenCloset { return closet_ }
		func startShift() {}
		mutating func cleanUp() {}
	}

	class SomeSousChef {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTKitchenCloset!

		required init() {
			key_ = DTKey(self)
			closet_ = DTKitchenCloset(self, key: key_)
		}
	}

And adding your own functionality in looks like this:

	protocol SomeSousChefProtocol: DTKitchenProtocol {
		mutating func someFunction(someData: Any)
	}

	extension SomeSousChef: SomeSousChefProtocol {
		...
		mutating func someFunction(someData: Any) {}
	}

`key_`, `closet_`, and `closet` are properties which allow kitchenStaff to be injected by `DTMaitreD`, whilst simultaneously ensuring they are locked privately inside thereafter, and only available to - in this case - `SomeSousChef`. `key_` and `closet_` are forced unwrapped vars so that `self` can be injected into them at initialisation.^^^

^^^ *the purpose of which is to ensure that the object they are injected into can only have one instance of each, as multiple instances of either would cause runtime errors.*

`Dertisch` Interactors and Waiters have similar `key_` and `closet_` properties for the same purpose.

A boilerplate `Dertisch` Interactor looks like this:

	import Dertisch

	extension SomeInteractor: DTHeadChefProtocol {
		mutating func waiterActivated() {}
		mutating func cleanUp() {}
	}

	struct SomeInteractor {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTHeadChefCloset!

		init(){
			key_ = DTKey(self)
			closet_ = DTHeadChefCloset(self, key: key_)
		}
	}

And a boilerplate `Dertisch` Waiter looks like this:

	import Dertisch

	extension SomeWaiter: DTWaiterProtocol {
		var closet: DTWaiterCloset? { return closet_ }
	}

	struct SomeWaiter {
		fileprivate var key_: DTKey!
		fileprivate var closet_: DTWaiterCloset!

		init() {
			key_ = DTKey(self)
			closet_ = DTWaiterCloset(self, key: key_)
		}
	}

The `closet_` property in a model class, headChef, or waiter needs its accompanying `key_` property to access the properties stored within it, and because both are fileprivate properties, only the owning object - the `SomeWaiter` struct in the above example, say - can access it.

There are four additional functions that can be implemented if required.

	extension SomeWaiter: DTWaiterProtocol {
		...
		func dishCooked() {}
		mutating func serve<T>(with data: T?) {}
		func dishServed() {}
		mutating func cleanUp() {}
	}

These functions are hopefully self-explanatory, and they are called in the order they are listed above.

A boilerplate `Dertisch` Dish looks like this:

	import Dertisch

	class SomeDish: DTDish {}

Dishs are the only classes in `Dertisch` to utilise inheritance, each `Dertisch` Dish being required to extend the `DTDish` class. This is because Swift view components are already built on multiple layers on inheritance, so there is nothing more to be lost by using inheritance. The rest of the library, uses `protocol`s and `extension`s exclusively.

---------------------
Indepth Documentation
---------------------

There are more elements to `Dertisch` than those described above, but because nobody except myself is known to be using it presently I see no need for greater detail yet. If you would like to know more, please ask.

---------------------
Developmental Roadmap
---------------------

No official timescale exists for ongoing dev, but presently suggested developments are as follows:

-	replace `closet_` properties with init functions with optional params;
-	work out which classes, structs, and protocols can be made internal and/or final, and make them internal and/or final;
-	allow multiple `DTHeadChefProtocol` instances to be associated with a single `DTWaiterProtocol` instance;
-	make Interactors optional [at registration] so some screens can be entirely Waiter controlled;
-	instigate Redux-style 'reducer' process for model classes so they can become structs that overwrite themselves;
-	move off-the-peg proxies and services into their own individual repos so the core framework is as minimal as possible;
-	make utils functions native class extensions instead;
-	new `MetricsSousChef` for serving device-specific numeric constants;
-	new `LanguageSousChef` for multi-lingual capabilities;
-	new `FirebaseIngredient`;
-	create example boilerplate app;
-	replace `cleanUp()` functions with weak vars etc.;
-	force `DTCoreDataSousChef` to take `dataModelName` at start up;
-	remove `...Protocol` from protocol names?
-	reintroduce timeout stopwatch to `DTUrlSession`;
-	complete list of MIME types in `DTUrlSession`;
-   use cuisine as a metaphor instead of tailoring.

-----------------------
On the name "Dertisch"
-----------------------

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be a self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" extremely well. Richard is the author of `Dertisch`, and was born the same year that the real Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting.

"Dertisch" means "the table" in Deutsche, and is the name of [an artwork by Joseph Beuys](http://www.artnet.com/artists/joseph-beuys/der-tisch-AzXWfzZdG5Z4npv6LZT_8g2). Given that `Dertisch` (the Swift library) is built around the metaphorical notion of serving hot dishes to restaurant customers, from all of Beuys' works, *Dertisch* fits excellently as a name.
