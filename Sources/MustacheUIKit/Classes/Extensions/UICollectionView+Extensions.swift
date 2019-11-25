import UIKit

public extension UICollectionView {

    /**
    Convenience method to register UICollectionViewCell for UICollectionView

    - parameters:
        - cell: T.Type
    */
    func register<T: UICollectionViewCell>(cell: T.Type) {
        self.register(cell, forCellWithReuseIdentifier: cell.identifier)
    }

    /**
    Convenience method to dequeue UICollectionViewCell for UICollectionView

    - returns:
    T

    - parameters:
        - cell: T.Type
        - for: IndexPath

    */
    func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }

    /**
    Convenience method to register UICollectionReusableView for UICollectionView

    - parameters:
        - supplementaryView: T.Type
        - type: SupplementaryViewType

    */
    func register<T: UICollectionReusableView>(supplementaryView: T.Type, type: SupplementaryViewType) {
        self.register(supplementaryView, forSupplementaryViewOfKind: type.kind, withReuseIdentifier: supplementaryView.identifier)
    }

    /**
    Convenience method to dequeue UICollectionReusableView for UICollectionView

    - returns:
    T

    - parameters:
        - cell: T.Type
        - type: SupplementaryViewType
        - for: IndexPath

    */
    func dequeue<T: UICollectionReusableView>(supplementaryView: T.Type, type: SupplementaryViewType, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: type.kind, withReuseIdentifier: supplementaryView.identifier, for: indexPath) as! T
    }

    /**
    Convenience method to register UICollectionViewCell for UICollectionView

    - parameters:
        - nib: T.Type

    */
    func register<T: UICollectionViewCell>(nib: T.Type) {
        let uiNib = UINib(nibName: nib.nibName, bundle: nil)
        self.register(uiNib, forCellWithReuseIdentifier: nib.identifier)
    }

    /**
    Convenience method to register UICollectionReusableView for UICollectionView

    - parameters:
        - supplementaryNib: T.Type
        - nib: SupplementaryViewType
    */
    func register<T: UICollectionReusableView>(supplementaryNib: T.Type, type: SupplementaryViewType) {
        let uiNib = UINib(nibName: supplementaryNib.nibName, bundle: nil)
        self.register(uiNib, forSupplementaryViewOfKind: type.kind, withReuseIdentifier: supplementaryNib.nibName)
    }
}

/// Convenience enum for UICollectionView supplementary view
public enum SupplementaryViewType {

    case header, footer

    var kind: String {
        switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}
