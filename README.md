# Dertisch

A **swifty** MVP framework for Swift apps
---

`Dertisch` is a lightweight Swift framework built around **dependency injection**. Part [**MVVM**](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) and part [**VIPER**](https://www.objc.io/issues/13-architecture/viper/), its hybrid nature makes it strictly neither, but instead an **MVP** framework specifically designed to be **swifty** via the **protocol oriented** nature of Swift. The framework's name forms a culinary analogical acronym designed to explain its own hybrid nature.

-   `D` The Maître D
-   `E` Entrées
-   `R` Restaurant Staff
-   `T` Tables
-   `I` Ingredients
-   `S` Sous Chefs
-   `C` Customers
-   `H` Head Chefs

---
The Restaurant as a Design Pattern
---

Most design patterns are *simple design patterns* in that they translate their own purposes well without regard of how they relate to other patterns in a given app. When put together - a factory, some observers, and a decorator, say - it sounds like the plot of a surrealist movie: there is no common element tying these metaphors together. Writers describe this situation as **mixed metaphors**: the literary equivalent of an **anti-pattern** or **bad code smell**. Dertisch alleviates this bad smell by implementing a *complex design pattern*: the metaphors make sense in isolation *but also* collectively. And a good restaurant has a very similar structure to a good app:

-   Most restaurants are variations on a Restaurant/Kitchen theme, and most app architectures are variations on a View/Model theme.
-   The customer section of a good restaurant is visually enticing, warm and comfortable, and on brand for its particular cuisine. Good Views do likewise.
-   The kitchen of a good restaurant is clean, efficient, well organised, and focused on the preperation of raw ingredients. App Good Models do likewise.
-   A good restaurant maintains a clear division between its customer section and its kitchen, with the waiting staff connecting the two. Good Apps do likewise.

`Dertisch`'s restaurant design pattern is compromised of multiple simple design patterns divided into three categories:

-   **customer** patterns: `customers`, and `restaurant tables`;
-   **kitchen** patterns: `head chefs`, `sous chefs`, and `ingredients`; and
-   **salle** patterns: `waiters`, the `maitre d`, and the `sommelier`.

*La salle* is a French noun meaning "the dining room in a restaurant", amongst other things.

---

The Maître D
---

The head waiter. The Maître D is classically a VIPER `routing`, which controls the addition and removal of `views` and manages relationships between customers, waiters, and head chefs.

Entrées
---

The dishes customers start with. Entrées initialise viewControllers with data and are classically VIPER `entities`, which are simple data objects.

Restaurant Staff
---

The waiting staff. Waiters are classically part VIPER `presenters` and part MVVM `viewModels` - ergo MVP `presenters` - which are given data by head chefs in order to populate and control views, whilst the Sommelier (the wine waiter) is classically a `proxy` which specifically provides multilingual support for text.

Tables
---

The physical tables at which customers are seated. Restaurant Tables are classically `viewControllers`, the screens the user sees.

Ingredients
---

The raw materials of any dish. Ingredients are classically `services`, which query APIs etc. for data.

Sous Chefs
---

The second-in-command chefs who take the ingredients and combine them into dishes. Sous Chefs are classically `proxies`, which get and set data internally.

Customers
---

The people ordering the food. Customers are classically users.

Head Chefs
---

The people who control the kitchen staff and the dishes. Head Chefs are classically VIPER `interactors`, which have access to specific sous chefs in order to create particular combinations of data.


---
How Dertisch is "swifty"
---

The **swiftiness** of `Dertisch` comes via its *many hats* philosophy, in which objects have different functions and properties exposed depending on the given context.

![Venn diagram of Dertisch relationships](https://raw.githubusercontent.com/josephbeuysmum/Dertisch/master/Assets/Venn.gif)

There is a chain of responsibility passing from `Customer` to `Ingredient` and back again through a series of hands that all have one specific role.

-   Ingredients **are** data;
-   Sous chefs **parse** data;
-   Head chefs **combine** data;
-   Waiters **present** data; and
-   Customers **consume** data.

You can think of this chaining as a **multifacted analogical delegate** pattern. Par exemple, the `Waiter` protocol only requires the implementation of an `init(...)` function for dependency injection, but also implements a number of other protocols that give the waiter different behaviours depending on context.

	protocol Waiter: WaiterForCustomer, WaiterForHeadChef, WaiterForWaiter, StaffMember, BeginShiftProtocol, EndShiftProtocol, SwitchesRelationshipProtocol {
		init(maitreD: MaitreD, customer: CustomerForWaiter, headChef: HeadChefForWaiter?)
	}

	protocol WaiterForCustomer: GiveOrderProtocol {
		var carte: CarteForCustomer? { get }
		func emptyCarte()
	}

	protocol WaiterForHeadChef {
		func serve(entrees: FulfilledOrder)
		func serve(main: FulfilledOrder)
	}

	protocol WaiterForWaiter {
		func addToCarte(_ main: FulfilledOrder)
		func fillCarte(with entrees: FulfilledOrder)
		func serve(dishes: FulfilledOrder)
	}

	protocol StaffMember: CigaretteBreakProtocol {}

	protocol CigaretteBreakProtocol {
		func beginBreak()
		func endBreak()
	}

	protocol BeginShiftProtocol {
		func beginShift()
	}

	protocol EndShiftProtocol {
		func endShift()
	}

	public protocol SwitchesRelationshipProtocol: class {}

When a `Customer` is passed a `Waiter` object it is done so as a `WaiterForCustomer` as opposed to a fully functioning `Waiter`, meaning that a waiter cannot be made to `serve(...)` by its customer in the way it can be by its head chef. Conversely, a waiter's head chef has no access to its `carte` of dishes, whereas its customer does.

---
An example interaction in Dertisch  
---

-   A customer makes an order (a user interacts with a `view`, sending a request to its `presenter`, which in turn passes the request to its `interactor`);
-   the head chef instructs their staff as to the required dishes (the `interactor` queries its `proxies`);
-   the staff cook ingredients and present the head chef with the dishes (the `proxies` combine data they already have with data they need, probably asynchronously, from their `services`);
-   the head chef gives the dishes to the waiter, who approaches the customer (the `interactor` calls its `presenter` with data, which it stores before informing the `view` that there is new data available);
-   the waiter and the sommelier serve the customer (the `view` populates itself via its `presenter` and its `textProxy`); and
-   the table is laid with dishes (the `view` updates in accordance with the original interaction of the user).

Dertisch is designed to provide the functionality common to most apps, which specifically (at present) means the following.

On the Model side:

-   API calls;
-   management of external images;
-   simplified access to Core Data;
-	simple data storage for runtime properties;
-   simplified integration of bundled json files; and
-   the capacity to add bespoke proxies and services.

And on the View side:

-	registration and presentation of Customers with related Waiters and Head Chefs; and
-	multi-language text support.

Head Chefs work by implementing the `HeadChef` protocol; waiters by implementing the `Waiter` protocol; and customers by subclassing `Customer`.

---
Using Dertisch
---

Classically speaking, `Kitchen` classes make up `Dertisch`'s model, whilst `Restaurant` classes make up `Dertisch`'s view and controller. Dertisch allows you to create bespoke `sous chefs` and `ingredients` (proxies and services) tailored towards your app's specific needs, and also comes with four in-built `kitchen` classes, and two in-built `restaurant` classes serving functionality common to all apps:

	KITCHEN: INGREDIENTS (model: services)

	FoodDelivery
	// provides access to RESTful APIs

	Freezer
	// provides simplified access to Core Data storage

	Images
	// provides capacity to load and get copies of images

	Larder
	// provides simplified access to json bundled with the app

	RESTAURANT (controllers)

	MaitreD
	// manages the addition and removal of Customers and their relationships with Head Chefs and Waiters
	// (the maître D is classically a VIPER routing)

	Sommelier
	// provides multi-language support for screen text
	// (the sommelier is classically a text proxy)

The built-in kitchen ingredients are very lightweight. For instance, `FoodDelivery` has a single `call(_:from:method:flagged:)` function that uses `URLSession.shared.dataTask(with:)`. Should you need more from your API service, you can simply create your own, say, `AlamofireSousChef` and put all the bells and whistles into it that you require.

All kitchen classes in `Dertisch` are injected as *singleton-with-a-small-s* single instances. For instance, this mean that two separate Head Chefs that both have an instance of `Images` injected have *the same instance* of `Images` injected, so any properties set on that instance by one Head Chef will be readable by the other, and vice versa. And the same goes for all subsequent injections of `Images` elsewhere.

`MaitreD` is responsible for starting `Dertisch` apps; `Sommelier` is a mandatory requirement for all `Dertisch` view controllers; and `Sommelier` depends upon `Larder`, so these three are instantiated by default. The others are instantiated on a need-to-use basis.

Start your `Dertisch` app by calling `MaitreD.greet(firstCustomer:)` from `AppDelegate`:

	class AppDelegate: UIResponder, UIApplicationDelegate {

		var window: UIWindow?

		func application(
			_ application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
			window = UIWindow(frame: UIScreen.main.bounds)
			MaitreD().greet(firstCustomer: "SomeCustomer", window: window!)
			return true
		}
	}

`MaitreD`'s start up routine includes a call to its own `registerStaff(with key: String)` function, which is where the app's required kitchen and restaurant staff must be registered. Extend `MaitreD` implementing `MaitreDExtension` to utilise this function:

	extension MaitreD: MaitreDExtension {
		public func registerStaff(with key: String) {
	//		register(Images.self, with: key, injecting: [FoodDelivery.self])
			register(SomeSousChef.self, with: key)
			register(SomeIngredient.self, with: key, injecting: [SomeSousChef.self])
			introduce(
				"SomeCustomer",
				as: SomeCustomer.self,
				with: key,
				waiter: SomeWaiter.self,
				chef: SomeHeadChef.self,
				kitchenStaff: [Images.self])
			introduce(
				"SomeOtherCustomer",
				 as: SomeOtherCustomer.self,
				 with: key)
		}
	}

In the above example, because `Images` is commented out, injectable instances of this kitchen class will not be instantiated, as whatever app it is that is utilising this code presumably has no need of its functionality (it would make more sense to simply delete this line, but it is included here to demonstrate how they would be used if it was needed).

`Dertisch` kitchen classes can have other kitchen classes injected into them. For instance, in the code example above `Images` has `FoodDelivery` injected as it depends upon it to load external images.

In the first `introduce(...)` function above, `SomeCustomer`, `SomeWaiter`, and `SomeHeadChef` are bespoke classes written for the implementing app in question, and the registration function is which they appear creates a `viewController -> presenter <- interactor` relationship. `kitchenStaff` is an optional array in which one lists the sous chef classes that `SomeHeadChef` will need to do their job.

The second `introduce(...)` function above shows the example of a view controller that has no need of a waiter or a head chef, meaning this is a simple page with no dependence on data.

The above code example features the two model classes `SomeSousChef` and `SomeIngredient`. These are bespoke kitchen classes not included in `Dertisch` but written specifically for the implementing app in question. The boilerplate code for `SomeSousChef` looks like this:

	class SomeSousChef: KitchenMember {
		required init(_ kitchenStaff: [String: KitchenMember]?) {}
		var headChef: HeadChefForKitchenMember?
	}

`KitchenMember` defines the two additional properties that `SomeSousChef` must conform to (in addition to the optional functions `startShift()` and `endShift()` defined in `StartShiftProtocol` and `EndShiftProtocol` respectively)

	public protocol KitchenMember: StartShiftProtocol, EndShiftProtocol {
		init(_ kitchenStaff: [String: KitchenMember]?)
		var headChef: HeadChefForKitchenMember? { get set }
	}

A boilerplate `Dertisch` Waiter looks like this:

	class SomeWaiter: Waiter {
		required init(customer: CustomerForWaiter, maitreD: MaitreD, headChef: HeadChefForWaiter?) {}
	}

And finally, a boilerplate `Dertisch` Customer looks like this:

	class SomeCustomer: Customer {
		override func assign(_ waiter: WaiterForCustomer, and sommelier: Sommelier) {}
	}

Customers are the only classes in `Dertisch` to utilise inheritance, each `Dertisch` customer being required to extend the `Customer` class, which itself extends `UIViewController`. The rest of the library, uses `protocols` and `extensions` exclusively.

---
Indepth Documentation
---

There are more elements to `Dertisch` than those described above, but because nobody except myself is known to be using it presently I see no need for greater detail yet. If you would like to know more, please ask.

**note to self** - things to document:

-   Project settings [main target] > General > Deployment Info > Main Interface [leave empty]

---
Developmental Roadmap
---

`Dertisch` is still in beta, and whilst no official timescale exists for ongoing development, presently suggestions are as follows:

-   move to Devops Git branch;
-	make `Customer` and `Waiter` [RxSwift](https://github.com/ReactiveX/RxSwift/) compatible;
-   change the multi-protocol'ed situation so that, say, `Waiter` becomes a single object containing the child objects `WaiterForCustomer`, `WaiterForWaiter`, and `WaiterForHeadChef` (these would be structs/classes that implement protocols rather than protocols thus meaning we could store properties in them, thus possibly removing the need for the Rota);
-   rename Images ingredient;
-	make classes, structs, and protocols that can be made internal and/or final just that;
-   make `Dertisch` a Cocoapod;
-	make utils functions native class extensions instead;
-	move optional `KitchenMembers` into their own repos to minimise the footprint of the core framework;
-   *dry protocols* for metaphorically-named functions and properties, so that injected properties can be cast from, par exemple, a `Waiter` to a `Presenter` at runtime;
-	new `MetricsSousChef` for device-specific numeric constants;
-	new `FirebaseIngredient`;
-	instigate Redux-style 'reducer' process for kitchen classes so they can become structs that overwrite themselves;
-	replace `endShift()` functions with weak vars etc?;
-	force `Freezer` to take `dataModelName` at start up;
-	reintroduce timeout stopwatch to `FoodDelivery`;
-	complete list of MIME types in `FoodDelivery`;
-	create example boilerplate app;
-   remove fatal errors.

---
On the name "Dertisch"
---

In 1984 the German painter Martin Kippenberger painted a portrait entitled "The Mother of Joseph Beuys". Beuys was also a German artist, working principally in sculpture and conceptual pieces, and was a contemporary of Kippenberger. The portrait does not capture the likeness of Beuys' mother, Frau Johanna Beuys. It does not even capture the likeness of a woman. It is said to be a self-portrait, but does not capture the likeness of Kippenberger especially well either. However, it does capture the likeness of someone called "Richard Willis" extremely well. Richard is the author of `Dertisch`, and was born the same year that the real Frau Johanna Beuys died. He is the person behind the various manifestations of the "JosephBeuysMum" username online, and the avatar he uses on these accounts is a cropped thumbnail of Kippenberger's painting.

"Dertisch" means "the table" in Deutsche, and is the name of [an artwork by Joseph Beuys](http://www.artnet.com/artists/joseph-beuys/der-tisch-AzXWfzZdG5Z4npv6LZT_8g2). Given that it is built around the metaphorical notion of serving hot dishes to restaurant customers, from all of Beuys' works `Dertisch` fits excellently as a name.

It also sounds a bit like "Dirtish", which is fun.
