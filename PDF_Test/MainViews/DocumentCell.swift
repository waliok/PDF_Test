//
//  DocumentCell.swift
//  PDF_Test
//
//  Created by Waliok on 12/09/2023.
//

import UIKit
import SnapKit

class DocumentCell: UICollectionViewCell {
    
    var showButtonTapped: (() -> Void)?
    
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
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .ultraLight))
        let image = UIImage(systemName: "ellipsis", withConfiguration: config)
        
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
        
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    lazy var thumbnailView: UIImageView = {
        
        let thumbnailView = UIImageView()
        thumbnailView.layer.shadowRadius = 2
        thumbnailView.layer.shadowOpacity = 0.3
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        thumbnailView.contentMode = .scaleAspectFit
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        return thumbnailView
    }()
    lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpStack()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DocumentCell {
    
    func setUpStack() {
        
        documentStack.addArrangedSubview(thumbnailView)
        documentStack.addArrangedSubview(titleLabel)
        documentStack.addArrangedSubview(descriptionLabel)
        documentStack.addArrangedSubview(button)
        contentView.addSubview(documentStack)
    }
    
    func setUpConstraints() {
        
        documentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(75)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(11)
            make.width.equalTo(25)
        }
    }
    
    @objc func tap() {
       showButtonTapped?()
    }
}
