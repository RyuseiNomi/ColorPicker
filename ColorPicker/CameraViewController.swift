//
//  CameraViewController.swift
//  ColorPicker
//
//  Created by 能美龍星 on 2020/09/11.
//  Copyright © 2020 Ryusei Nomi. All rights reserved.
//

import UIKit
import AVFoundation

/// デバイスのカメラから写真を読み込み、映像をViewに表示する処理を担うクラス
/// [参考] https://qiita.com/t_okkan/items/f2ba9b7009b49fc2e30a
class CameraViewController: UIViewController {
   

    var frame = CALayer()
    var shutterButton = CALayer()
    var session = AVCaptureSession() // デバイスからの入力と出力を管理するオブジェクト
    var cameraPreviewLayer = AVCaptureVideoPreviewLayer() //画面表示レイヤーオブジェクト
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        let camera = setupDevice()
        if camera == nil {
            print("デバイスが見つかりませんでした。")
        }
        setInputOutput(camera: camera)
        setupPreviewLayer()
        session.startRunning()
    }
    
}

extension CameraViewController {
    
    /// カメラ画質の設定
    private func setupCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    /// AVCaptureDeviceクラスから取得されたデバイスのうち、背面カメラを取得する
    /// 背面カメラが見つからなかった場合にnilを返却する
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
    
    /// デバイスのカメラの入力の初期化
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
    
    /// カメラからの映像を画面に表示するためのレイヤーの設定を行う
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        // 縦横比の設定
        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤーの表示の向きを設定
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = view.frame
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        self.setCameraFrameLine()
        self.setShutterButton()
    }
    
    /// 枠線レイヤーの設定とカメラレイヤーへの追加
    private func setCameraFrameLine() {
        frame.frame = CGRect(x: cameraPreviewLayer.frame.width/2, y: cameraPreviewLayer.frame.height/2, width: 100, height: 100)
        frame.isOpaque = false
        frame.borderColor = UIColor.red.cgColor
        frame.borderWidth = 2.0
        cameraPreviewLayer.addSublayer(frame)
    }
    
    /// 読み込みボタンの設定とカメラレイヤーへの追加
    private func setShutterButton() {
        shutterButton.frame = CGRect(
            x: cameraPreviewLayer.frame.width/2,
            y: cameraPreviewLayer.frame.height - cameraPreviewLayer.frame.width/3,
            width:80, height:80
        )
        shutterButton.backgroundColor = UIColor.yellow.cgColor
        shutterButton.cornerRadius = 40.0
        shutterButton.masksToBounds = true
        cameraPreviewLayer.addSublayer(shutterButton)
    }
}
