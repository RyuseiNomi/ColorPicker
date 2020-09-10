//
//  ViewController.swift
//  ColorPicker
//
//  Created by 能美龍星 on 2020/09/10.
//  Copyright © 2020 Ryusei Nomi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        label.text = "Hello, World"
        label.textAlignment = .center
        label.textColor = .black
        view.addSubview(label)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = view.bounds
    }
}

