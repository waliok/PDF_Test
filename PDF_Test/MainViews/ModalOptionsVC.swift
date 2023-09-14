//
//  Modal.swift
//  PDF_Test
//
//  Created by Waliok on 14/09/2023.
//

import Foundation
import UIKit
import SnapKit

class ModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView()
    
    var deleteButtonTapped: (() -> Void)?
    let blurVisualEffectView: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.alpha = 0.75
        return blur
    }()
    
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
    
    var thumbnailView = UIImageView()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    
    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .formSheet
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 5, height: 7)
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .insetGrouped)
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 130)
        headerView.addSubview(documentStack)
        tableView.tableHeaderView = headerView
        
        thumbnailView.contentMode = .scaleAspectFit
        thumbnailView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(50)
        }
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .light)
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailView.layer.shadowRadius = 2
        thumbnailView.layer.shadowOpacity = 0.3
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        documentStack.addArrangedSubview(thumbnailView)
        documentStack.addArrangedSubview(stack)

        // Set up the table view
        tableView.rowHeight = 44.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(OptionsCell.self, forCellReuseIdentifier: "OptionsCell")
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        documentStack.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(20)
            make.trailing.equalTo(headerView)
            make.bottom.equalTo(headerView)
            make.top.equalTo(headerView)
            
        }
    }

    // Implement UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    
    
    func delete() {
       
            // Make deletion with Alert
            let alert = UIAlertController(title: "Delete", message: "Are you shure?", preferredStyle: .alert)
            // Cancel deletion
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { alertAction in
                
                self.blurVisualEffectView.removeFromSuperview()
            }))
            // Delete action
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { alertAction in
            
                self.deleteButtonTapped?()
                self.blurVisualEffectView.removeFromSuperview()
                
            }))
            self.view.addSubview(blurVisualEffectView)
            present(alert, animated: true)
    }
}

enum ButtonText: String {
    case Edit = "Edit"
    case Sign = "Sign"
    case ConvertTo = "Convert to"
    
    case Share = "Share"
    case SaveOnDevice = "Save on device"
    case SaveInCloud = "Save in cloud"
    case Rename = "Rename"
    case Delete = "Delete"
}
