//
//  ViewController.swift
//  CameraGallery
//
//  Created by Mahendra Vishwakarma on 25/02/19.
//  Copyright © 2019 Mahendra Vishwakarma. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class imageCell:UICollectionViewCell{
    @IBOutlet weak var image: UIImageView!
    
}

class CameraViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

   // var photos = [UIImage]()
    var photos : PHFetchResult<PHAsset>?
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    var initialY:CGFloat = 0.0
    @IBOutlet weak var btnFlash: NSLayoutConstraint!
    @IBOutlet weak var viewFlash: UIView!
    @IBOutlet weak var btnFlashON: UIButton!
    @IBOutlet weak var btnFlashOff: UIButton!
    @IBOutlet weak var btnFlashAuto: UIButton!
    var selected_imagename:String!
    var homeObject:AnyObject!
    @IBOutlet weak var tappedView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPhotos: UIView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        initialY = viewPhotos.frame.origin.y
        
        btnCamera.layer.cornerRadius = 30
        btnCamera.layer.masksToBounds = true
        btnCamera.layer.borderColor = UIColor.white.cgColor
        btnCamera.layer.borderWidth = 2
        viewFlash.layer.cornerRadius = viewFlash.frame.height/2
        viewFlash.layer.masksToBounds = true
        
        setupCaptureSession()
        setupDevice(cameraType: AVCaptureDevice.Position.back)
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    @IBAction func btnCross(_ sender: Any) {
        viewHeight.constant = 128
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        initialY  = location.y
    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self.view)
        //collectionView.dragInteractionEnabled = true
        let totalY = initialY - location.y
        print(totalY)
        if(viewPhotos.frame.origin.y > location.y && location.y > 20 && initialY > location.y){
            
           // UIView.animate(withDuration: 0.4) {
            if(totalY > 40){
                 UIView.animate(withDuration: 0.4) {
                    self.viewHeight.constant = self.initialY + 90
                }
                
            }else{
                self.viewHeight.constant +=  totalY
            }
            
          //  }
        }
       
        //print(location.y)
    }
    @IBAction func btnFlashOff(_ sender: UIButton) {
        
        let selectedImage = sender.imageView?.image
        btnFlashON.isSelected = false
        currentFlashMode = .off
        //selectedImage =  selectedImage?.maskWithColor(color: .yellow)
       /// sender.setImage(selectedImage, for: .normal)
        let widths = btnFlash.constant == 130 ? 40 : 130
        self.flashExpand_collapse(widths: CGFloat(widths), image: selectedImage!)
    }
    @IBAction func btnFlashAuto(_ sender: UIButton) {
        
        let selectedImage = sender.imageView?.image
        btnFlashON.isSelected = false
        currentFlashMode = .auto
        //selectedImage =  selectedImage?.maskWithColor(color: .yellow)
        //sender.setImage(selectedImage, for: .normal)
        let widths = btnFlash.constant == 130 ? 40 : 130
        self.flashExpand_collapse(widths: CGFloat(widths), image: selectedImage!)
    }
    
    var captureSession = AVCaptureSession()
    var backCamera : AVCaptureDevice?
    var frontCamera : AVCaptureDevice?
    var currentCamera : AVCaptureDevice?
    var photoOutput : AVCapturePhotoOutput?
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var currentFlashMode : CurrentFlashMode!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width*2, height: 0)
         currentFlashMode = .auto
         var imageFlashAuto = btnFlashAuto.imageView?.image
         imageFlashAuto = imageFlashAuto?.maskWithColor(color: .yellow)
         btnFlashAuto.setImage(imageFlashAuto, for: .normal)
        
        PHAssestLib.fetchImage { (images) in
           self.photos = images
            self.collectionView.reloadData()
        }
        
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = photos?.count else{
         return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imageCell
        
        let assest = photos?.object(at: indexPath.row)
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        options.isNetworkAccessAllowed = false
        
        PHImageManager.default().requestImageData(for: assest!, options: options) { data, uti, orientation, info in
            guard let data =  data else{
                    return
                }

                guard let image = UIImage(data: data) else{
                    return
                }

             cell.image.image = image

            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! imageCell
         self.performSegue(withIdentifier: "cropimage", sender: cell.image.image)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.width/3-8/3
        return CGSize(width:size , height: size)
    }
    
    func setupCaptureSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
    }

    func setupDevice(cameraType:AVCaptureDevice.Position){
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == cameraType{
                currentCamera = device
                break
            }
        }
        
       // currentCamera = backCamera
    }
    
    func setupInputOutput(){
        
        do{
            if(currentCamera != nil){
                let captureDeviceInput =  try AVCaptureDeviceInput(device: currentCamera!)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            }
            
        }catch let error{
            print(error)
        }
    }
    
    func setupPreviewLayer(){
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = self.view.bounds
        self.cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    
    func getSettings(camera: AVCaptureDevice, flashMode: CurrentFlashMode) -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        
        if camera.hasFlash {
            switch flashMode {
            case .auto: settings.flashMode = .auto
            case .on: settings.flashMode = .on
            default: settings.flashMode = .off
            }
        }
        return settings
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func btnFlash(_ sender: UIButton) {
    
        var currentImage = UIImage(named: "flash")
        var imageFlashOff = btnFlashOff.imageView?.image
        var imageFlashAuto = btnFlashAuto.imageView?.image
        
        currentImage = currentImage!.maskWithColor(color: .white)
        imageFlashOff = imageFlashOff!.maskWithColor(color: .white)
        imageFlashAuto = imageFlashAuto!.maskWithColor(color: .white)
        
        if(currentFlashMode == .auto){
            imageFlashAuto = imageFlashAuto?.maskWithColor(color: .yellow)
        }
        
        if(currentFlashMode == .off){
            imageFlashOff = imageFlashOff?.maskWithColor(color: .yellow)
        }
        
        if(sender.isSelected){
            currentFlashMode = .on
            currentImage = currentImage?.maskWithColor(color: .yellow)
        }
        
        sender.isSelected = true
        sender.setImage(currentImage, for: .normal)
        btnFlashAuto.setImage(imageFlashAuto, for: .normal)
        btnFlashOff.setImage(imageFlashOff, for: .normal)
        
        let widths = btnFlash.constant == 130 ? 40 : 130
        let showImage = widths == 130 ? currentImage : currentImage?.maskWithColor(color: .white)
        self.flashExpand_collapse(widths: CGFloat(widths), image: showImage!)
        
    }
    
    func flashExpand_collapse(widths:CGFloat,image:UIImage) {
        UIView.animate(withDuration: 0.5) {
            
            self.btnFlash.constant = widths
            self.viewFlash.backgroundColor = widths == 130 ? UIColor(red: 0, green: 0, blue: 0, alpha: 0.4): UIColor.clear
            self.btnFlashON.setImage(image, for: .normal)
        }
    }
    
   
   
    
    @IBAction func swapButton(_ sender: Any) {
       
        if(cameraPreviewLayer != nil){
            captureSession.removeInput(captureSession.inputs.first!)
            cameraPreviewLayer?.removeFromSuperlayer()
        }
        
        
        let camera = currentCamera?.position == AVCaptureDevice.Position.back ? AVCaptureDevice.Position.front:AVCaptureDevice.Position.back
        
        setupCaptureSession()
        setupDevice(cameraType: camera)
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    @IBAction func captureImage(_ sender: Any) {
        if(currentCamera != nil){
            let settings = getSettings(camera: currentCamera!, flashMode: currentFlashMode)
            
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }else{
            self.showToast(message: "Camera not available")
        }
    
    }
}

extension CameraViewController:AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){

            self.performSegue(withIdentifier: "cropimage", sender: UIImage(data: imageData))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let image = sender as! UIImage
        let object = segue.destination as! imageOrientationVC
        object.img_selected = image
        object.selected_imagename = selected_imagename
        object.homeObject = homeObject
    }
    
   
}

enum CurrentFlashMode {
    case off
    case on
    case auto
}

extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
