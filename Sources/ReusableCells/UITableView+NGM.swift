import UIKit

/**
 Extension for easily dequeuing `UITableViewCell`s and `UITableViewHeaderFooterView`s.
 */
public extension UITableView {

    // MARK: - UITableViewCell

    /**
     Convenience method to register a `UITableViewCell` for reuse. This is called automatically by `dequeue`.
     */
    internal func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    /**
     Dequeue a `UITableViewCell` for this `UITableView`.

     This removes the need to specify reuse identifiers or even register a cell with a `UITableView`.

     All you need to do is conform your custom cell to `ReusableView`, and when you need to dequeue a cell, declare the type of cell that you want. For example, if you want to dequeue a cell of type `InfoCell`, you simply need this line:
     ```
     let cell: InfoCell = tableView.dequeue(for: indexPath)
     ```
     */
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self) // this removes the need to explicitly register a cell
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    // MARK: - UITableViewHeaderFooterView

    /**
     Convenience method to register a `UITableViewHeaderFooterView` for reuse. This is called by default by `dequeue`.
     */
    internal func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    /**
     Dequeue a `UITableViewHeaderFooterView` for this `UITableView`.

     This removes the need to specify reuse identifiers or even register a `UITableViewHeaderFooterView` with a `UITableView`.

     All you need to do is conform your custom header view to `ReusableView`, and when you need to dequeue it, declare the type of the class that you want. For example, if you want to dequeue a cell of type `InfoHeader`, you simply need this line:
     ```
     let header: InfoHeader = tableView.dequeue()
     ```
     */
    func dequeue<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: ReusableView {
        register(T.self) // this removes the need to explicitly register a view
        guard let reusableView = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            preconditionFailure("Could not dequeue view with identifier: \(T.defaultReuseIdentifier)")
        }

        return reusableView
    }
}
