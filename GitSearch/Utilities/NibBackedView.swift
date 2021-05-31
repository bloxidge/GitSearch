//
//  NibBackedView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 28/09/2020.
//

import UIKit

/**
 Conforms to loading a custom view backed by a `.xib` file
 
 Create a .xib file with the same name as your view class, and set
 the class name of `File's Owner` in Interface Builder to match your
 custom view's class name.
 
 Conform to this protocol, and call `loadFromNib()` from your
 custom view's initialiser.
 
 The first (usually the only) top-level View object will be assigned
 to your nibView property, and you can set up IBOutlet, IBOutletCollection,
 and IBAction references to your custom class in the usual manner.
 */
protocol NibBackedView: AnyObject {}

extension NibBackedView where Self: UIView {
    /**
     Load your custom view's nib.
     
     You MUST call this method from BOTH of the custom `UIView` initialisers:
     * `init(coder:)` is used when instantiating your view from another nib or a Storyboard.
     * `init(frame:)` is used when instantiating your view programatically and also when
     Interface Builder renders custom views.
     
     Marking your view class as `@IBDesignable` as usual will render the
     `draw(rect:)` content as well as the subviews added from the nib.
     
     `awakeFromNib()` will be called on your view in all cases, so this is
     the best place to do your setup. The subviews and IBOutlets will be
     configured at the point that `awakeFromNib()` is called.
     
     This will load the `UINib` whose name matches your class name, from
     the `Bundle` which belongs with your class. Its first object, which
     must be a `UIView`, will be added to your (usually storyboard-created)
     view as a subview.
     */
    @discardableResult func loadFromNib() -> UIView {
        let name = String(describing: Self.self)
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: name, bundle: bundle)
        let objects = nib.instantiate(withOwner: self, options: nil)

        guard let view = objects.first as? UIView else {
            let error = NibLoadError.viewObjectMissing(className: name, bundle: bundle, objects: objects)
            fatalError(error.localizedDescription)
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
        
        return view
    }
}

enum NibLoadError: Error {
    /// The first object instantiated by the UINib was not a UIView
    case viewObjectMissing(className: String, bundle: Bundle, objects: [Any])
}
