//
//  DocumentInteraction.swift
//  PPLittleNote
//
//  Created by suger on 2017/9/18.
//  Copyright © 2017年 diaoshihao. All rights reserved.
//

import UIKit

class DocumentInteraction: NSObject, UIDocumentInteractionControllerDelegate {
    let fileManager = FileManager()
    let documentVC: UIDocumentInteractionController
    let showView: UIView
    
    
    init(in view: UIView) {
        showView = view
        let filePath = PersonModel().getFilePath()
        documentVC = UIDocumentInteractionController(url: URL(fileURLWithPath: filePath))
        super.init()
        
        documentVC.delegate = self
        documentVC.presentOptionsMenu(from: view.bounds, in: view, animated: true)
//        documentVC.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return showView.next as! UIViewController
    }
}
