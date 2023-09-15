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

class PDFViewController: UIViewController {
    
    let document: PDFDocument
    
    var pdfView: PDFView = {
        
        let pdfView = PDFView()
        pdfView.isUserInteractionEnabled = true
        pdfView.displaysPageBreaks = true
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true)
        pdfView.displayMode = .singlePageContinuous
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        return pdfView
    }()
    
    lazy var thumbnailView: PDFThumbnailView = {
        
        let thumbnailView = PDFThumbnailView()
        thumbnailView.pdfView = pdfView
        thumbnailView.thumbnailSize = CGSize(width: 50, height: 50)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.backgroundColor = .systemBackground
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        
        return thumbnailView
    }()
    
    private lazy var pageLabel: UILabel = {

        let pageLabel = UILabel()
        pageLabel.textAlignment = .center
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return pageLabel
    }()
    
    
    private lazy var dismissFloatingButton: UIButton = {
        
        var dismissFloatingButton = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium))
        dismissFloatingButton.backgroundColor = .white
        dismissFloatingButton.setImage(image, for: .normal)
        dismissFloatingButton.layer.cornerRadius = 35
        dismissFloatingButton.layer.shadowRadius = 10
        dismissFloatingButton.layer.shadowOpacity = 0.4
        dismissFloatingButton.layer.shadowOffset = CGSize(width: 3, height: 7)
        
        dismissFloatingButton.addTarget(self, action: #selector(closeDocument), for: .touchUpInside)
        
        return dismissFloatingButton
    }()
    
    //MARK: - Init HERE
    
    init(document: PDFDocument) {
        self.document = document
        
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad HERE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVC()
        handlePageChange()
        
        NotificationCenter.default.addObserver (self, selector: #selector(handlePageChange), name: Notification.Name.PDFViewPageChanged, object: nil)
    }
    
    //MARK: - Setup constraints
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pdfView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dismissFloatingButton.snp.makeConstraints { make in
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
            make.bottom.equalTo(thumbnailView.snp.top).offset(-8)
            make.centerX.equalTo(pdfView.snp.centerX)
        }
    }
}

extension PDFViewController: PDFViewDelegate {
    
    func setUpVC() {
        
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.maxScaleFactor = 2
        pdfView.minScaleFactor = 0.5
        pdfView.delegate = self
        pdfView.addSubview(thumbnailView)
        
        view.addSubview(pdfView)
        view.addSubview(dismissFloatingButton)
        view.addSubview(pageLabel)
    }
    
    @objc func closeDocument() {
        self.dismiss(animated: true)
    }
    
    @objc func handlePageChange() {
        let currentPage = pdfView.currentPage?.pageRef?.pageNumber ?? 0
        let totalPages = pdfView.document?.pageCount ?? 0
        pageLabel.text = "\(currentPage)/\(totalPages)"
    }
}
