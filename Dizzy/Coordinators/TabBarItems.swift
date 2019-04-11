//
//  TabBarItems.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

extension HomeCoordinatorType {
    
    var discoveryTabBarItem: TabItem? {
        guard let discoveryVC = discoveryVC else { return nil }
        return TabItem(rootController: discoveryVC, icon: Images.discoverySelectedTabIcon(), iconSelected: Images.discoveryUnselectedTabIcon())
    }
    
    var conversationsTapBarItem: TabItem? {
        guard let conversactionVC = conversationsVC else { return nil }
        return TabItem(rootController: conversactionVC, icon: Images.conversationsUnselectedTabIcon(), iconSelected: Images.conversationsSelectedTabIcon())
    }
    
    var tabBarItems: [TabItem]? {
        guard let discoveryTabBarItem = discoveryTabBarItem,
            let conversationsTapBarItem = conversationsTapBarItem else { return nil }
        return [discoveryTabBarItem, conversationsTapBarItem]
    }
    
    func customizeTabButtonsAppearance(_ tabItems: [TabItem]) {
        guard let tabBarItems = tabBarController.tabBar.items else {
            return
        }
        
        for (index, tabBarItem) in tabBarItems.enumerated() {
            tabBarItem.image = tabItems[index].icon
            tabBarItem.selectedImage = tabItems[index].iconSelected
            tabBarItem.title = tabItems[index].title
            tabBarItem.imageInsets = UIEdgeInsets(top:  tabsIconPadding, left:  0, bottom: -tabsIconPadding, right: 0)
        }
    }
}
