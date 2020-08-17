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
    //フィルタごとにまとめたビュー
    @IBOutlet weak var edgeView: NSView!
    @IBOutlet weak var binaryView: NSView!
    //開閉式メニューの為のボタン
    @IBOutlet weak var SmoothingButton: NSButton!
    @IBOutlet weak var EdgeButton: NSButton!
    @IBOutlet weak var BinaryButton: NSButton!
    //平滑化処理のフィルタ
    @IBOutlet weak var GaussianBlurFirterLabel: NSButton!
    @IBOutlet weak var blurFirterLabel: NSButton!
    //エッジ処理のフィルタ
    @IBOutlet weak var SobelFirterLabel: NSButton!
    @IBOutlet weak var PrewittFilterLabel: NSButton!
    @IBOutlet weak var LaplacianFilterLabel: NSButton!
    //二値化処理のフィルタ
    @IBOutlet weak var PercentileMethodFilterLable: NSButton!
    @IBOutlet weak var DilationFilterLabel: NSButton!
    @IBOutlet weak var ErosionFilterLabel: NSButton!
    //出力用のビュー
    @IBOutlet weak var OutPutImg: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //平滑化処理のフィル(初期化)
        GaussianBlurFirterLabel.isHidden = true
        blurFirterLabel.isHidden = true
        //エッジ処理のフィルタ(初期化)
        SobelFirterLabel.isHidden = true
        PrewittFilterLabel.isHidden = true
        LaplacianFilterLabel.isHidden = true
        //二値化処理のフィルタ(初期化)
        PercentileMethodFilterLable.isHidden = true
        DilationFilterLabel.isHidden = true
        ErosionFilterLabel.isHidden = true
        
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

    @IBAction func OpenOrCloseButton1(_ sender: NSButton) {
        if(SmoothingButton.frameCenterRotation == 0){
        SmoothingButton.frameCenterRotation = SmoothingButton.frameCenterRotation + 270
            
            blurFirterLabel.isHidden = false
            GaussianBlurFirterLabel.isHidden = false
            
            edgeView.frame.origin.y = edgeView.frame.origin.y - 55
            binaryView.frame.origin.y = binaryView.frame.origin.y - 60
            
            
        }else{
            SmoothingButton.frameCenterRotation = SmoothingButton.frameCenterRotation - 270
            
            blurFirterLabel.isHidden = true
            GaussianBlurFirterLabel.isHidden = true
            
            edgeView.frame.origin.y = edgeView.frame.origin.y + 55
            binaryView.frame.origin.y = binaryView.frame.origin.y + 60
        }
    }
    
    @IBAction func OpenOrCloseButton2(_ sender: NSButton) {
        if(EdgeButton.frameCenterRotation == 0){
            EdgeButton.frameCenterRotation = EdgeButton.frameCenterRotation + 270
            
            SobelFirterLabel.isHidden = false
            PrewittFilterLabel.isHidden = false
            LaplacianFilterLabel.isHidden = false
            
            binaryView.frame.origin.y = binaryView.frame.origin.y - 78
            
            
        }else{
            EdgeButton.frameCenterRotation = EdgeButton.frameCenterRotation - 270
            
            SobelFirterLabel.isHidden = true
            PrewittFilterLabel.isHidden = true
            LaplacianFilterLabel.isHidden = true
            
            binaryView.frame.origin.y = binaryView.frame.origin.y + 78
        }
    }
    
    @IBAction func OpenOrCloseButton3(_ sender: NSButton) {
        if(BinaryButton.frameCenterRotation == 0){
            BinaryButton.frameCenterRotation = BinaryButton.frameCenterRotation + 270
            
            PercentileMethodFilterLable.isHidden = false
            DilationFilterLabel.isHidden = false
            ErosionFilterLabel.isHidden = false
            
        }else{
            BinaryButton.frameCenterRotation = BinaryButton.frameCenterRotation - 270
            
            PercentileMethodFilterLable.isHidden = true
            DilationFilterLabel.isHidden = true
            ErosionFilterLabel.isHidden = true

        }
    }

    @IBAction func AddFlow(_ sender: NSButton) {
        switch sender.title {
        case "平均化フィルタ":
            MakeLabel(LabelTitle: "平均化フィルタ")
            break
        case "重み付き平均化フィルタ":
            MakeLabel(LabelTitle: "重み付き平均化フィルタ")
            break
        case "ソーベルフィルタ":
            MakeLabel(LabelTitle: "ソーベルフィルタ")
            break
        case "プリューウィットフィルタ":
            MakeLabel(LabelTitle: "プリューウィットフィルタ")
            break
        case "ラプラシアンフィルタ":
            MakeLabel(LabelTitle: "ラプラシアンフィルタ")
            break
        case "Pタイル法":
            MakeLabel(LabelTitle: "Pタイル法")
            break
        case "膨張":
            MakeLabel(LabelTitle: "膨張")
            break
        case "収縮":
            MakeLabel(LabelTitle: "収縮")
            break
        default:
            break

        }
    }
    func MakeLabel(LabelTitle: String){
        let label = NSTextField()
        label.frame = CGRect(x: 465, y: 342, width: 75, height: 26)
        label.stringValue = LabelTitle as String
        self.view.addSubview(label)
    }
}

