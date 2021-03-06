//
//  BaseScrollView.swift
//  Cashew
//
//  Created by Hicham Bouabdallah on 7/7/16.
//  Copyright © 2016 SimpleRocket LLC. All rights reserved.
//

import Cocoa

@objc(SRBaseScrollView)
class BaseScrollView: NSScrollView {
    
    var shouldAllowVibrancy = true
    
    override var allowsVibrancy: Bool {
        return shouldAllowVibrancy
    }
    
    var disableThemeObserver = false {
        didSet {
            ThemeObserverController.sharedInstance.removeThemeObserver(self)
        }
    }
    
    var disableScrolling = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    deinit {
        ThemeObserverController.sharedInstance.removeThemeObserver(self)
    }
    
    override func scrollWheel(theEvent: NSEvent) {
        if disableScrolling {
            self.nextResponder?.scrollWheel(theEvent)
        } else {
            super.scrollWheel(theEvent)
        }
    }
    
    override class func isCompatibleWithResponsiveScrolling() -> Bool {
        return true
    }

    
    private func setup() {
        self.wantsLayer = true
        self.canDrawConcurrently = true
        if disableThemeObserver {
            return;
        }
        
        ThemeObserverController.sharedInstance.addThemeObserver(self) { [weak self] (mode) in
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.disableThemeObserver {
                ThemeObserverController.sharedInstance.removeThemeObserver(strongSelf)
                return;
            }
            strongSelf.backgroundColor = CashewColor.backgroundColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
}
