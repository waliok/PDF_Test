//
//  ViewController.swift
//  PDF_Test
//
//  Created by Waliok on 11/09/2023.
//

import UIKit

class FilesVC: UIViewController {
    
    var searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.text = "My Files"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        navigationItem.searchController = searchController
        self.view.backgroundColor = .white
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreButton)),
            UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationsButton))
        ]
    }
    
    @objc func notificationsButton() {
        
    }
    
    @objc func moreButton() {
        
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct Account_Preview: PreviewProvider {
    
    static var previews: some View {
        TabBar()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
