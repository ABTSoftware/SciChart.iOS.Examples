//
//  Created by Kateryna Gridina.
//  Copyright (c) gridNA. All rights reserved.
//  Latest version can be found at https://github.com/gridNA/GNAContextMenu
//

import UIKit

public class GNAMenuItem: UIView {
    
    public var itemId: String?
    public var angle: CGFloat = 0
    public var defaultLabelMargin: CGFloat = 6
    
    private var titleView: UIView?
    private var titleLabel: UILabel?
    private var menuIcon: UIImageView!
    private var titleText: String?
    private var activeMenuIcon: UIImageView?
    
    public convenience init(icon: UIImage, activeIcon: UIImage?, title: String?) {
        let frame = CGRect(x: 0, y: 0, width: 55, height: 55)
        self.init(icon: icon, activeIcon: activeIcon, title: title, frame: frame)
    }
    
    public init(icon: UIImage, activeIcon: UIImage?, title: String?, frame: CGRect) {
        super.init(frame: frame)
        menuIcon = createMenuIcon(withImage: icon)
        if let aIcon = activeIcon {
            activeMenuIcon = createMenuIcon(withImage: aIcon)
        }
        if let t = title {
            createLabel(withTitle: t)
        }
        activate(shouldActivate: false)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(withTitle title: String,
                            fontSize: CGFloat? = 11.0,
                            color: UIColor? = .white,
                            bgColor: UIColor? = .black) {
        titleLabel = createTitleLabel(withTitle: title, fontSize: fontSize, color: color)
        titleView = createTitleView(withColor: bgColor)
        updateTitlePositions()
        titleView!.addSubview(titleLabel!)
        addSubview(titleView!)
    }
    
    private func createTitleLabel(withTitle title: String,
                                  fontSize: CGFloat? = 11.0,
                                  color: UIColor? = .white) -> UILabel {
        let itemTitleLabel = UILabel()
        itemTitleLabel.font = UIFont.systemFont(ofSize: fontSize ?? 11, weight: 1)
        itemTitleLabel.textColor = color
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.text = title
        return itemTitleLabel
    }
    
    private func createTitleView(withColor color: UIColor?) -> UIView {
        let itemTitleView = UIView()
        itemTitleView.backgroundColor = color
        itemTitleView.alpha = 0.7
        itemTitleView.layer.cornerRadius = 5
        return itemTitleView
    }
    
    private func setupLabelPosition() {
        guard let tLabel = titleLabel else { return }
        tLabel.sizeToFit()
        tLabel.center = CGPoint(x: (tLabel.frame.width + defaultLabelMargin)/2, y: tLabel.frame.height/2)
    }
    
    private func setupTitleViewPosition() {
        guard let tView = titleView, let tLabel = titleLabel else { return }
        tView.frame = CGRect(origin: .zero, size: CGSize(width: tLabel.frame.width + defaultLabelMargin, height: tLabel.frame.height))
    }
    
    private func updateTitlePositions() {
        setupLabelPosition()
        setupTitleViewPosition()
    }
    
    private func createMenuIcon(withImage image: UIImage) -> UIImageView {
        let iconView = UIImageView(image: image)
        iconView.frame = self.bounds
        iconView.contentMode = .scaleAspectFit
        self.addSubview(iconView)
        return iconView
    }
    
    private func showHideTitle(toShow: Bool) {
        guard let tView = titleView else { return }
        tView.isHidden = !toShow
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: [], animations: {
            tView.center = CGPoint(x: self.frame.width/2, y: -(self.titleLabel?.frame.height ?? 0))
        }, completion: nil)
    }
    
    public func activate(shouldActivate: Bool) {
        menuIcon.isHidden = shouldActivate
        activeMenuIcon?.isHidden = !shouldActivate
        showHideTitle(toShow: shouldActivate)
    }
    
    public func changeTitleLabel(withLabel label: UILabel) {
        let labelText = label.text ?? titleLabel?.text
        titleLabel?.removeFromSuperview()
        titleLabel = label
        titleLabel?.text = labelText
        titleView?.addSubview(titleLabel!)
        updateTitlePositions()
    }
    
    public func changeTitleView(withView view: UIView) {
        titleView?.removeFromSuperview()
        titleView = view
        titleView?.addSubview(titleLabel ?? UIView())
        addSubview(titleView!)
        showHideTitle(toShow: false)
        updateTitlePositions()
    }
    
    public func changeTitle(withTitle title: String) {
        titleLabel?.text = title
        updateTitlePositions()
    }
    
    public func changeIcon(withIcon icon: UIImage) {
        menuIcon.removeFromSuperview()
        menuIcon = createMenuIcon(withImage: icon)
    }
    
    public func changeActiveIcon(withIcon icon: UIImage) {
        activeMenuIcon?.removeFromSuperview()
        activeMenuIcon = createMenuIcon(withImage: icon)
    }
}
