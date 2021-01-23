import UIKit

open class ExpandingTableView: UITableView {

    @IBOutlet open weak var heightConstraint: NSLayoutConstraint?

    override open func reloadData() {

        guard let heightConstraint = self.heightConstraint, heightConstraint.priority.rawValue < 750  else { return }

        for section in 0..<(self.dataSource?.numberOfSections?(in: self) ?? 1) {

            let headerHeight = (self.delegate?.tableView?(self, heightForHeaderInSection: section)) ?? self.sectionHeaderHeight
            height += headerHeight

            for row in 0..<(self.dataSource?.tableView(self, numberOfRowsInSection: section) ?? 0) {
                let rowHeight = (self.delegate?.tableView?(self, heightForRowAt: IndexPath(row: row, section: section))) ?? self.rowHeight
                height += rowHeight
            }

        }

        heightConstraint.constant = height + self.contentInset.top + self.contentInset.bottom

        super.reloadData()
        self.setNeedsLayout()
    }

    override open func layoutSubviews() {
      super.layoutSubviews()
      self.isScrollEnabled = (self.contentSize.height > self.frame.height)
    }
    
}
