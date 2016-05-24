//
//  PrivateBundle+BundleExtension.swift
//  TheGoalkeeperTimer
//
//  Created by Emanuele Mameli on 24/05/16.
//  Copyright © 2016 Emanuele Mameli. All rights reserved.
//

import Foundation

var AssociatedLanguageBundle: UInt8 = 0

class PrivateBundle: NSBundle {
    
    override func localizedStringForKey( key: String, value: String?, table tableName: String? ) -> String {
        if let bundle: NSBundle = objc_getAssociatedObject(self, &AssociatedLanguageBundle) as? NSBundle {
            return bundle.localizedStringForKey( key, value: value, table: tableName )
        }
        return super.localizedStringForKey( key, value: value, table: tableName )
    }
}

extension NSBundle {
    static func setLanguage( language: String ) {
        var oneToken: dispatch_once_t = 0
        dispatch_once(&oneToken) {
            object_setClass(NSBundle.mainBundle(), PrivateBundle.self )
        }
        
        var bundle: NSBundle? = nil
        if let path = NSBundle.mainBundle().pathForResource(language, ofType: "lproj") {
            bundle = NSBundle(path: path)
        }
        
        objc_setAssociatedObject(NSBundle.mainBundle(), &AssociatedLanguageBundle, bundle, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
