Dertisch
========

A lightweight SWITCH framework for Swift apps
----------------------------------------------

Dertisch is a lightweight framework for Swift built around **dependency injection**. Part [**MVVM**](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) and part [**VIPER**](https://www.objc.io/issues/13-architecture/viper/), its hybrid nature makes it strictly neither, but instead a **SWITCH** framework specifically designed to be **Swifty** by way of the **protocol oriented** nature of Swift.

`SWITCH` is a culinary metaphorical acronym designed to explain `Dertisch`'s hybrid nature.

-   `S` Sous Chefs
-   `W` Waiters
-   `I` Ingredients
-   `T` The Maitre D
-   `C` Customers
-   `H` Head Chefs

The Maitre D
------------

The head waiter. The Maitre D is classically a VIPER `routing`, which controls the addition and removal of `views` and manages relationships between customers, waiters, and head chefs.

Ingredients
-----------

The raw materials of any dish. Ingredients are classically `services`, which query APIs etc. for data.

Sous Chefs
----------

The second-in-command chefs who take the ingredients and combine them into dishes. Sous Chefs are classically `proxies`, which get and set data internally.

Head Chefs
----------

The people who control the staff and the dishes. Head Chefs are classically VIPER `interactors`, which have access to specific `sous chefs` in order to create particular combinations of data.

Waiters
-------

The people who take dishes from kitchen to table. Waiters are classically part VIPER `presenters` and part MVVM `viewModels` - ergo `presenterModels` - which are given data by `head chefs` in order to populate and control views.

Customers
---------

The people ordering the food. Customers are classically `views` and/or `viewControllers`, the screens the user sees.

----------------------------
How SWITCH works in Dertisch
----------------------------

-   A customer makes an order (a user interacts with a `view`);
-   the head chef instructs their staff as to the required dishes (the `interactor` queries its `proxies`);
-   the staff cook ingredients and present the head chef with the dishes (the `proxies` combine data they already have with data they need, probably asynchronously, from their `services`);
-   the head chef gives the dishes to the waiter (the `interactor` calls its `presenterModel` with data);
-   the waiter serves the customer (the `view` populates itself via its `presenterModel`); and
-   the table is laid with dishes (the `view` updates in accordance with the original interaction of the `user`).

Dertisch is designed to provide the functionality common to most apps, which specifically (at present) means the following.

On the Model side:

-   API calls;
-   management of external images;
-   simplified access to Core Data;
-   simplified integration of bundled json files; and
-   the capacity to add bespoke proxies and services.

And on the View side:

-	registration and presentation of Customers with related Waiters and Head Chefs.

Head Chefs work by implementing the `DTHeadChefProtocol` protocol; waiters by implementing the `DTWaiter` protocol; and customers by subclassing `DTCustomer`.

---------------
Using Dertisch
---------------

Classically speaking, `Kitchen` classes make up `Dertisch`'s model, whilst `Restaurant` classes make up `Dertisch`'s view and controller. Dertisch allows you to create bespoke `sous chefs` and `ingredients` (proxies and services) tailored towards your app's specific needs, and also comes with five in-built `kitchen` classes, and two in-built `restaurant` classes serving functionality common to all apps:

	KITCHEN (model)

	INGREDIENTS (services)

	DTBundledJson
	// provides simplified access to json config data bundled with the app

	DTCoreData
	// provides simplified access to Core Data storage

	DTUrlSession
	// provides access to RESTful APIs

	SOUS CHEFS (proxies)

	DTImages
	// provides capacity to load and get copies of images

	DTTemporaryValues
	// provides app-wide storage for simple data in runtime memory

	RESTAURANT (views and controllers)

	DTMaitreD
	// manages the addition and removal of Customers and their relationships with Head Chefs and Waiters
	// (the maitre D is classically a VIPER routing)

	DTOrders
	// provides an independent and scoped app-wide communications mechanism
	// (orders are classically Observers)

All kitchen classes in `Dertisch` are injected as *singleton-with-a-small-s* single instances. For instance, this mean that two separate Head Chefs that both have an instance of `DTTemporaryValues` injected have *the same instance* of `DTTemporaryValues` injected, so any properties set on that instance by one Head Chef will be readable by the other, and vice versa. And the same goes for all subsequent injections of `DTTemporaryValues` elsewhere.

`DTMaitreD` is responsible for starting `Dertisch` apps, and `DTOrders` is a mandatory requirement for all `Dertisch` apps, and so they are instantiated by default. The others are instantiated on a **need-to-use** basis.

Start your `Dertisch` app by calling `DTMaitreD.greet(firstCustomer:)` from `AppDelegate`:

	class AppDelegate: UIResponder, UIApplicationDelegate {

		var window: UIWindow?

		func application(
			_ application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
			window = UIWindow(frame: UIScreen.main.bounds)
			DTMaitreD().greet(firstCustomer: "SomeCustomer", window: window!)
			return true
		}
	}

`DTMaitreD`'s start up routine includes a call to its own `registerStaff()` function, which is where the app's required kitchen and restaurant staff must be registered. Extend `DTMaitreD` implementing `DTMaitreDExtensionProtocol` to utilise this function:

	extension DTMaitreD: DTMaitreDExtensionProtocol {
		public func registerStaff(with key: String) {
	//		register(DTBundledJson.self, with: key)
			register(DTTemporaryValues.self, with: key)
			register(DTImages.self, with: key, injecting: [DTUrlSession.self])
			register(SomeSousChef.self, with: key)
			register(SomeIngredient.self, with: key, injecting: [SomeSousChef.self])
			register(
				"SomeCustomer",
				as: SomeCustomer.self,
				with: SomeWaiter.self,
				and: SomeHeadChef.self,
				lockedBy: key,
				andInjecting: [DTTemporaryValues.self])
		}
	}

In the above example, because `DTBundledJson` is commented out, injectable instances of this kitchen class will not be instantiated, as whatever app it is that is utilising this code presumably has no need of its functionality (it would make more sense to simply delete these two lines, but they are included here to demonstrate how they would be used if they were needed).

All `Dertisch` kitchen classes have `DTOrders` injected by default, and it is also possible to inject other model classes into each other. For instance, in the code example above `DTImages` has `DTUrlSession` injected as it depends upon it to load external images.

In the final `register` function above, `SomeCustomer`, `SomeWaiter`, and `SomeHeadChef` are bespoke classes (or structs) written for the implementing app in question, and the registration function is which they appear creates a `viewController -> presenterModel <- interactor` relationship. `andInjecting` is an optional array in which one lists the sous chef classes that `SomeHeadChef` will need to do their job.

The above code example features the two model classes `SomeSousChef` and `SomeIngredient`. These are bespoke kitchen classes not included in `Dertisch` but written specifically for the implementing app in question. The boilerplate code for `SomeSousChef` looks like this:

	class SomeSousChef: DTSousChefProtocol {
		init(kitchenClasses: [String: DTKitchenProtocol]?: [DTKitchenProtocol]?) {}
	}

Sous chefs, head chefs, and waiters can all be either `classes` or `structs`. So a boilerplate `Dertisch` Head Chef could look like this:

	class SomeHeadChef: DTHeadChefProtocol {
		init(orders: DTOrders, waiter: DTWaiter, kitchenStaff: [DTKitchenProtocol]?) {}
	}

or like this:

	struct SomeHeadChef: DTHeadChefProtocol {
		init(orders: DTOrders, waiter: DTWaiter, kitchenStaff: [DTKitchenProtocol]?) {}
	}

And a boilerplate `Dertisch` Waiter looks like this:

	class/struct SomeWaiter: DTWaiter {
		init(orders: DTOrders, maitreD: DTMaitreD) {
	}

A boilerplate `Dertisch` Customer looks like this:

	class SomeCustomer: DTCustomer {
		override func pass(_ orders: DTOrders, to waiter: DTWaiterForCustomer) {}
	}

Customers are the only classes in `Dertisch` to utilise inheritance, each `Dertisch` customer being required to extend the `DTCustomer` class, which itself extends `UIViewController`. The rest of the library, uses `protocols` and `extensions` exclusively.

---------------------
Indepth Documentation
---------------------

There are more elements to `Dertisch` than those described above, but because nobody except myself is known to be using it presently I see no need for greater detail yet. If you would like to know more, please ask.

**note to self** - things to document:

-   Project settings [main target] > General > Deployment Info > Main Interface [leave empty]

---------------------
Developmental Roadmap
---------------------

`Dertisch` is still in beta at version `0.2`. No official timescale exists for ongoing development, but present suggestions are as follows:

-   I am currently working on version `0.3`, in which `DTOrders` is entirely removed in favour of extensible protocols allowing waiters to pass communications between customers and head chefs (for example);
-   remove unused code;
-	work out which classes, structs, and protocols can be made internal and/or final, and make them internal and/or final;
-	make utils functions native class extensions instead;
-	allow multiple `DTHeadChefProtocol` instances to be associated with a single `DTWaiter` instance;
-	make Head Chefs optional [at registration] so some screens can be entirely Waiter controlled;
-	instigate Redux-style 'reducer' process for kitchen classes so they can become structs that overwrite themselves;
-	move optional Sous Chefs and Ingredients into their own repos to minimise the footprint of the core framework;
-	new `MetricsSousChef` for serving device-specific numeric constants;
-	new `LanguageSousChef` for multi-lingual capabilities (to somehow be plugged into`DTWaiter`?);
-	new `FirebaseIngredient`;
-	replace `cleanUp()` functions with weak vars etc;
-	force `DTCoreData` to take `dataModelName` at start up;
-	remove `...Protocol` from protocol names;
-	reintroduce timeout stopwatch to `DTUrlSession`;
-	complete list of MIME types in `DTUrlSession`;
-	create example boilerplate app;
-   remove fatal errors.

-----------------------
On the name "Dertisch"
-----------------------

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be a self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" extremely well. Richard is the author of `Dertisch`, and was born the same year that the real Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting.

"Dertisch" means "the table" in Deutsche, and is the name of [an artwork by Joseph Beuys](http://www.artnet.com/artists/joseph-beuys/der-tisch-AzXWfzZdG5Z4npv6LZT_8g2). Given that it is built around the metaphorical notion of serving hot dishes to restaurant customers, from all of Beuys' works `Dertisch` fits excellently as a name.

It also sounds a bit like "Dirtish", which is fun.
