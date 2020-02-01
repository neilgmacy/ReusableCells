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

    func dequeue<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: ReusableView {
        register(T.self) // this removes the need to explicitly register a view
        guard let reusableView = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            preconditionFailure("Could not dequeue view with identifier: \(T.defaultReuseIdentifier)")
        }

        return reusableView
    }
}
