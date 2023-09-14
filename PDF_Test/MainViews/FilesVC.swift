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
    
    var documents = [PDFDocument]()
    let modalSheet = ModalViewController()
    
    
    private var collectionView: UICollectionView! = nil
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var dataSource: DataSource!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PDFDocument>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PDFDocument>
    
    private lazy var floatingButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .light))
//        button.tintColor = .white
        button.showsTouchWhenHighlighted = true
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
        

        // Get the document directory URL
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                // Get a list of all files in the document directory
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                
                // Create an array to store PDF documents
//                var pdfDocuments: [PDFDocument] = []
                
                // Iterate through the directory contents and filter for PDF files
                for fileURL in directoryContents {
                    if fileURL.pathExtension.lowercased() == "pdf" {
                        // Create a PDFDocument instance for each PDF file
                        if let pdfDocument = PDFDocument(url: fileURL) {
                            documents.append(pdfDocument)
                        }
                    }
                }
                
                // Now, pdfDocuments contains all the PDF documents in the document directory
                print("Number of PDFs found: \(documents.count)")
                
                // You can further process or use the pdfDocuments array as needed
            } catch {
                print("Error reading contents of document directory: \(error)")
            }
        }

        
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let pdfFilename = "myPDF.pdf" // Choose a unique name
//        let pdfFileURL = documentsDirectory.appendingPathComponent(pdfFilename)
//        documents.append(PDFDocument(url: pdfFileURL)!)
        
        configureHierarchy()
        configureSearchController()
        makeDataSource()
        collectionView.allowsSelection = true
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "My Files"
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        navigationItem.titleView = label
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 1000, height: 0)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreButton)),
            UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(notificationsButton))
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(documentDirectoryDidChange(_:)), name: .documentDirectoryDidChange, object: nil)
        
//        let glareView = UIView(frame: CGRect(x: 0, y: 0, width: floatingButton.frame.width, height: floatingButton.frame.height))
//                glareView.backgroundColor = UIColor.white.withAlphaComponent(0.3) // Adjust alpha as needed
//                floatingButton.addSubview(glareView)
//
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-100)
            make.leading.equalTo(view.snp.trailing).offset(-80)
        }
    }
}

extension FilesVC {
    
    private func createLayout() -> UICollectionViewLayout {
        
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
    
    private func configureHierarchy() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(DocumentCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.delegate = self
        view.addSubview(collectionView)
        // Add white shadow (top)
        
//        floatingButton.layer.masksToBounds = false
////                let whiteShadowLayer = CALayer()
////                whiteShadowLayer.frame = floatingButton.bounds
////                whiteShadowLayer.backgroundColor = UIColor.clear.cgColor
////                whiteShadowLayer.shadowColor = UIColor.white.cgColor
////                whiteShadowLayer.shadowOffset = CGSize(width: 0, height: -4) // Negative value to place it at the top
////                whiteShadowLayer.shadowOpacity = 1
////                whiteShadowLayer.shadowRadius = 4
////        floatingButton.layer.insertSublayer(whiteShadowLayer, at: 1)
//
//                // Add black shadow (bottom)
//                let blackShadowLayer = CALayer()
//                blackShadowLayer.frame = floatingButton.bounds
//                blackShadowLayer.backgroundColor = UIColor.clear.cgColor
//                blackShadowLayer.shadowColor = UIColor.black.cgColor
//                blackShadowLayer.shadowOffset = CGSize(width: 0, height: 10) // Positive value to place it at the bottom
//                blackShadowLayer.shadowOpacity = 1
//                blackShadowLayer.shadowRadius = 10
//        floatingButton.layer.insertSublayer(blackShadowLayer, at: 1)
            
        collectionView.addSubview(floatingButton)
     }
    
    func deleteCell(at indexPath: IndexPath, pdfDocument: PDFDocument) {
            // Remove the item from the diffable data source
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems([pdfDocument])
//        documents.r
            dataSource.apply(snapshot, animatingDifferences: true)
        
//        var snapshot = Snapshot()
//          snapshot.appendSections([Section.main])
//          snapshot.appendItems(self.documents)
//          dataSource.apply(snapshot, animatingDifferences: true)
            
            // Delete the PDF file associated with the PDFDocument
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
           // Access the cell at the given indexPath
           if let cell = collectionView.cellForItem(at: indexPath) as? DocumentCell {
               // Create and present the modal sheet
               // Create your modal sheet content here
//               modalSheet.modalPresentationStyle = .formSheet
//               modalSheet.modalTransitionStyle = .coverVertical
//               modalSheet.view.backgroundColor = .systemTeal
//               modalSheet.pres
               let sheet = self.modalSheet.sheetPresentationController
               sheet?.detents = [.medium(), .large()]
               sheet?.prefersGrabberVisible = true
               sheet?.prefersScrollingExpandsWhenScrolledToEdge = true
               modalSheet.modalPresentationStyle = .formSheet
               modalSheet.modalTransitionStyle = .coverVertical
//               modalSheet.view.backgroundColor = .white
//               modalSheet.tableView.backgroundColor = .white
//               modalSheet.tableView.layer.shadowRadius = 10
//               modalSheet.tableView.layer.shadowOpacity = 0.5
//               modalSheet.tableView.layer.shadowOffset = CGSize(width: 5, height: 7)
//               modalSheet.preferredContentSize = .init(width: 100, height: 100)
               
               modalSheet.deleteButtonTapped = { [weak self] in
                   guard let self = self else { return }
                   deleteCell(at: indexPath, pdfDocument: pdfDocument)
                   modalSheet.dismiss(animated: true)
               }
               
               
               modalSheet.thumbnailView.image = cell.thumbnailView.image
               modalSheet.titleLabel.text = cell.titleLabel.text
               modalSheet.descriptionLabel.text = cell.descriptionLabel.text
               // Add content to the modal sheet
//               let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
//               label.text = "This is a modal sheet"
//               label.textAlignment = .center
//               modalSheet.view.addSubview(label)
               
//               let deleteButton = UIButton(type: .system)
//               deleteButton.setTitle("Delete document", for: .normal)
//               deleteButton.addAction(UIAction(handler: { [self] ac in
//                   o(at: indexPath, pdfDocument: pdfDocument)
//               }), for: .touchUpInside)
//               modalSheet.view.addSubview(deleteButton)
               
               // Position the delete button
//               deleteButton.translatesAutoresizingMaskIntoConstraints = false
//               NSLayoutConstraint.activate([
//                   deleteButton.centerXAnchor.constraint(equalTo: modalSheet.view.centerXAnchor),
//                   deleteButton.centerYAnchor.constraint(equalTo: modalSheet.view.centerYAnchor)
//               ])

               
               // Present the modal sheet from the nearest view controller
               if let viewController = cell.findViewController() {
                   
                   viewController.present(modalSheet, animated: true, completion: nil)
               }
           }
       }
    
//    @objc func o(at: IndexPath, pdfDocument: PDFDocument) {
//        deleteCell(at: at, pdfDocument: pdfDocument)
//        modalSheet.dismiss(animated: true)
//    }
    
    func makeDataSource() {
         dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, document) -> DocumentCell? in
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "cellId", for: indexPath) as! DocumentCell
//             cell.deleteTapHandler = { [weak self] in
//                 self?.deleteCell(at: indexPath, pdfDocument: document)
//             }
             
             cell.showButtonTapped = { [weak self] in
                 self?.presentModalSheetFromCell(at: indexPath, pdfDocument: document)
                     }
             
//             if let attributes = try? pdfURL.resourceValues(forKeys: [.fileSizeKey]) {
//                 if let fileSize = attributes[.fileSizeKey] as? Int {
//                     // fileSize contains the size of the PDF file in bytes
//                     print("PDF File Size: \(fileSize) bytes")
//                 }
//             }
            
//             let fileAttributes = try! FileManager.default.attributesOfItem(atPath: pdfFileURL.path)
//
//                    // Extract the file size in bytes
//             if let fileSize = fileAttributes[.size] as? Int64 {
//                 // Convert bytes to a human-readable format (e.g., KB, MB, GB)
//                 let byteCountFormatter = ByteCountFormatter()
//                 byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
//                 byteCountFormatter.countStyle = .file
//                 print(byteCountFormatter.string(fromByteCount: fileSize))
//             }
//
//             if let modificationDate = fileAttributes[.modificationDate] as? Date {
//                 let dateFormatter = DateFormatter()
//                 dateFormatter.dateFormat = "dd.MM.yyyy"
//                 let formattedModificationDate = dateFormatter.string(from: modificationDate)
//                 print(formattedModificationDate)
//             }
             
             
             
              if let documentAttributes = document.documentAttributes {
//                  if let title = documentAttributes[PDFDocumentAttribute.titleAttribute] as? String {
//                      cell.titleLabel.text = title
//                  }
//                  if let author = documentAttributes[PDFDocumentAttribute.authorAttribute] as? String {
//                      cell.descriptionLabel.text = author
//                  }
                  
//                  if let pdfTitle = documentAttributes[PDFDocumentAttribute.titleAttribute] as? String {
//                      cell.titleLabel.text = title
//                  }
                  
                  if document.pageCount > 0 {
                      if let page = document.page(at: 0), let url = document.documentURL as NSURL? {
//                          cell.url = url
                          print(url.lastPathComponent)
                          cell.titleLabel.text = url.lastPathComponent?.description
                          let thumbnail = page.thumbnail(of: CGSize(width: 100, height: 250), for: .mediaBox)
                          cell.thumbnailView.image = thumbnail
//                          if let thumbnail = self.thumbnailCache.object(forKey: key) {
//                              cell.thumbnailView.image = thumbnail
//                          } else {
//                              self.downloadQueue.async {
//
//                                  self.thumbnailCache.setObject(thumbnail, forKey: key)
//                                  if cell.url == key {
//                                      DispatchQueue.main.async {
//
//                                      }
//                                  }
//                              }
//                          }
                          let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path!)
                          
                          var labelText = ""
                          
                          if let modificationDate = fileAttributes[.modificationDate] as? Date {
                              let dateFormatter = DateFormatter()
                              dateFormatter.dateFormat = "dd.MM.yyyy"
                              let formattedModificationDate = dateFormatter.string(from: modificationDate)
                              print(formattedModificationDate)
                              labelText.append(formattedModificationDate)
//                              cell.descriptionLabel.text?.append(formattedModificationDate)
                          }
                                 // Extract the file size in bytes
                          if let fileSize = fileAttributes[.size] as? Int64 {
                              // Convert bytes to a human-readable format (e.g., KB, MB, GB)
                              let byteCountFormatter = ByteCountFormatter()
                              byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
                              byteCountFormatter.countStyle = .file
                              let size = byteCountFormatter.string(fromByteCount: fileSize)
                              print(size)
                              labelText.append(" • \(size)")
//                              cell.descriptionLabel.text?.append(" • \(size)")
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
    
    @objc func notificationsButton() {
        
    }
    
    @objc func moreButton() {
        
    }
    
    @objc func pickPDF() {
        
        showDocumentPicker()
    }
    
    private func refreshData() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let contents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        documents = contents.flatMap { PDFDocument(url: $0) }
    }

    @objc func documentDirectoryDidChange(_ notification: Notification) {
        refreshData()
    }
}

//extension FilesVC: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//
//
//    }
//}



extension FilesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//         guard let document = dataSource.itemIdentifier(for: indexPath) else { return}
//        print("HELOO")
//
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let pdfFilename = "Sample.pdf" // Choose a unique name
//        let pdfFileURL = documentsDirectory.appendingPathComponent(pdfFilename)
//
//
//
//        let fileAttributes = try! FileManager.default.attributesOfItem(atPath: pdfFileURL.path)
//
//               // Extract the file size in bytes
//        if let fileSize = fileAttributes[.size] as? Int64 {
//            // Convert bytes to a human-readable format (e.g., KB, MB, GB)
//            let byteCountFormatter = ByteCountFormatter()
//            byteCountFormatter.allowedUnits = [.useKB, .useMB, .useGB]
//            byteCountFormatter.countStyle = .file
//            print(byteCountFormatter.string(fromByteCount: fileSize))
//        }
//
//        if let modificationDate = fileAttributes[.modificationDate] as? Date {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd.MM.yyyy"
//            let formattedModificationDate = dateFormatter.string(from: modificationDate)
//            print(formattedModificationDate)
//        }
        
        
//        if let attributes = try? pdfFileURL.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]) {
////            if let fileSize = attributes.allValues  {
//                // fileSize contains the size of the PDF file in bytes
//                print("PDF File Size: \(attributes.allValues) bytes")
////            }
//        }
        let selectedDocument = documents[indexPath.item]

               // Instantiate the PDF view controller
//               let pdfViewController = PDFViewController(pdfDocument: selectedDocument)
        
//        guard pdfFileURL.startAccessingSecurityScopedResource() else { return }
//        guard let doc = PDFDocument(url: pdfFileURL) else { return }
//        
//        print(doc.pageCount)
        let pdfViewController = PDFViewController(document: selectedDocument)
//            pdfViewController.displayPDF(withURL: pdfFileURL)

            // Present the PDFViewController
        pdfViewController.modalPresentationStyle = .fullScreen
        pdfViewController.modalTransitionStyle = .crossDissolve
//        pdfViewController.preferredContentSize = .init(width: 500, height: 800)
        present(pdfViewController, animated: true)
        
//            navigationController?.pushViewController(pdfViewController, animated: true)
//    guard let video = dataSource.itemIdentifier(for: indexPath) else {
//      return
//    }
//    guard let link = video.link else {
//      print("Invalid link")
//      return
//    }
//    let safariViewController = SFSafariViewController(url: link)
//    present(safariViewController, animated: true, completion: nil)
  }
}

//extension FilesVC: UISearchResultsUpdating {
//  func updateSearchResults(for searchController: UISearchController) {
//    sections = filteredSections(for: searchController.searchBar.text)
//    applySnapshot()
//  }
  
//  func filteredSections(for queryOrNil: String?) -> [Section] {
//    let sections = Section.allSections
//    guard
//      let query = queryOrNil,
//      !query.isEmpty
//      else {
//        return sections
//    }
//
//    return sections.filter { section in
//      var matches = section.title.lowercased().contains(query.lowercased())
//      for video in section.videos {
//        if video.title.lowercased().contains(query.lowercased()) {
//          matches = true
//          break
//        }
//      }
//      return matches
//    }
//  }
  

extension FilesVC: UIDocumentPickerDelegate, UISearchResultsUpdating {
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
  //    let topPadding: CGFloat = 50
  //    searchController.searchBar.frame.origin.y += topPadding
  //    searchController.searchBar.frame.size.height -= topPadding
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search documents"
      navigationItem.searchController = searchController
      definesPresentationContext = true
        
    }
    
    private func showDocumentPicker() {
//        let documentPicker: UIDocumentPickerViewController
//        let pdfType = "com.adobe.pdf"
        
//        if #available(iOS 14.0, *) {
//            let documentTypes = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
//            documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
//        } else {
//            documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType], in: .import)
//        }
//        let documentTypes = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
//        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes)
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overCurrentContext
        documentPicker.modalTransitionStyle = .flipHorizontal
        

        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let url = urls.first else { return }
////        displayPDF(url: url)
//        DispatchQueue.main.async {
//            print(url)
//            self.documents.append(PDFDocument(url: url)!)
//        }
//
//    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//        guard url.startAccessingSecurityScopedResource() else { return }
//        guard let doc = PDFDocument(url: url) else { return }
//
//           defer { url.stopAccessingSecurityScopedResource() }
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let pdfFilename = "myPDF.pdf" // Choose a unique name
//        let pdfFileURL = documentsDirectory.appendingPathComponent(pdfFilename)
//        do {
//            try doc.write(to: pdfFileURL)
//            print("PDF saved to: \(pdfFileURL)")
//        } catch {
//            print("Error saving PDF: \(error.localizedDescription)")
//        }
//
//        DispatchQueue.main.async {
//            print(url)
//            self.documents.append(doc)
//            print(self.documents.count)
//            var newSnapshot = self.dataSource.snapshot()
//            let newItem = doc
//            newSnapshot.appendItems([newItem], toSection: .main)
//            self.dataSource.apply(newSnapshot, animatingDifferences: true)
//        }
//        dismiss(animated: true)
        
//        guard let selectedFileURL = url else {
//                    return
//                }
        print(url)

                // Now, you have the selected PDF file URL, and you can save it to the document directory.
                savePDFToDocumentDirectory(from: url)
    }
    
    func savePDFToDocumentDirectory(from sourceURL: URL) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
           let destinationURL = documentDirectory.appendingPathComponent(sourceURL.lastPathComponent)

           do {
               try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
               print("PDF saved to document directory: \(destinationURL)")
               print(sourceURL)
               print(destinationURL)
               guard let doc = PDFDocument(url: destinationURL) else { return }
//               self.documents.append(doc)
               print(self.documents.count)
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
struct Account_Preview: PreviewProvider {
    
    static var previews: some View {
        TabBar()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif



enum Section {
    case main
}
