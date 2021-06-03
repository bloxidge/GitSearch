//
//  UIView+Constraints.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit

protocol Anchorable {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UILayoutGuide: Anchorable {}
extension UIView: Anchorable {}


extension UIView {
    
    enum ConstraintEdge {
        case top
        case bottom
        case leading
        case trailing
    }
    
    @discardableResult
    func autoPinToSuperview(insetBy insets: UIEdgeInsets = .zero, excludingEdges: [ConstraintEdge] = []) -> [NSLayoutConstraint] {
        return autoPin(toView: superview!, insetBy: insets, excludingEdges: excludingEdges)
    }
    
    @discardableResult
    func autoPinToSafeArea(insetBy insets: UIEdgeInsets = .zero, excludingEdges: [ConstraintEdge] = []) -> [NSLayoutConstraint] {
        return autoPin(toView: superview!.safeAreaLayoutGuide, insetBy: insets, excludingEdges: excludingEdges)
    }

    @discardableResult
    func autoPin(toView viewOrLayoutGuide: Anchorable, insetBy insets: UIEdgeInsets = .zero, excludingEdges: [ConstraintEdge] = []) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        
        if !excludingEdges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: viewOrLayoutGuide.topAnchor, constant: insets.top))
        }
        if !excludingEdges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: viewOrLayoutGuide.bottomAnchor, constant: -insets.bottom))
        }
        if !excludingEdges.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: viewOrLayoutGuide.leadingAnchor, constant: insets.left))
        }
        if !excludingEdges.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: viewOrLayoutGuide.trailingAnchor, constant: -insets.right))
        }
        constraints.forEach { $0.isActive = true }
        
        return constraints
    }
    
    @discardableResult
    func autoPin(toSuperviewEdge edge: ConstraintEdge, insetBy inset: CGFloat = 0.0) -> NSLayoutConstraint {
        return autoPin(toView: superview!, edge: edge, insetBy: inset)
    }
    
    @discardableResult
    func autoPin(toSafeAreaEdge edge: ConstraintEdge, insetBy inset: CGFloat = 0.0) -> NSLayoutConstraint {
        return autoPin(toView: superview!.safeAreaLayoutGuide, edge: edge, insetBy: inset)
    }

    @discardableResult
    func autoPin(toView viewOrLayoutGuide: Anchorable, edge: ConstraintEdge, insetBy inset: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint: NSLayoutConstraint
        
        switch edge {
        case .top:
            constraint = topAnchor.constraint(equalTo: viewOrLayoutGuide.topAnchor, constant: inset)
        case .bottom:
            constraint = bottomAnchor.constraint(equalTo: viewOrLayoutGuide.bottomAnchor, constant: -inset)
        case .leading:
            constraint = leadingAnchor.constraint(equalTo: viewOrLayoutGuide.leadingAnchor, constant: inset)
        case .trailing:
            constraint = trailingAnchor.constraint(equalTo: viewOrLayoutGuide.trailingAnchor, constant: -inset)
        }
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func autoCenterInSuperview() -> [NSLayoutConstraint] {
        return [autoCenterXInSuperview(), autoCenterYInSuperview()]
    }
    
    @discardableResult
    func autoCenterXInSuperview() -> NSLayoutConstraint {
        return autoCenterX(in: superview!)
    }

    @discardableResult
    func autoCenterYInSuperview() -> NSLayoutConstraint {
        return autoCenterY(in: superview!)
    }

    @discardableResult
    func autoCenterInSafeArea() -> [NSLayoutConstraint] {
        return [autoCenterXInSafeArea(), autoCenterYInSafeArea()]
    }

    @discardableResult
    func autoCenterXInSafeArea() -> NSLayoutConstraint {
        return autoCenterX(in: superview!.safeAreaLayoutGuide)
    }

    @discardableResult
    func autoCenterYInSafeArea() -> NSLayoutConstraint {
        return autoCenterY(in: superview!.safeAreaLayoutGuide)
    }
    
    @discardableResult
    func autoCenterX(in viewOrLayoutGuide: Anchorable) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = centerXAnchor.constraint(equalTo: viewOrLayoutGuide.centerXAnchor)
        centerXConstraint.isActive = true
        
        return centerXConstraint
    }

    @discardableResult
    func autoCenterY(in viewOrLayoutGuide: Anchorable) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let centerYConstraint = centerYAnchor.constraint(equalTo: viewOrLayoutGuide.centerYAnchor)
        centerYConstraint.isActive = true
        
        return centerYConstraint
    }

    @discardableResult
    func autoSetSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [autoSetWidth(size.width), autoSetHeight(size.height)]
    }
    
    @discardableResult
    func autoSetWidth(_ width: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true

        return widthConstraint
    }

    @discardableResult
    func autoSetHeight(_ height: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true

        return heightConstraint
    }
    
    @discardableResult
    func autoSetWidth(relativeTo view: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
        widthConstraint.isActive = true

        return widthConstraint
    }

    @discardableResult
    func autoSetHeight(relativeTo view: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        heightConstraint.isActive = true

        return heightConstraint
    }

    @discardableResult
    func autoSetAspectRatio(matching size: CGSize) -> NSLayoutConstraint {
        guard size.width > 0 && size.height > 0 else {
            fatalError("setAspectRatio requires non-zero width and height: \(size)")
        }
        return autoSetAspectRatio(size.width / size.height)
    }

    @discardableResult
    func autoSetAspectRatio(_ aspectRatio: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let aspectRatioConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        aspectRatioConstraint.isActive = true

        return aspectRatioConstraint
    }
}
