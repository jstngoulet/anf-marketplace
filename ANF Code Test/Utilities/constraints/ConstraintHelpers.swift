//
//  ConstraintHelpers.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import UIKit

/**
 Map a layout side to an Attribute so our helper functions can be properlly scaled
 */
enum LayoutSide {
    
    //  Supported cases of the sides permitted
    case left
        , `right`
        , top
        , bottom
        , none
    
    //  Maps the curernt side to a layout attribute
    var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .left:     return .left
        case .right:    return .right
        case .top:      return .top
        case .bottom:   return .bottom
        case .none:     return .notAnAttribute
        }
    }
}

/**
 Map a layout dimension to an attribute so our helper functions can properlly be scaled
 */
enum LayoutDimension {
    
    //  Supported cases for dimensions
    case height
        , width
    
    //  Maps the current dimension to an attribute dimension
    var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .height:   return .height
        case .width:    return .width
        }
    }
}

/**
 The series of below extensions are constraint helper functions, similar to what can
 be found in popular constraint libraries. They are rather simple to create and allow
 for a mass reduction in code as components are added to views
 
 While not all functions are used, these functions are building blocks to scalable helper
 functions that build of one another and allow the modification at a later time.
 */
extension UIView {
    
    /// Helper function to pin the current view to the side of another view, with an optional offset
    /// - Parameters:
    ///   - side:           The side of the view to pin to
    ///   - view:           The view that the current view should pin to
    ///   - offset:         The offset, when permitted
    /// - Returns:          The constructed constraint, so it can be later removed
    @discardableResult
    func pinTo(
        side: LayoutSide,
        of view: UIView
        , with offset: CGFloat = 0
    ) -> NSLayoutConstraint? {
        pin(
            side: side,
            toSide: side,
            of: view,
            with: offset
        )
    }
    
    /// Allows to pin of 2 different sides, instead of a single side on the same view
    /// - Parameters:
    ///   - side:           The a side
    ///   - toSide:         The b side
    ///   - view:           The view in which the current view is being pinned
    ///   - offset:         The offset/inset used to pin to the provided side
    /// - Returns:          The constructed constraint, so it can be later removed
    @discardableResult
    func pin(
        side: LayoutSide
        , toSide: LayoutSide
        , of view: UIView
        , with offset: CGFloat = 0
    ) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constr = NSLayoutConstraint(
            item: self,
            attribute: side.attribute,
            relatedBy: .equal,
            toItem: view,
            attribute: toSide.attribute,
            multiplier: 1,
            constant: offset
        )
        constr.isActive = true
        return constr
    }
    
    /// Uses the above herlper methods to pin the current view
    /// to all sides of the current view's superview.
    ///
    /// - Warning:          Current view must be added to parent in order to work
    /// - Parameter inset:  The current inset for the pinning
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func pinToSuperview(
        with inset: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        pinToSuperview(
            with: inset,
            except: .none
        )
    }
    
    /// Allows the view to be pinned to a superview, however, can exlcude one side
    /// This is helpful when stacking from the side and we do not know the other boundry
    /// due to other content shown
    ///
    /// - Parameters:
    ///   - inset:          The inset of the view in the parent
    ///   - except:         The side to exclude
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func pinToSuperview(
        with inset: UIEdgeInsets = .zero
        , except: LayoutSide
    ) -> [NSLayoutConstraint] {
        guard let superview else { return [] }
        
        return [
            except != .left
                ? pinTo(side: .left, of: superview, with: inset.left)
                : nil,
            except != .right
                ? pinTo(side: .right, of: superview, with: -inset.right)
                : nil,
            except != .top
                ? pinTo(side: .top, of: superview, with: inset.top)
                : nil,
            except != .bottom
                ? pinTo(side: .bottom, of: superview, with: -inset.bottom)
                : nil
        ].compactMap({ $0 })
    }
    
    /// This function can be used to stack a view under another view. This is donw
    /// by pinning the top, left and right sides to the view diretly above it (the
    /// top of the child view is pinned to the bottom of the provided view)
    ///
    /// - Parameters:
    ///   - view:           The view to pin under
    ///   - insets:         The insets to pin under and around from the passed in view
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func stackUnder(
        view: UIView
        , insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        [
            pinTo(side: .left, of: view, with: insets.left)
            , pinTo(side: .right, of: view, with: -insets.right)
            , pin(side: .top, toSide: .bottom, of: view, with: insets.top)
        ].compactMap({ $0 })
    }
    
    /// Similar to the above function, this function is set to stack above the
    /// provided view, instead of below. This is not always a superview, so a view
    /// must be passed in
    ///
    /// - Parameters:
    ///   - view:           The view to pin directly above
    ///   - insets:         The insets to pin directly above to
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func stackAbove(
        view: UIView
        , insets: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        [
            pinTo(side: .left, of: view, with: insets.left)
            , pinTo(side: .right, of: view, with: -insets.right)
            , pin(side: .bottom, toSide: .top, of: view, with: insets.bottom)
        ].compactMap({ $0 })
    }
    
}

//  MARK: - Dimension based constraints
extension UIView {
    
    /// Sets the provided dimensions to the current view
    /// - Parameters:
    ///   - dimension:      The current dimension we are altering
    ///   - size:           The current size we are updating the deimension to
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func set(
        dimension: LayoutDimension,
        to size: CGFloat
    ) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constr = NSLayoutConstraint(
            item: self,
            attribute: dimension.attribute,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 0,
            constant: size
        )
        constr.isActive = true
        return constr
    }
    
    /// Sets the current size of the view, with constraints
    /// - Parameter size:   The size for the current view
    /// - Returns:          The list of constraints used to create the size
    @discardableResult
    func set(
        size: CGSize
    ) -> [NSLayoutConstraint] {
        [
            set(dimension: .height, to: size.height)
            , set(dimension: .width, to: size.width)
        ]
    }
}

//  MARK: - Axis based constraints
extension UIView {
    
    /// Pin the view to the horizontal axis
    /// - Parameter view:   The current view to match the axist to
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func alignHorizontally(in view: UIView) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constr = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        constr.isActive = true
        return constr
    }
    
    /// Pin the view to the vertical axis
    /// - Parameter view:   The current view to match the axist to
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func alignVeritcally(in view: UIView) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constr = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        constr.isActive = true
        return constr
    }
    
    /// Align both the horizontal and vertical axis
    /// - Parameter view:   The current view to match the axist to
    /// - Returns:          The set of constraints created from the pinning of views
    @discardableResult
    func alignInCenter(in view: UIView) -> [NSLayoutConstraint] {
        [
            alignVeritcally(in: view)
            , alignHorizontally(in: view)
        ].compactMap({ $0 })
    }
    
    /// Remove the provided constraints from being active on the view
    /// - Parameter constraints: The list of constraints we are deactiving
    func remove(constraints: [NSLayoutConstraint])
    { constraints.forEach({ $0.remove()} )}
    
}

//  MARK: - Constraint specific helpers to remove from view
extension NSLayoutConstraint {
    
    /// Helper function to disable the current constraint
    func remove()
    { isActive = false }
    
}
