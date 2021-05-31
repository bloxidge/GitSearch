//
//  DesignableView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable
    override var cornerRadius: CGFloat { didSet {} }
    
    @IBInspectable
    override var borderWidth: CGFloat { didSet {} }
    
    @IBInspectable
    override var borderColor: UIColor? { didSet {} }
    
    @IBInspectable
    override var shadowRadius: CGFloat { didSet {} }
    
    @IBInspectable
    override var shadowOpacity: Float { didSet {} }
    
    @IBInspectable
    override var shadowOffset: CGPoint { didSet {} }
    
    @IBInspectable
    override var shadowColor: UIColor? { didSet {} }
}

extension UIView {
    
    // MARK: - Border
    
    @objc var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @objc var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @objc var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    // MARK: - Shadow
    
    @objc var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @objc var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @objc var shadowOffset: CGPoint {
        get { layer.shadowOffset.asPoint }
        set { layer.shadowOffset = newValue.asSize }
    }
    
    @objc var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

fileprivate extension CGSize {
    var asPoint: CGPoint { .init(x: self.width, y: self.height) }
}

fileprivate extension CGPoint {
    var asSize: CGSize { .init(width: self.x, height: self.y) }
}
