//
//  PDFViewController.swift
//  SMPL Supplier
//
//  Created by Family on 12/11/20.
//  Copyright © 2020 Family. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {

   var pdfView = PDFView()
        var pdfURL: URL!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(pdfView)
            
            if let document = PDFDocument(url: pdfURL) {
                pdfView.document = document
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                self.dismiss(animated: true, completion: nil)
//            }
        }
        
        override func viewDidLayoutSubviews() {
            pdfView.frame = view.frame
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


