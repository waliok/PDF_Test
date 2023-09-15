//
//  Modal.swift
//  PDF_Test
//
//  Created by Waliok on 14/09/2023.
//

import Foundation
import UIKit
import SnapKit

class ModalViewController: UITableViewController {
    
    var deleteButtonTapped: (() -> Void)?
    
    let containerView = UIView()
    
    private lazy var documentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fillProportionally
        stack.contentMode = .scaleAspectFill
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var stack: UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.contentMode = .scaleAspectFill
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var thumbnailView: UIImageView = {
        
        let thumbnailView = UIImageView()
        thumbnailView.contentMode = .scaleAspectFit
        thumbnailView.layer.shadowRadius = 2
        thumbnailView.layer.shadowOpacity = 0.3
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        return thumbnailView
    }()
    
    var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    var descriptionLabel: UILabel = {
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setUpVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        documentStack.snp.makeConstraints { make in
            make.leading.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView)
            make.bottom.equalTo(containerView)
            make.top.equalTo(containerView)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(50)
        }
    }
}

extension ModalViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsCell", for: indexPath) as! OptionsCell
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = ButtonText.Edit.rawValue
                cell.symbolImageView.image = UIImage(systemName: "square.and.pencil")
                return cell
            case 1:
                cell.textLabel?.text = ButtonText.Sign.rawValue
                cell.symbolImageView.image = UIImage(systemName: "pencil.tip")
                return cell
            case 2:
                cell.textLabel?.text = ButtonText.ConvertTo.rawValue
                cell.symbolImageView.image = UIImage(systemName: "repeat")
                return cell
            default:
                break
            }
        case 1:
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = ButtonText.Share.rawValue
                cell.symbolImageView.image = UIImage(systemName: "paperplane")
                return cell
            case 1:
                cell.textLabel?.text = ButtonText.SaveOnDevice.rawValue
                cell.symbolImageView.image = UIImage(systemName: "opticaldisc")
                return cell
            case 2:
                cell.textLabel?.text = ButtonText.SaveInCloud.rawValue
                cell.symbolImageView.image = UIImage(systemName: "icloud.and.arrow.up")
                return cell
            case 3:
                cell.textLabel?.text = ButtonText.Rename.rawValue
                cell.symbolImageView.image = UIImage(systemName: "pencil.and.outline")
                return cell
            case 4:
                cell.textLabel?.text = ButtonText.Delete.rawValue
                cell.symbolImageView.image = UIImage(systemName: "trash")
                cell.symbolImageView.tintColor = .red
                cell.textLabel?.textColor = .red
                return cell
            default:
                break
            }
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                print(ButtonText.Edit.rawValue)
            case 1:
                print(ButtonText.Sign.rawValue)
            case 2:
                print(ButtonText.ConvertTo.rawValue)
            default:
                break
            }
        case 1:
            
            switch indexPath.row {
            case 0: print(ButtonText.Share.rawValue)
            case 1: print(ButtonText.SaveOnDevice.rawValue)
            case 2: print(ButtonText.SaveInCloud.rawValue)
            case 3: print(ButtonText.Rename.rawValue)
            case 4: delete()
            default:
                break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension ModalViewController {
    
    func setUpVC() {
        
        modalPresentationStyle = .formSheet
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
        tableView.rowHeight = 44.0
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(OptionsCell.self, forCellReuseIdentifier: "OptionsCell")
        tableView.tableHeaderView = containerView
        
        containerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 130)
        containerView.addSubview(documentStack)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        documentStack.addArrangedSubview(thumbnailView)
        documentStack.addArrangedSubview(stack)
    }
    
    func delete() {
        
        let alert = UIAlertController(title: "Delete", message: "Are you shure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { alertAction in }))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] alertAction in
            guard let self = self else { return }
            self.deleteButtonTapped?()
        }))
        present(alert, animated: true)
    }
}
