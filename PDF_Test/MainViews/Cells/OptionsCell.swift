//
//  OptionsCell.swift
//  PDF_Test
//
//  Created by Waliok on 15/09/2023.
//

import UIKit
import SnapKit

class OptionsCell: UITableViewCell {
    
    let symbolImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(symbolImageView)
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        
        symbolImageView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-17)
            make.centerY.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
