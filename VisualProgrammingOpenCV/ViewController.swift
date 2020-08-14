//
//  ViewController.swift
//  VisualProgrammingOpenCV
//
//  Created by k18004kk on 2020/08/10.
//  Copyright © 2020 AIT. All rights reserved.
//

import Foundation
import Cocoa
import opencv2

class main{
    var file_name:String?
    var isGrayscale:Bool?
    var output_img_type:String?
    var input_img_type:String?
    
    var ddepth:Int?
    var is_ddepth_active:Bool?
}

class ViewController: NSViewController {

    @IBOutlet weak var OutPutImg: NSImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = NSImage(named: "Lenna_(test_image).png")
        OutPutImg.image = self.convertColor(source: image!)
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
                
                let ChangeNSImage = self.OutPutImg.image!
                self.OutPutImg.image = self.convertColor(source: ChangeNSImage)
            }
        }
        
    }
    func convertColor(source srcImage: NSImage) -> NSImage {
        let dstImage = OpenCVWrapper.hack(srcImage)
        return dstImage as! NSImage
    }

}

