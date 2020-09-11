//
//  TopViewController.swift
//  ColorPicker
//
//  Created by 能美龍星 on 2020/09/10.
//  Copyright © 2020 Ryusei Nomi. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    let label = UILabel()
    let imageLoadButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.imageLoadButton.addTarget(self, action: #selector(self.loadImage(_ :)), for: .touchUpInside)
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

    @objc public func loadImage(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
}

