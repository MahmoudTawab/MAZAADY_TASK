//
//  CHIPageControlChimayo.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//

import UIKit

open class CHIPageControlChimayo: CHIBasePageControl {
    
    fileprivate var diameter: CGFloat {
        return radius * 2
    }

    fileprivate var inactive = [CHILayer]()

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.update(for: self.progress)
    }

    override func updateNumberOfPages(_ count: Int) {
        inactive.forEach { $0.removeFromSuperlayer() }
        inactive = [CHILayer]()
        inactive = (0..<count).map {_ in
            let layer = CHILayer()
            self.layer.addSublayer(layer)
            return layer
        }

        setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let floatCount = CGFloat(inactive.count)
        let x = (self.bounds.size.width - self.diameter*floatCount - self.padding*(floatCount-1))*0.5
        let y = (self.bounds.size.height - self.diameter)*0.5
        var frame = CGRect(x: x, y: y, width: self.diameter, height: self.diameter)

        inactive.enumerated().forEach() { index, layer in
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.diameter + self.padding
            layer.backgroundColor = self.tintColor(position: index).cgColor
        }
        update(for: progress)
    }

    override func update(for progress: Double) {
        guard progress >= 0 && progress <= Double(numberOfPages - 1),
            numberOfPages > 1 else { return }

        let rect = CGRect(x: 0, y: 0, width: self.diameter, height: self.diameter).insetBy(dx: 1, dy: 1)

        let left = floor(progress)
        let page = Int(progress)
        let move = rect.width / 2

        let rightInset = move * CGFloat(progress - left)
        let rightRect = rect.insetBy(dx: rightInset, dy: rightInset)

        let leftInset = (1 - CGFloat(progress - left)) * move
        let leftRect = rect.insetBy(dx: leftInset, dy: leftInset)

        let mask = { (index: Int, layer: CHILayer) in
            let mask = CAShapeLayer()
            mask.fillRule = CAShapeLayerFillRule.evenOdd
            let bounds = UIBezierPath(rect: layer.bounds)
            switch index {
            case page:
                bounds.append(UIBezierPath(ovalIn: leftRect))
            case page + 1:
                bounds.append(UIBezierPath(ovalIn: rightRect))
            default:
                bounds.append(UIBezierPath(ovalIn: rect))
            }
            mask.path = bounds.cgPath
            mask.frame = layer.bounds
            layer.mask = mask
        }

        for (index, layer) in inactive.enumerated() {
            mask(index, layer)
        }
    }
        
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
        
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding,
                      height: self.diameter)
    }
    
    override open func didTouch(gesture: UITapGestureRecognizer) {
        let point = gesture.location(ofTouch: 0, in: self)
        if let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset {
            delegate?.didTouch(pager: self, index: touchIndex)
        }
    }
}
