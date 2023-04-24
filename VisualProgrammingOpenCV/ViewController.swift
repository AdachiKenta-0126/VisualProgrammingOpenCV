//
//  ViewController.swift
//  VisualProgrammingOpenCV
//
//  Created by k18004kk on 2020/08/10.
//  Copyright © 2020 AIT. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

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
    
    //効果音
    var audioPlayer: AVAudioPlayer?
    
    //フローで画像入力にリンクされている数
    var SetFlowCount = 0
    
    //現在指定されているラベル
    var CurrentLabelTag = 0
    
    @IBOutlet weak var SetImageButton: NSTextField!
    //平滑化処理のフィルタボタン
    var GaussianBlurFirterButton: NSTextField?
    var blurFirterButton: NSTextField?
    //エッジ処理のフィルタボタン
    var SobelFirterButton: NSTextField?
    var PrewittFilterButton: NSTextField?
    var LaplacianFilterButton: NSTextField?
    //二値化処理のフィルタボタン
    var PercentileMethodFilterButton: NSTextField?
    var DilationFilterButton: NSTextField?
    var ErosionFilterButton: NSTextField?
    
    var FlowArray:NSMutableArray = [0]
    @IBOutlet weak var ThSlider: NSSlider!
    @IBOutlet weak var ThTextField: NSTextField!
    
    @IBOutlet weak var SelectColorComboBox: NSComboBox!
    var image:NSImage?
    
    @IBOutlet weak var SelectImgButton: NSButton!
    @IBOutlet weak var FlowText1: NSTextField!
    
    @IBOutlet weak var dilateCount: NSComboBox!
    @IBOutlet weak var FlowText2: NSTextField!
    
    @IBOutlet weak var erodeCount: NSComboBox!
    @IBOutlet weak var FlowText3: NSTextField!
    
    @IBOutlet weak var ksizeCount: NSComboBox!
    @IBOutlet weak var Flowtext4: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //平滑化処理のフィルタ(初期化)
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
        
        image = NSImage(named: "NOimage.png")
        OutPutImg.image =  image
        
        //タップ
        let singleClickGesture = NSClickGestureRecognizer()
            singleClickGesture.target = self
            singleClickGesture.numberOfClicksRequired = 1
            singleClickGesture.buttonMask = 0x1
            singleClickGesture.action = #selector(ViewController.singleClickGesture)
        
        SetImageButton.addGestureRecognizer(singleClickGesture)
        ThTextField.isEditable = false
        SelectColorComboBox.isEditable = false
        
        SelectColorComboBox.isHidden = true
        SelectImgButton.isHidden = true
        
        FlowText1.isHidden = true
        ThTextField.isHidden = true
        ThSlider.isHidden = true
        
        dilateCount.isHidden = true
        FlowText2.isHidden = true
        
        erodeCount.isHidden = true
        FlowText3.isHidden = true
        
        ksizeCount.isHidden = true
        Flowtext4.isHidden = true
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
        dialog.begin { [self] (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {// ファイルを選択したか(OKを押したか)
                guard dialog.url != nil else { return }
                //log.info(url.absoluteString)
                // ここでファイルを読み込む
                self.image = NSImage(contentsOf: dialog.url!)
                self.OutPutImg.image = convertColor(source: image!)
                
            }
        }
        
    }
    func convertColor(source srcImage: NSImage) -> NSImage {
        var dstImage :NSImage = image!
        for Value in 0...FlowArray.count - 1 {
            outside: switch FlowArray[Value] as! Int{
                case 0:
                dstImage = OpenCVWrapper.grayInputImage(srcImage,myArgument: SelectColorComboBox.stringValue) as! NSImage
                    break outside
                case 1:
                    
                    break outside
                case 2:
                    
                    break outside
                case 3:
                dstImage = OpenCVWrapper.sobel(dstImage,myArgument: NSNumber(value: ksizeCount.integerValue)) as! NSImage
                    break outside
                case 4:
                    
                    break outside
                case 5:
                    
                    break outside
                case 6:
                dstImage = OpenCVWrapper.twoColorImage(dstImage ,myArgument: NSNumber(value: ThSlider.integerValue)) as! NSImage
                    break outside
                case 7:
                dstImage = OpenCVWrapper.dilate(dstImage ,myArgument: NSNumber(value: dilateCount.integerValue)) as! NSImage
                    break outside
                case 8:
                dstImage = OpenCVWrapper.erode(dstImage ,myArgument: NSNumber(value: erodeCount.integerValue)) as! NSImage
                    break outside
                default: break outside
            }
        }
   
        return dstImage
    }

    @IBAction func OpenOrCloseButton1(_ sender: NSButton) {
        print(SmoothingButton.frameCenterRotation)
        if(SmoothingButton.frameCenterRotation == 0){
        SmoothingButton.frameCenterRotation = SmoothingButton.frameCenterRotation - 90
            
            blurFirterLabel.isHidden = false
            GaussianBlurFirterLabel.isHidden = false
            
            edgeView.frame.origin.y = edgeView.frame.origin.y - 55
            binaryView.frame.origin.y = binaryView.frame.origin.y - 60
            
            
        }else{
            SmoothingButton.frameCenterRotation = SmoothingButton.frameCenterRotation + 90
            
            blurFirterLabel.isHidden = true
            GaussianBlurFirterLabel.isHidden = true
            
            edgeView.frame.origin.y = edgeView.frame.origin.y + 55
            binaryView.frame.origin.y = binaryView.frame.origin.y + 60
        }
    }
    
    @IBAction func OpenOrCloseButton2(_ sender: NSButton) {
        if(EdgeButton.frameCenterRotation == 0){
            EdgeButton.frameCenterRotation = EdgeButton.frameCenterRotation - 90
            SobelFirterLabel.isHidden = false
            PrewittFilterLabel.isHidden = false
            LaplacianFilterLabel.isHidden = false
            
            binaryView.frame.origin.y = binaryView.frame.origin.y - 78
            
        }else{
            EdgeButton.frameCenterRotation = EdgeButton.frameCenterRotation + 90
            
            SobelFirterLabel.isHidden = true
            PrewittFilterLabel.isHidden = true
            LaplacianFilterLabel.isHidden = true
            
            binaryView.frame.origin.y = binaryView.frame.origin.y + 78
        }
    }
    
    @IBAction func OpenOrCloseButton3(_ sender: NSButton) {
        if(BinaryButton.frameCenterRotation == 0){
            BinaryButton.frameCenterRotation = BinaryButton.frameCenterRotation - 90
            
            PercentileMethodFilterLable.isHidden = false
            DilationFilterLabel.isHidden = false
            ErosionFilterLabel.isHidden = false
            
        }else{
            BinaryButton.frameCenterRotation = BinaryButton.frameCenterRotation + 90
            
            PercentileMethodFilterLable.isHidden = true
            DilationFilterLabel.isHidden = true
            ErosionFilterLabel.isHidden = true
        }
    }

    @IBAction func AddFlow(_ sender: NSButton) {
        switch sender.title {
        case "平均化フィルタ":
            MakeButton(ButtonTitle: "平均化フィルタ")
            break
        case "重み付き平均化フィルタ":
            MakeButton(ButtonTitle: "重み付き平均化フィルタ")
            break
        case "ソーベルフィルタ":
            MakeButton(ButtonTitle: "ソーベルフィルタ")
            break
        case "プリューウィットフィルタ":
            MakeButton(ButtonTitle: "プリューウィットフィルタ")
            break
        case "ラプラシアンフィルタ":
            MakeButton(ButtonTitle: "ラプラシアンフィルタ")
            break
        case "二値化":
            MakeButton(ButtonTitle: "二値化")
            break
        case "膨張":
            MakeButton(ButtonTitle: "膨張")
            break
        case "収縮":
            MakeButton(ButtonTitle: "収縮")
            break
        default:
            break

        }
        sender.isEnabled = false
    }
    
    //デリートキーが押された時
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 51{
            switch CurrentLabelTag {
                case 1:
                    blurFirterButton?.removeFromSuperview()
                    blurFirterLabel?.isEnabled = true
                    deleteArray(CheckNum: 1)
                    break
                case 2:
                    GaussianBlurFirterButton?.removeFromSuperview()
                    GaussianBlurFirterLabel?.isEnabled = true
                    deleteArray(CheckNum: 2)
                    break
                case 3:
                    SobelFirterButton?.removeFromSuperview()
                    SobelFirterLabel?.isEnabled = true
                    deleteArray(CheckNum: 3)
                    break
                case 4:
                    PrewittFilterButton?.removeFromSuperview()
                    PrewittFilterLabel?.isEnabled = true
                    deleteArray(CheckNum: 4)
                    break
                case 5:
                    LaplacianFilterButton?.removeFromSuperview()
                    LaplacianFilterLabel?.isEnabled = true
                    deleteArray(CheckNum: 5)
                    break
                case 6:
                    PercentileMethodFilterButton?.removeFromSuperview()
                    PercentileMethodFilterLable?.isEnabled = true
                    deleteArray(CheckNum: 6)
                    break
                case 7:
                    DilationFilterButton?.removeFromSuperview()
                    DilationFilterLabel?.isEnabled = true
                    deleteArray(CheckNum: 7)
                    break
                case 8:
                    ErosionFilterButton?.removeFromSuperview()
                    ErosionFilterLabel?.isEnabled = true
                    deleteArray(CheckNum: 8)
                    break
                default: break
            }
            CurrentLabelTag = 0
        }
    }
    //不要な要素を消す
    func deleteArray(CheckNum: Int){
        var Count = 1
        
        SelectColorComboBox.isHidden = true
        SelectImgButton.isHidden = true
        
        FlowText1.isHidden = true
        ThTextField.isHidden = true
        ThSlider.isHidden = true
        
        dilateCount.isHidden = true
        FlowText2.isHidden = true
        
        erodeCount.isHidden = true
        FlowText3.isHidden = true
        
        ksizeCount.isHidden = true
        Flowtext4.isHidden = true
        
        for Value in FlowArray {
            if(Value as! Int == CheckNum){
                if(Count == 2 && FlowArray.count == 2 || Count == FlowArray.count){
                    SetFlowCount -= FlowArray.count - Count + 1
                }else{
                    resetStatus(checkPoint: Count)
                }
                FlowArray.removeObjects(in: NSRange(location: Count - 1,length: FlowArray.count - Count + 1))
                print(FlowArray)
                break
            }else{
                Count += 1
            }
        }
        self.OutPutImg.image = convertColor(source: image!)
    }
    func resetStatus(checkPoint: Int){
        SetFlowCount -= FlowArray.count - checkPoint + 1
        
        for Value in checkPoint...FlowArray.count - 1 {
            //ドラッグ
            let PanGesture = NSPanGestureRecognizer()
                PanGesture.target = self
                PanGesture.buttonMask = 0x1
                PanGesture.action = #selector(ViewController.PanGesture)
            print(FlowArray[Value] as! Int)
            outside: switch FlowArray[Value] as! Int{
                case 1:
                    blurFirterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 2:
                    GaussianBlurFirterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 3:
                    SobelFirterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 4:
                    PrewittFilterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 5:
                    LaplacianFilterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 6:
                    PercentileMethodFilterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 7:
                    DilationFilterButton?.addGestureRecognizer(PanGesture)
                    break outside
                case 8:
                    ErosionFilterButton?.addGestureRecognizer(PanGesture)
                    break outside
                default: break outside
            }
        }
    }
    func MakeButton(ButtonTitle: String){
        //タップ
        let singleClickGesture = NSClickGestureRecognizer()
            singleClickGesture.target = self
            singleClickGesture.numberOfClicksRequired = 1
            singleClickGesture.buttonMask = 0x1
            singleClickGesture.action = #selector(ViewController.singleClickGesture)
        //ドラッグ
        let PanGesture = NSPanGestureRecognizer()
            PanGesture.target = self
            PanGesture.buttonMask = 0x1
            PanGesture.action = #selector(ViewController.PanGesture)
        
        let MakeButton = NSTextField(string: ButtonTitle as String)
            MakeButton.frame = CGRect(x: 465, y: 342, width: 175, height: 26)
            MakeButton.font = NSFont.systemFont(ofSize: 15.0)
            MakeButton.isEditable = false
            MakeButton.isBordered = true
            MakeButton.drawsBackground = false
            MakeButton.isSelectable = false
        
        MakeButton.addGestureRecognizer(singleClickGesture)
        MakeButton.addGestureRecognizer(PanGesture)
        
            switch  ButtonTitle{
                case "平均化フィルタ":
                    blurFirterButton =  MakeButton
                    blurFirterButton!.tag = 1
                    self.view.addSubview(blurFirterButton!)
                    break
                case "重み付き平均化フィルタ":
                    GaussianBlurFirterButton =  MakeButton
                    GaussianBlurFirterButton!.tag = 2
                    self.view.addSubview(GaussianBlurFirterButton!)
                    break
                case "ソーベルフィルタ":
                    SobelFirterButton =  MakeButton
                    SobelFirterButton!.tag = 3
                    self.view.addSubview(SobelFirterButton!)
                    break
                case "プリューウィットフィルタ":
                    PrewittFilterButton =  MakeButton
                    PrewittFilterButton!.tag = 4
                    self.view.addSubview(PrewittFilterButton!)
                    break
                case "ラプラシアンフィルタ":
                    LaplacianFilterButton =  MakeButton
                    LaplacianFilterButton!.tag = 5
                    self.view.addSubview(LaplacianFilterButton!)
                    break
                case "二値化":
                    PercentileMethodFilterButton =  MakeButton
                    PercentileMethodFilterButton!.tag = 6
                    self.view.addSubview(PercentileMethodFilterButton!)
                    break
                case "膨張":
                    DilationFilterButton =  MakeButton
                    DilationFilterButton!.tag = 7
                    self.view.addSubview(DilationFilterButton!)
                    break
                case "収縮":
                    ErosionFilterButton =  MakeButton
                    ErosionFilterButton!.tag = 8
                    self.view.addSubview(ErosionFilterButton!)
                    break
                default: break
            }
            
    }
    
    @objc func singleClickGesture(gesture: NSClickGestureRecognizer) {
        if let LabelCheck = gesture.view as? NSTextField {
            setCurrentColor(addField: LabelCheck)
            if LabelCheck != SetImageButton{
                CurrentLabelTag = LabelCheck.tag
            }
        }
    }
    
    @objc func PanGesture(gesture: NSPanGestureRecognizer) {
        if let LabelCheck = gesture.view as? NSTextField {
            
            setCurrentColor(addField: LabelCheck)
            CurrentLabelTag = LabelCheck.tag
            
            let move = gesture.translation(in: self.view)
            var LabelPointX = LabelCheck.frame.origin.x
            var LabelPointY = LabelCheck.frame.origin.y
            LabelPointX = LabelCheck.frame.origin.x + move.x
            LabelPointY = LabelCheck.frame.origin.y + move.y
            
            if(LabelPointY >= CGFloat(555 - SetFlowCount * 26) && LabelPointY <= CGFloat(565 - SetFlowCount * 26) && LabelPointX >= CGFloat(290 + SetFlowCount * 44) && LabelPointX <= CGFloat(350 + SetFlowCount * 44)){
                LabelCheck.frame = CGRect(x: 320 + SetFlowCount * 44, y: 560 - SetFlowCount * 26, width: 175, height: 26)
                SetFlowCount += 1
                print(SetFlowCount)
                
                //配列の要素数と要素の挿入
                let FlowArrayNum = FlowArray.count
                FlowArray.insert(LabelCheck.tag, at: FlowArrayNum)
                print(FlowArray)
                
                LabelCheck.removeGestureRecognizer(gesture)
                
                //効果音のセット
                setAudio()
                audioPlayer?.play()

            }else{
                LabelCheck.frame = CGRect(x: LabelPointX, y: LabelPointY, width: 175, height: 26)
                
                gesture.setTranslation(NSPoint(x: 0, y: 0), in: self.view)
            }
            self.OutPutImg.image = convertColor(source: image!)
        }
    }

    func setAudio(){

        let setURL = Bundle.main.url(forResource: "click1",withExtension: "mp3")

        if let selectURL = setURL{
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: selectURL, fileTypeHint: nil)
            }catch{
                print("ERROR")
            }
        }
    }
    func setCurrentColor(addField: NSTextField){
        
        SetImageButton.layer?.borderWidth = 0
        
        if blurFirterButton != nil{
            blurFirterButton!.layer?.borderWidth = 0
        }
        if GaussianBlurFirterButton != nil{
            GaussianBlurFirterButton!.layer?.borderWidth = 0
        }
        if SobelFirterButton != nil{
            SobelFirterButton!.layer?.borderWidth = 0
        }
        if PrewittFilterButton != nil{
            PrewittFilterButton!.layer?.borderWidth = 0
        }
        if LaplacianFilterButton != nil{
            LaplacianFilterButton!.layer?.borderWidth = 0
        }
        if PercentileMethodFilterButton != nil{
            PercentileMethodFilterButton!.layer?.borderWidth = 0
        }
        if DilationFilterButton != nil{
            DilationFilterButton!.layer?.borderWidth = 0
        }
        if ErosionFilterButton != nil{
            ErosionFilterButton!.layer?.borderWidth = 0
        }

        addField.wantsLayer = true
        addField.layer?.borderColor = NSColor.red.cgColor
        addField.layer?.borderWidth = 3
        
        SelectColorComboBox.isHidden = true
        SelectImgButton.isHidden = true
        
        FlowText1.isHidden = true
        ThTextField.isHidden = true
        ThSlider.isHidden = true
        
        dilateCount.isHidden = true
        FlowText2.isHidden = true
        
        erodeCount.isHidden = true
        FlowText3.isHidden = true
        
        ksizeCount.isHidden = true
        Flowtext4.isHidden = true
        
        switch   addField.tag{
            
            case 1:
                
                break
            case 2:
                
                break
            case 3:
                ksizeCount.isHidden = false
                Flowtext4.isHidden = false
                break
            case 4:
                
                break
            case 5:
                
                break
            case 6:
                FlowText1.isHidden =  false
                ThTextField.isHidden =  false
                ThSlider.isHidden =   false
                break
            case 7:
                dilateCount.isHidden = false
                FlowText2.isHidden = false
                break
            case 8:
                erodeCount.isHidden = false
                FlowText3.isHidden = false
                break
            default:
                SelectColorComboBox.isHidden =  false
                SelectImgButton.isHidden = false
                break
        }
    }
    @IBAction func SaveDstImage(_ sender: NSButton) {
        let saveImage = OutPutImg.image
        
        let timeInterval = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeInterval)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let timestamp = formatter.string(from: time as Date)
        
        let savePanel = NSSavePanel()
        savePanel.canCreateDirectories = true
        savePanel.showsTagField = false
        savePanel.allowedFileTypes = ["png","jpg"]
        savePanel.allowsOtherFileTypes = false
        savePanel.nameFieldStringValue = "\(timestamp).png"
        
        savePanel.begin { (result) in
                if result == NSApplication.ModalResponse.OK {
                    guard let tiffData = saveImage?.tiffRepresentation, //画像をTIFFのDataにする
                        let imageRep = NSBitmapImageRep(data: tiffData), //bitmapデータを描画？
                        let imageData = imageRep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 0.7)]) //JPEGに変換
                        else {
                            print("画像変換エラー")
                            return
                    }
                    //画像保存処理
                    do {
                        try imageData.write(to: savePanel.url!)
                    } catch {
                        print("保存エラー \(error)")
                    }
                }
        }
    }
    @IBAction func sliderAction(_ sender: Any) {
        ThTextField.stringValue = "\(ThSlider.integerValue)"
        
        let dstImage = convertColor(source: image!)
        self.OutPutImg.image = dstImage
        
    }
    @IBAction func ChangeSelectComboBox(_ sender: Any) {
        let dstImage = convertColor(source: image!)
        self.OutPutImg.image = dstImage
    
    }
    @IBAction func ChangeSelect_dilate(_ sender: Any) {
        let dstImage = convertColor(source: image!)
        self.OutPutImg.image = dstImage
    }
    @IBAction func ChangeSelect_erode(_ sender: Any) {
        let dstImage = convertColor(source: image!)
        self.OutPutImg.image = dstImage
    }
    @IBAction func ChangeSelect_ksize(_ sender: Any) {
        let dstImage = convertColor(source: image!)
        self.OutPutImg.image = dstImage
    }
}

