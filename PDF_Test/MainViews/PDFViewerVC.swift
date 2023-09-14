//
//  PDFViewer.swift
//  PDF_Test
//
//  Created by Waliok on 13/09/2023.
//

import UIKit
import PDFKit
import SnapKit
import SwiftUI

class PDFViewController: UIViewController, PDFViewDelegate {
    
    let document: PDFDocument
    // Create a PDFView
    var pdfView: PDFView!
    var thumbnailView = PDFThumbnailView()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // Set the text color as desired
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private lazy var floatingButton: UIButton = {
        var button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium))
//        button.tintColor = .white
        button.backgroundColor = .white
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
//
//        let largeBoldDoc = UIImage(systemName: "doc.circle.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.4
        button.layer.cornerRadius = 35
        button.layer.shadowOffset = CGSize(width: 3, height: 7)
        
        button.addTarget(self, action: #selector(pickPDF), for: .touchUpInside)
        
        return button
    }()
    
    init(document: PDFDocument) {
//        self.pdfURL = pdfURL
//        self.pdfView = pdfView
        self.document = document
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        pdfView = PDFView()
//        if let document = PDFDocument(url: pdfURL) {
//            print(pdfURL)
            pdfView.document = document
//        }
        
        pdfView.delegate = self
        
        pdfView.autoScales = true
//        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
//        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.maxScaleFactor = 2
        pdfView.minScaleFactor = 0.5
        pdfView.isUserInteractionEnabled = true
        pdfView.displaysPageBreaks = true
        pdfView.displayDirection = .horizontal
//        pdfView.usePageViewController(true)
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.usePageViewController(true, withViewOptions: nil)
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        setThubnailView(pdfView)
        
        view.addSubview(pdfView)
        
        view.addSubview(floatingButton)
        // Add pageLabel
            view.addSubview(pageLabel)

            // Set initial text for the label
        handlePageChange()
        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.top.equalTo(pdfView.snp.top).offset(50)
            make.leading.equalTo(pdfView.snp.trailing).offset(-50)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.leading.equalTo(pdfView)
            make.trailing.equalTo(pdfView)
            make.bottom.equalTo(pdfView).offset(-40)
            make.height.equalTo(60)
        }
        
        pageLabel.snp.makeConstraints { make in
               // Position the label above the thumbnailView
            make.bottom.equalTo(thumbnailView.snp.top).offset(-8) // Adjust the offset as needed
            make.centerX.equalTo(pdfView.snp.centerX)
           }
    }
    
    @objc func pickPDF() {
        print("Hello")
        self.dismiss(animated: true)
    }

    func setThubnailView(_ view: PDFView) {
//        let thumbnailView = PDFThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailView)
        thumbnailView.pdfView = pdfView
        
        
//        thumbnailView.snp.makeConstraints { make in
//               // Position the thumbnail view at the bottom of the PDFView or as needed
//               make.leading.trailing.bottom.equalTo(pdfView).offset(-40)
//            make.centerX.equalTo(pdfView)
//               // Add other constraints for the thumbnail view as needed
//           }
      
        
        thumbnailView.thumbnailSize = CGSize(width: 50, height: 50)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.backgroundColor = .systemBackground
    }
    
   @objc func handlePageChange() {
        let currentPage = pdfView.currentPage?.pageRef?.pageNumber ?? 0
        let totalPages = pdfView.document?.pageCount ?? 0
        pageLabel.text = "\(currentPage)/\(totalPages)"
    }
    
//    // Implement PDFViewDelegate method to track page changes
//    func pdfViewPageChanged(_ pdfView: PDFView) {
//        updatePageInfo()
//    }
//
//
//    func pdfViewDidDocumentLoad(_ pdfView: PDFView) {
//        // The PDF document is loaded; you can change the page here.
//        print("_______________________________________________________________")
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            // Calculate the current page based on the visible area of the PDF
//            if let currentPage = pdfView.currentPage,
//               let document = pdfView.document {
//                let currentPageIndex = document.index(for: currentPage)
//                print("Current Page: \(currentPageIndex + 1)") // Adding 1 because page numbers are 1-based
//            }
//        }
    
}
