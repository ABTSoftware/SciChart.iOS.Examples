//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//

import UIKit

enum Direction {
    case left
    case right
    case middle
    case up
    case down
}

@objc public protocol GNAMenuItemDelegate {
    @objc optional func menuItemWasPressed(_ menuItem: GNAMenuItem, info: [String: Any]?)
    @objc optional func menuItemActivated(_ menuItem: GNAMenuItem, info: [String: Any]?)
    @objc optional func menuItemDeactivated(_ menuItem: GNAMenuItem, info: [String: Any]?)
}

open class GNAMenuView: UIView {
    
    open weak var delegate: GNAMenuItemDelegate?
    open var additionalInfo: [String: Any]?
    
    private var distanceToTouchPoint: CGFloat = 20
    private var touchPoint: CGPoint?
    private var menuItemsArray: Array<GNAMenuItem>!
    private var currentDirection: (Direction, Direction)?
    private var currentActiveItem: GNAMenuItem?
    private var touchPointImage: UIImageView!
    private var angleCoef: CGFloat!
    private var xDistanceToItem: CGFloat?
    private var yDistanceToItem: CGFloat?
    
    // MARK: Init section
    
    private init(touchPointSize: CGSize, touchImage: UIImage?) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: touchPointSize))
        self.touchPointImage = UIImageView(image: touchImage)
        self.touchPointImage.contentMode = UIViewContentMode.scaleAspectFit
        self.touchPointImage.frame = self.bounds
        addSubview(self.touchPointImage)
    }
    
    public convenience init(menuItems: Array<GNAMenuItem>) {
        self.init(touchPointSize: CGSize(width: 70, height: 70), touchImage: nil, menuItems: menuItems)
    }
    
    public convenience init(touchPointSize: CGSize, touchImage: UIImage?, menuItems: Array<GNAMenuItem>) {
        self.init(touchPointSize: touchPointSize, touchImage: touchImage)
        menuItemsArray = menuItems
        angleCoef = 90.0 / CGFloat(menuItemsArray.count - 1)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    open func changeDistanceToTouchPoint(withDistance distance: CGFloat) {
        distanceToTouchPoint = distance
    }
    
    public func handleGesture(_ gesture: UILongPressGestureRecognizer, inView: UIView) {
        let point = gesture.location(in: inView)
        if(gesture.state == .began) {
            showMenuView(inView: inView, atPoint: point)
        } else if(gesture.state == .changed) {
            slideToPoint(point)
        } else if(gesture.state == .ended) {
            dismissMenuView(point)
        }
    }
    
    // MARK: Private methods
    
    private func showMenuView(inView view: UIView, atPoint: CGPoint) {
        view.addSubview(self)
        frame = (UIApplication.shared.keyWindow?.subviews.first)?.bounds ?? .zero
        touchPoint = atPoint
        touchPointImage.center = atPoint
        currentDirection = calculateDirections(menuItemsArray[0].frame.width)
        setupMenuView()
    }
    
    private func slideToPoint(_ point: CGPoint) {
        detectPoint(point, action: { [weak self] (menuItem: GNAMenuItem) in
            self?.activateItem(menuItem)
        })
    }
    
    private func dismissMenuView(_ point: CGPoint) {
        detectPoint(point, action: { (menuItem: GNAMenuItem) in
            delegate?.menuItemWasPressed?(menuItem, info: additionalInfo)
        })
        deactivateCurrentItem()
        removeFromSuperview()
    }
    
    private func setupMenuView() {
        calculateDistanceToItem()
        resetItemsPosition()
        anglesForDirection()
        for item in menuItemsArray {
            addSubview(item)
            animateItem(item)
        }
    }
    
    private func resetItemsPosition() {
        menuItemsArray.forEach({
            $0.center = self.touchPointImage.center
        })
    }
    
    private func calculateDistanceToItem() {
        xDistanceToItem = touchPointImage.frame.width/2 + distanceToTouchPoint + CGFloat(menuItemsArray[0].frame.width/2)
        yDistanceToItem = touchPointImage.frame.height/2 + distanceToTouchPoint + CGFloat(menuItemsArray[0].frame.height/2)
    }
    
    private func detectPoint(_ point: CGPoint, action: (_ menuItem: GNAMenuItem)->Void) {
        let p = convert(point, from: superview)
        var isActiveButton = false
        for subview in subviews {
            if subview.frame.contains(p) && subview is GNAMenuItem {
                isActiveButton = true
                action(subview as! GNAMenuItem)
            }
        }
        if let item = currentActiveItem, !isActiveButton {
            if touchPointImage.frame.contains(point) {
                deactivateItem(item)
            }
        }
    }
    
    private func calculateDirections(_ menuItemWidth: CGFloat) -> (Direction, Direction) {
        guard let superViewFrame = superview?.frame else { return (.middle, .middle) }
        let touchWidth = distanceToTouchPoint +  menuItemWidth + touchPointImage.frame.width
        let touchHeight = distanceToTouchPoint + menuItemWidth + touchPointImage.frame.height
        let horisontalDirection = determineHorisontalDirection(touchWidth, superViewFrame: superViewFrame)
        let verticalDirection = determineVerticalDirection(touchHeight, superViewFrame: superViewFrame)
        return(verticalDirection, horisontalDirection)
    }
    
    private func determineVerticalDirection(_ size: CGFloat, superViewFrame: CGRect) -> Direction {
        guard let tPoint = touchPoint else { return .middle }
        let isBotomBorderOfScreen = tPoint.y + size > UIScreen.main.bounds.height
        let isTopBorderOfScreen = tPoint.y - size < 0
        if  isTopBorderOfScreen {
            return .down
        } else if isBotomBorderOfScreen {
            return .up
        } else {
            return .middle
        }
    }
    
    private func determineHorisontalDirection(_ size: CGFloat, superViewFrame: CGRect) -> Direction {
        guard let tPoint = touchPoint else { return .middle }
        let isRightBorderOfScreen = tPoint.x + size > UIScreen.main.bounds.width
        let isLeftBorderOfScreen = tPoint.x - size < 0
        if isLeftBorderOfScreen {
            return .right
        } else if  isRightBorderOfScreen {
            return .left
        } else {
            return .middle
        }
    }
    
    private func anglesForDirection() {
        guard let direction = currentDirection else { return }
        switch (direction) {
        case (.down, .left), (.down, .middle):
            negativeQuorterAngles(startAngle: 90)
            break
        case (.down, .right):
            positiveQuorterAngle(startAngle: 0)
            break
        case (.middle, .left), (.middle, .middle), (.up, .left), (.up, .middle):
            negativeQuorterAngles(startAngle: 180)
            break
        case (.middle, .right), (.up, .right):
            positiveQuorterAngle(startAngle: 270)
            break
        default:
            break
        }
    }
    
    private func negativeQuorterAngles(startAngle: CGFloat) {
        let angle = startAngle + 90
        menuItemsArray.forEach({ item in
            let index = CGFloat(menuItemsArray.index(of: item)!)
            item.angle = (angle - angleCoef * index) / 180 * CGFloat(M_PI)
        })
    }
    
    private func positiveQuorterAngle(startAngle: CGFloat) {
        menuItemsArray.forEach({ item in
            let index = CGFloat(menuItemsArray.index(of: item)!)
            item.angle = (startAngle + angleCoef * index) / 180.0 * CGFloat(M_PI)
        })
    }
    
    private func animateItem(_ menuItem: GNAMenuItem) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
                menuItem.center = self.calculatePointCoordiantes(menuItem.angle)
            }, completion: nil)
    }
    
    private func calculatePointCoordiantes(_ angle: CGFloat) -> CGPoint {
        guard let tPoint = touchPoint else { return .zero }
        if xDistanceToItem == nil || yDistanceToItem == nil {
            calculateDistanceToItem()
        }
        let x = tPoint.x + cos(angle) * (xDistanceToItem ?? 1)
        let y = tPoint.y + sin(angle) * (yDistanceToItem ?? 1)
        return CGPoint(x: x, y: y)
    }

    // MARK: Buttons actiovation/deactivation
    
    private func activateItem(_ menuItem: GNAMenuItem) {
        if currentActiveItem != menuItem {
            deactivateCurrentItem()
            currentActiveItem = menuItem
            distanceToTouchPoint = distanceToTouchPoint + CGFloat(15.0)
            setupPositionAnimated(menuItem)
            menuItem.activate(shouldActivate: true)
            delegate?.menuItemActivated?(menuItem, info: additionalInfo)
        }
    }
    
    private func deactivateItem(_ menuItem: GNAMenuItem) {
        if let _ = currentActiveItem {
            currentActiveItem = nil
            distanceToTouchPoint = distanceToTouchPoint - CGFloat(15.0)
            setupPositionAnimated(menuItem)
            menuItem.activate(shouldActivate: false)
            delegate?.menuItemDeactivated?(menuItem, info: additionalInfo)
        }
    }
    
    private func deactivateCurrentItem() {
        if let item = currentActiveItem {
            deactivateItem(item)
        }
    }
    
    private func setupPositionAnimated(_ menuItem: GNAMenuItem) {
        calculateDistanceToItem()
        UIView.animate(withDuration: 0.2, animations: {
             menuItem.center = self.calculatePointCoordiantes(menuItem.angle)
        })
    }
}
