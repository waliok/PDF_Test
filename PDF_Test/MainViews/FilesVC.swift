//
//  ViewController.swift
//  PDF_Test
//
//  Created by Waliok on 11/09/2023.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers
import SnapKit

class FilesVC: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PDFDocument>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PDFDocument>
    
    private var dataSource: DataSource!
    private var documents = [PDFDocument]()
    private let modalSheet = ModalViewController()
    private var collectionView: UICollectionView!
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var floatingButton: UIButton = {
        
        var button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .light))
        button.backgroundColor = .white
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 60
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 5, height: 7)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(pickPDF), for: .touchUpInside)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDocuments()
        setUpCollectionView()
        configureSearchController()
        makeDataSource()
        setUpNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-100)
            make.leading.equalTo(view.snp.trailing).offset(-80)
        }
    }
}

private extension FilesVC {
    
    private func setUpNavigationBar() {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "My Files"
        navigationItem.titleView = label
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 1000, height: 0)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreButton)),
            UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationsButton))
        ]
    }
    
    private func loadDocuments() {
        // Get the document directory URL
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                // Get a list of all files in the document directory
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                
                // Iterate through the directory contents and filter for PDF files
                for fileURL in directoryContents {
                    if fileURL.pathExtension.lowercased() == "pdf" {
                        // Create a PDFDocument instance for each PDF file
                        if let pdfDocument = PDFDocument(url: fileURL) {
                            documents.append(pdfDocument)
                        }
                    }
                }
            } catch {
                print("Error reading contents of document directory: \(error)")
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 1, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setUpCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(DocumentCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.addSubview(floatingButton)
    }
    
    private func deleteCell(at indexPath: IndexPath, pdfDocument: PDFDocument) {
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([pdfDocument])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if let pdfURL = pdfDocument.documentURL {
            do {
                try FileManager.default.removeItem(at: pdfURL)
            } catch {
                print("Error deleting file: \(error)")
            }
        }
        
        if let index = documents.firstIndex(where: { $0 === pdfDocument }) {
            documents.remove(at: index)
        }
    }
    
    private func presentModalSheetFromCell(at indexPath: IndexPath, pdfDocument: PDFDocument) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? DocumentCell {
            
            let sheet = self.modalSheet.sheetPresentationController
            sheet?.detents = [.medium(), .large()]
            sheet?.prefersGrabberVisible = true
            sheet?.prefersScrollingExpandsWhenScrolledToEdge = true
            
            modalSheet.modalPresentationStyle = .formSheet
            modalSheet.modalTransitionStyle = .coverVertical
            
            modalSheet.thumbnailView.image = cell.thumbnailView.image
            modalSheet.titleLabel.text = cell.titleLabel.text
            modalSheet.descriptionLabel.text = cell.descriptionLabel.text
            
            modalSheet.deleteButtonTapped = { [weak self] in
                guard let self = self else { return }
                deleteCell(at: indexPath, pdfDocument: pdfDocument)
                modalSheet.dismiss(animated: true)
            }
            
            if let viewController = cell.findViewController() {
                
                viewController.present(modalSheet, animated: true, completion: nil)
            }
        }
    }
    
    private func makeDataSource() {
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, document) -> DocumentCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cellId", for: indexPath) as! DocumentCell
            
            cell.showButtonTapped = { [weak self] in
                self?.presentModalSheetFromCell(at: indexPath, pdfDocument: document)
            }
            
            if let documentAttributes = document.documentAttributes {
                
                if document.pageCount > 0 {
                    if let page = document.page(at: 0), let url = document.documentURL as NSURL? {
                        
                        cell.titleLabel.text = url.lastPathComponent?.description
                        let thumbnail = page.thumbnail(of: CGSize(width: 100, height: 250), for: .mediaBox)
                        cell.thumbnailView.image = thumbnail
                        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path!)
                        
                        var labelText = ""
                        
                        if let modificationDate = fileAttributes[.modificationDate] as? Date {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd.MM.yyyy"
                            let formattedModificationDate = dateFormatter.string(from: modificationDate)
                            labelText.append(formattedModificationDate)
                        }
                        
                        if let fileSize = fileAttributes[.size] as? Int64 {
                            
                            let byteCountFormatter = ByteCountFormatter()
                            byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
                            byteCountFormatter.countStyle = .file
                            let size = byteCountFormatter.string(fromByteCount: fileSize)
                            labelText.append(" • \(size)")
                        }
                        cell.descriptionLabel.text = labelText
                    }
                }
            }
            return cell
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(self.documents)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func notificationsButton() {}
    
    @objc func moreButton() {}
    
    @objc func pickPDF() {
        showDocumentPicker()
    }
}

//MARK: - CollectionViewDelegate EXT

extension FilesVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedDocument = documents[indexPath.item]
        let pdfViewController = PDFViewController(document: selectedDocument)
        
        pdfViewController.modalPresentationStyle = .fullScreen
        pdfViewController.modalTransitionStyle = .crossDissolve
        present(pdfViewController, animated: true)
    }
}

//MARK: - SearcchBar EXT

extension FilesVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredItems = documents.filter { item in
                // Check if the lastPathComponent contains the search text (case-insensitive)
                let lastPathComponent = item.documentURL!.lastPathComponent.lowercased()
                return lastPathComponent.contains(searchText.lowercased())
            }
            
            // Create a new snapshot with the filtered items
            var snapshot = NSDiffableDataSourceSnapshot<Section, PDFDocument>()
            snapshot.appendSections([.main])
            snapshot.appendItems(filteredItems)
            
            // Update the data source with the filtered snapshot
            dataSource.apply(snapshot, animatingDifferences: true)
        } else {
            // Display all items if search text is empty
            var snapshot = NSDiffableDataSourceSnapshot<Section, PDFDocument>()
            snapshot.appendSections([.main])
            snapshot.appendItems(documents)
            
            // Update the data source with the unfiltered snapshot
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func configureSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search documents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: - DocumentPicker EXT

extension FilesVC: UIDocumentPickerDelegate {
    
    private func showDocumentPicker() {
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overCurrentContext
        documentPicker.modalTransitionStyle = .flipHorizontal
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        savePDFToDocumentDirectory(from: url)
    }
    
    func savePDFToDocumentDirectory(from sourceURL: URL) {
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationURL = documentDirectory.appendingPathComponent(sourceURL.lastPathComponent)
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            guard let doc = PDFDocument(url: destinationURL) else { return }
            var newSnapshot = self.dataSource.snapshot()
            let newItem = doc
            newSnapshot.appendItems([newItem], toSection: .main)
            self.dataSource.apply(newSnapshot, animatingDifferences: true)
            documents.append(newItem)
        } catch {
            print("Error saving PDF to document directory: \(error)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let currentResponder = responder {
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
            responder = currentResponder.next
        }
        return nil
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct FilesVC_Preview: PreviewProvider {
    
    static var previews: some View {
        TabBar()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
