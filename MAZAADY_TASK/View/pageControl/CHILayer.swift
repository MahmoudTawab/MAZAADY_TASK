//
//  CHILayer.swift
//  MAZAADY_TASK
//
//  Created by Mohamed Tawab on 26/03/2025.
//


import QuartzCore

class CHILayer: CAShapeLayer {


    override init() {
        super.init()
        self.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "position": NSNull()
        ]
    }
    
    override public init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
