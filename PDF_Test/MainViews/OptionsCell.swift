//
//  OptionsCell.swift
//  PDF_Test
//
//  Created by Waliok on 15/09/2023.
//

import UIKit
import SnapKit

class OptionsCell: UITableViewCell {
    // You can customize your cell further if needed.
    // For now, we'll just add an imageView for the SF Symbol.
    
    let symbolImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure your cell's appearance here.
        
        // Set up the symbolImageView
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(symbolImageView)
        
        // Add constraints to position the imageView in the cell as needed
        symbolImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-17)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
