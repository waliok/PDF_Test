//
//  TabBar.swift
//  PDF_Test
//
//  Created by Waliok on 11/09/2023.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            generateVC(vc: FilesVC(), title: "Files", icon: "doc.on.clipboard", nav: true),
            generateVC(vc: FilesVC(), title: "Tools", icon: "wrench.and.screwdriver", nav: true),
            generateVC(vc: AccountVC(), title: "Account", icon: "person.crop.square", nav: true)]
                
                setUpTabBar()
            }
            
            private func generateVC(vc: UIViewController, title: String, icon: String, nav: Bool = false) -> UIViewController {
                vc.tabBarItem.title = title
                vc.tabBarItem.image = UIImage(systemName: icon)
                if nav {
                    return UINavigationController(rootViewController: vc)
                }
                return vc
            }
            
            private func setUpTabBar() {
                
                self.tabBar.itemPositioning = .centered
                self.tabBar.unselectedItemTintColor = .secondaryLabel
                
            }
        }

        #if DEBUG
        import SwiftUI

        @available(iOS 13, *)
        struct MainTabBar_Preview: PreviewProvider {
            
            static var previews: some View {
                TabBar()
                    .showPreview()
                    .ignoresSafeArea()
            }
        }
        #endif

