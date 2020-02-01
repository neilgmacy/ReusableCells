import UIKit

/**
 Extension for easily dequeuing `UICollectionViewCell`s.
 */
public extension UICollectionView {

    /**
     Convenience method to register a `UICollectionViewCell` for reuse. This is called automatically by `dequeue`.
     */
    internal func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    /**
     Dequeue a `UICollectionViewCell` for this `UICollectionView`.

     This removes the need to specify reuse identifiers or even register a cell with a `UICollectionView`.

     All you need to do is conform your custom cell to `ReusableView`, and when you need to dequeue a cell, declare the type of cell that you want. For example, if you want to dequeue a cell of type `InfoCell`, you simply need this line:
     ```
     let cell: InfoCell = collectionView.dequeue(for: indexPath)
     ```
     */
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self) // this removes the need to explicitly register a cell
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}
