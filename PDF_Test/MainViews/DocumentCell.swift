//
//  DocumentCell.swift
//  PDF_Test
//
//  Created by Waliok on 12/09/2023.
//

import UIKit
import SnapKit

class DocumentCell: UICollectionViewCell {
    
    private lazy var documentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.contentMode = .scaleAspectFill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton()
        UIImage.SymbolConfiguration(pointSize: 30, weight: .ultraLight, scale: .default)
        UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10, weight: .light), scale: .medium)
//        button.frame = CGRect(x: 100, y: 100, width: 20, height: 10)
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .ultraLight))
        let image = UIImage(systemName: "ellipsis", withConfiguration: config)
        
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
//
//        let largeBoldDoc = UIImage(systemName: "doc.circle.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
//        button.layer.shadowRadius = 10
//        button.layer.shadowOpacity = 0.4
        button.layer.cornerRadius = 5
//        button.layer.shadowOffset = CGSize(width: 3, height: 7)
        
//        button.addTarget(self, action: #selector(pickPDF), for: .touchUpInside)
        
        return button
    }()

    var thumbnailView = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
//    private lazy var button: UIButton = {
//        var button = UIButton()
//        let image = UIImage(systemName: "ellipsis")
//        button.tintColor = .secondaryLabel
////        button.backgroundColor = UIColor(Color.accentColor)
//        button.setImage(image, for: .normal)
////        button.layer.shadowRadius = 10
////        button.layer.shadowOpacity = 0.4
////        button.layer.cornerRadius = 30
////        button.layer.shadowOffset = CGSize(width: 3, height: 7)
////
////        button.addTarget(self, action: #selector(pickPDF), for: .touchUpInside)
//
//        return button
//    }()
    
//    var url: NSURL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbnailView.contentMode = .scaleAspectFit
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(75)
        }
//        contentView.backgroundColor = .red
//        contentView.backgroundColor = .red
        self.contentView.addSubview(documentStack)
        titleLabel.font = .systemFont(ofSize: 14, weight: .light)
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.textColor = .secondaryLabel
        
//        descriptionLabel.snp.makeConstraints { make in
////            make.leading.equalTo(documentStack)
////            make.trailing.equalTo(documentStack)
//            make.width.equalTo(documentStack)
//        }
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailView.layer.shadowRadius = 2
        thumbnailView.layer.shadowOpacity = 0.3
//        thumbnailView.layer.cornerRadius = 35
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(11)
            make.width.equalTo(25)
        }
        documentStack.addArrangedSubview(thumbnailView)
        documentStack.addArrangedSubview(titleLabel)
        documentStack.addArrangedSubview(descriptionLabel)
        documentStack.addArrangedSubview(button)
        documentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
