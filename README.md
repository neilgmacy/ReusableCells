# ReusableCells

This is a small utility package that removes excess code when using `UITableView` and `UICollectionView`.

## The Problem

When you want to use a `UITableViewCell` or `UICollectionViewCell` subclass, you need to go through a few boilerplate steps to register and dequeue it.

Usually in an initialiser or in the containing `UIViewController`'s `viewDidLoad` method, you register a `UITableViewCell` or `UICollectionViewCell` subclass that can be dequeued with a unique identifier `String`:

```swift
tableView.register(MyCustomCell.self, forCellReuseIdentifier: "cell")
```

Then, you implement a `UITableViewDataSource` or `UICollectionViewDataSource` which contains the `cellForRowAtIndexPath` or `cellForItemAtIndexPath` method. In this method, you ask the table or collection view to dequeue the reusable cell that can be used for the current item in the data source:

```swift
let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCustomCell
```

You then set the custom properties for that cell:

```swift
cell.titleText = dataObject.title
```

There are a couple of issues with this:

1. You have to specify the reuse identifier twice - once when registering and once when dequeuing. But you could accidentally mismatch cell types and reuse identifiers, or make a spelling error in one place which means the correct cell doesn't get dequeued, or forget to update the dequeue call after changing the reuse identifier in the register call. (This can be mitigated by declaring a constant for each reuse identifier, but if you have multiple cell types, it can become a bit of a list.)
2. The bigger issue is that the cell that you're given back when dequeuing is of the base class type, `UITableViewCell` or `UICollectionViewCell`, and you have to cast that to the custom type that you explicitly registered. So you then get the choice of using an optional cast with `as?`, and adding some handling for when the wrong cell type comes back, or force casting to your custom type using `as!`, as shown in the example above, and letting the app crash if it gets the wrong type back. This shouldn't cause any problems if you do everything perfectly all the time, but if you changed the cell type for that reuse identifier when dequeuing, and forgot to change the cast after registering, your app can crash, just because the type of cell needs to be declared in two separate places.

The whole approach is messy. Reuse identifiers aren't something we typically need to care much about - it's usually more of an implementation detail of the `UITableView`/`UICollectionView`. And considering we explicitly told the `UICollectionView` or `UITableView` what cell type to expect for a given reuse identifier, we should be able to use that cell type implicitly, rather than casting after dequeuing.

## Usage

With `ReusableCells`, there are two simple steps. Conform your `UITableViewCell` or `UICollectionViewCell` to `ReusableView`:

```swift
class MyCustomCell: UITableViewCell, ReusableView {
    // your cell implementation
}
```

And declare the expected cell type when you dequeue your cell:

```swift
let cell: MyCustomCell = tableView.dequeue(for: indexPath)
```

That's it. You never need to specify a reuse identifier, you don't need to register your cell for reuse, and you don't need to deal with casting.

## How It Works

### The `ReusableView` protocol

If we make all of our custom `UITableViewCell` and `UICollectionViewCell` subclasses conform to the `ReusableView` protocol below, they will have a property called `defaultReuseIdentifier` which can be used as the reuse identifier without having to name it explicitly. That means you can avoid copy/paste errors, and don't have to think about what value to give to your reuse identifier. You get a reuse identifier for free, using the class name. But it works even better with the rest of the package.

### `UITableView`/`UICollectionView` extensions

These extensions add a generic method to `UITableView` and `UICollectionView`: `dequeue`. `dequeue` will let you dequeue a cell without having to register it, or having to cast it to your custom type.

Under the hood, it will register cells using the default `reuseIdentifier` from `ReusableView`. It will then handle casting, throwing a `preconditionFailure` if the cast fails. But it shouldn't, because registering the cell for reuse happens at the same time as dequeuing a cell of that type.
