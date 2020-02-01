import UIKit

/**
 Conform your `UITableViewCell` or `UICollectionViewCell` to `ReusableView` to get easy cell management through `dequeue`.
 */
public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
