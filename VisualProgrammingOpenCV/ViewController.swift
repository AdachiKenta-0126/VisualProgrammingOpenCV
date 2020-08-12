//
//  ViewController.swift
//  VisualProgrammingOpenCV
//
//  Created by k18004kk on 2020/08/10.
//  Copyright © 2020 AIT. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var OutPutImg: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func BtnImgPath(_ sender: NSButton) {
        let dialog = NSOpenPanel() //ファイルを開くダイアログ
        dialog.canChooseDirectories=false // ディレクトリを選択できるか
        dialog.canChooseFiles = true // ファイルを選択できるか
        dialog.canCreateDirectories = false // ディレクトリを作成できるか
        dialog.allowsMultipleSelection = false // 複数ファイルの選択を許すか
        dialog.allowedFileTypes = NSImage.imageTypes // 選択できるファイル種別
        dialog.begin { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {// ファイルを選択したか(OKを押したか)
                guard dialog.url != nil else { return }
                //log.info(url.absoluteString)
                // ここでファイルを読み込む
                self.OutPutImg.image = NSImage(contentsOf: dialog.url!)
            }
        }
    }
    

}

