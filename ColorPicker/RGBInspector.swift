//
//  RGBInspector.swift
//  ColorPicker
//
//  Created by 能美龍星 on 2020/09/12.
//  Copyright © 2020 Ryusei Nomi. All rights reserved.
//

import UIKit

/// UIImageからRGB値を取得する一連の処理を担うクラス
class RGBInspector {
    
    var uiImage: UIImage?
    
    public init(image: UIImage) {
        self.uiImage = image
    }
    
    /// UIImageから特定の範囲のピクセルのRGB値を取得する
    public func getRgbColorFromUIImage() -> [String: Int]{
        let cgImage = uiImage?.cgImage // UIImageをCGImageへ変換
        let pixelData = cgImage?.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(pixelData)
        let pixelAddress = getPixelAddress(cgImage: cgImage!)
        
        // 取得したピクセルアドレスを基に、画像のRGB値を取得する
        // TODO:なぜ+1や+2をしているのかを調べる
        let r = Int( CGFloat(data[pixelAddress]) )
        let g = Int( CGFloat(data[pixelAddress+1]) )
        let b = Int( CGFloat(data[pixelAddress+2]) )
        let a = CGFloat(Int( CGFloat(data[pixelAddress+3]) / CGFloat(255.0)*100 )) / 100
        
        // 取得したRGB値を連想配列に格納して返却する
        let rgb = ["Red": r, "Green":g, "Blue":b]
        return rgb
    }
    
    /// RGB値を調べる対象になっているピクセルのアドレス群を取得
    /// 今回はCameraPreviewLayerの中央から100×100の範囲が対象となっている。
    /// 固定範囲ではなく、ユーザがタップした場所のRGBを取るなどの機能変更がある場合は、このメソッドの処理を変更する
    private func getPixelAddress(cgImage: CGImage) -> Int {
        let bytesPerPixel = (cgImage.bitsPerPixel) / 8
        let bytesPerRow = (cgImage.bytesPerRow)
        let pixelAddress: Int = 100 * bytesPerRow + 100 * bytesPerPixel
        return pixelAddress
    }
}
