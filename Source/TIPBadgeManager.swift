//
//  TIPBadgeManager.swift
//  ExampleTIPBadgeManager
//
//  Created by John Coschigano on 6/16/15.
//  Copyright (c) 2015 John Coschigano. All rights reserved.
//

import UIKit

public class TIPBadgeManager {
    
    public static let sharedInstance = TIPBadgeManager()
    
    public var tipBadgeObjDict = [String : TIPBadgeObject]()
    
    private init() {}
    
    public func addBadgeSuperview(name: String, view: AnyObject){
        var badgeObj: TIPBadgeObject?
        
        if let superView = view as? UIView {
            badgeObj = TIPViewObject(view: superView)
        }
        else if let superView = view as? UITabBarItem {
            badgeObj = TIPTabBarItemObject(tabBar: superView)
        }
        tipBadgeObjDict[name] = badgeObj!
    }
    
    public func setBadgeValue(key : String, value : Int){
        tipBadgeObjDict[key]?.badgeValue = value
    }
    
    public func setAllBadgeValues(value : Int, appIconBadge: Bool){
        for (key, _) in tipBadgeObjDict {
            if !isTIPViewObjNil(tipBadgeObject: tipBadgeObjDict[key]!) || !isTIPTabBarItemObjNil(tipBadgeObject: tipBadgeObjDict[key]!){
                setBadgeValue(key: key, value: value)
            }
        }
        
        if appIconBadge {
            setAppIconBadgeValue(value: value)
        }
    }
    
    func setAppIconBadgeValue(value : Int) {
        UIApplication.shared.applicationIconBadgeNumber = value
    }
    
    public func getBadgeValue(key : String) -> Int? {
        if tipBadgeObjDict[key] != nil {
            if !isTIPViewObjNil(tipBadgeObject: tipBadgeObjDict[key]!) || !isTIPTabBarItemObjNil(tipBadgeObject: tipBadgeObjDict[key]!){
                return tipBadgeObjDict[key]!.badgeValue
            }
        }
       return nil
    }
    
    func isTIPViewObjNil(tipBadgeObject: TIPBadgeObject) -> Bool{
        if let tipViewObject = tipBadgeObject as? TIPViewObject {
            if tipViewObject.view != nil {
                return false
            }
        }
        return true
    }
    
    func isTIPTabBarItemObjNil(tipBadgeObject: TIPBadgeObject) -> Bool{
        if let tipTabBarItemObject = tipBadgeObject as? TIPTabBarItemObject {
            if tipTabBarItemObject.tabBar != nil {
                return false
            }
        }
        return true
    }
    
    public func clearAllBadgeValues(clearAppIconBadge: Bool){
        clearAllBadgeValues()
        if clearAppIconBadge { setAppIconBadgeValue(value: 0) }
    }
    
    func clearAllBadgeValues(){
        for (key, _) in tipBadgeObjDict {
            setBadgeValue(key: key, value: 0)
        }
    }
    
    
    public func removeBadgeObjFromDict(keys : [String]) {
        for key in keys {
            tipBadgeObjDict.removeValue(forKey: key)
        }
    }
    
    //not yet called progammatically
    public func cleanBadgeObjectDict(){
        for (key, value) in tipBadgeObjDict {
            if let _ = value as? TIPViewObject {
                cleanTipViewObject(key: key)
            }
            if let _ = value as? TIPTabBarItemObject {
                cleanTipTabBarItemObject(key: key)
            }
        }
    }
    
    func cleanTipViewObject(key : String){
        let tipViewObj : TIPViewObject = tipBadgeObjDict[key] as! TIPViewObject
        if tipViewObj.view == nil {
            removeBadgeObjFromDict(keys: [key])
        }
    }
    
    func cleanTipTabBarItemObject(key : String){
        let tipTabBarItemObj : TIPTabBarItemObject = tipBadgeObjDict[key] as! TIPTabBarItemObject
        if tipTabBarItemObj.tabBar == nil {
            removeBadgeObjFromDict(keys: [key])
        }
    }
    
}
