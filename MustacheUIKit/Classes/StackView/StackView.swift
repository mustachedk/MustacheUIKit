//
//  StackView.swift
//  helpers
//
//  Created by Tommy Hinrichsen on 01/03/2018.
//  Copyright © 2018 EazyIT. All rights reserved.
//

import Foundation
import UIKit

open class StackView: UIView {

    private (set) var subviewsOrdered: [UIView] = []
    fileprivate var bottomConstraint: Constraint?

    fileprivate let borders: UIRectEdge
    fileprivate let dividerColor: UIColor?

    public init(_ borders: UIRectEdge = [], dividerColor: UIColor? = nil) {
        self.borders = borders
        self.dividerColor = dividerColor
        super.init(frame: .zero)
        self.configureView()
    }

    fileprivate func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override open func addSubview(_ view: UIView) {
        super.addSubview(view)

        let lastView = self.subviewsOrdered.last?.snp.bottom ?? self.snp.bottom

        if subviewsOrdered.count == 0 {

            if self.borders.contains(.top) {
                let divider = UIView()
                divider.backgroundColor = self.dividerColor
                super.addSubview(divider)
                divider.snp.makeConstraints { maker in
                    maker.top.equalTo(self)
                    maker.left.right.equalTo(self)
                    maker.height.equalTo(0.5)
                }
                view.snp.makeConstraints { maker in
                    maker.top.equalTo(divider.snp.bottom)
                    maker.left.right.equalTo(self)
                    self.bottomConstraint = maker.bottom.equalTo(lastView).constraint
                }
            } else {
                view.snp.makeConstraints { maker in
                    maker.left.top.right.equalTo(self)
                    self.bottomConstraint = maker.bottom.equalTo(lastView).constraint
                }
            }
        } else {

            let divider = UIView()
            divider.backgroundColor = self.dividerColor
            super.addSubview(divider)
            divider.snp.makeConstraints { maker in
                maker.top.equalTo(lastView)
                maker.left.right.equalTo(self)
                maker.height.equalTo(0.5)
            }

            self.bottomConstraint?.deactivate()

            view.snp.makeConstraints { maker in
                maker.top.equalTo(divider.snp.bottom)
                maker.left.right.equalTo(self)
                self.bottomConstraint = maker.bottom.equalTo(self).constraint
            }
        }

        self.subviewsOrdered.append(view)
    }

    open func clearSubviews() {
        self.subviews.forEach { view in view.removeFromSuperview() }
        self.subviewsOrdered.removeAll()
        self.bottomConstraint = nil
    }

    public required init?(coder: NSCoder) {fatalError("Can only be initiated from code") }

}
