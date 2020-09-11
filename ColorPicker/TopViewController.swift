//
//  TopViewController.swift
//  ColorPicker
//
//  Created by 能美龍星 on 2020/09/10.
//  Copyright © 2020 Ryusei Nomi. All rights reserved.
//

import UIKit
import AVFoundation

class TopViewController: UIViewController {

    let label = UILabel()
    let imageLoadButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.imageLoadButton.addTarget(self, action: #selector(self.capture(_ :)), for: .touchUpInside)
        self.view.addSubview(imageLoadButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let viewx = self.view.frame.width
        let viewy = self.view.frame.height
        /* 画像読み込みボタンのレイアウト設定*/
        self.imageLoadButton.frame = CGRect(x: viewx / 8, y: viewy / 2, width: 300, height: 70)
        self.imageLoadButton.setTitle("画像を読み込む", for: .normal)
        self.imageLoadButton.setTitleColor(.white, for: .normal)
        self.imageLoadButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        self.imageLoadButton.layer.cornerRadius = 25
        self.imageLoadButton.layer.shadowOpacity = 0.5
        self.imageLoadButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }

    @objc public func capture(_ sender: UIButton) {
        print("button tapped")
        let cameraManager = CameraManager()
        cameraManager.capture()
    }
}

class CameraManager {
    
    var session = AVCaptureSession() // デバイスからの入力と出力を管理するオブジェクト
    var cameraPreviewLayer = AVCaptureVideoPreviewLayer() //画面表示レイヤーオブジェクト

    public func capture() {
        print("デバイス探索中")
        session.sessionPreset = AVCaptureSession.Preset.photo // カメラの画質の設定
        let camera = self.setupDevice()
        if camera == nil {
            print("デバイスが見つかりませんでした。")
        }
        setInputOutput(camera: camera)
        setupPreviewLayer()
        print("画面に描画する")
        session.startRunning()
    }
    
    // AVCaptureDeviceクラスから取得されたデバイスのうち、背面カメラを取得する
    // 背面カメラが見つからなかった場合にnilを返却する
    private func setupDevice() -> AVCaptureDevice? {
        // ビデオと背面カメラを管理するオブジェクトの生成
        let discoveredDeviceSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        let discoveredDevices = discoveredDeviceSession.devices // 条件に合ったデバイスの取得
        for device in discoveredDevices {
            if device.position == AVCaptureDevice.Position.back {
                return device
            }
        }
        return nil
    }
    
    // デバイスのカメラの入力の初期化
    private func setInputOutput(camera: AVCaptureDevice?) {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: camera!)
            session.addInput(captureDeviceInput) // 初期化されたデバイスをSessionに追加
            let photoOutput = AVCapturePhotoOutput()
            session.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
    
    // カメラからの映像を画面に表示するためのレイヤーの設定を行う
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        // 縦横比の設定
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤーの表示の向きを設定
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = TopViewController().view.frame
    }
}
