//
//  ViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/10.
//

import UIKit
import Vision
import AVFoundation

class FoodInputViewController: UIViewController {
    let image = UIImage(named: "IMG_3456")!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    @IBAction func didPushButton(_ sender: Any) {
        run()
    }
    
    @IBAction func didPushNext(_ sender: Any) {
        let vc = ImageAnalysisViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }

    // 文字列認識実行
    private func run() {
        guard let cgImage = image.cgImage else { return }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        // 日本語に設定
        request.recognitionLanguages = ["ja-JP"]
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    // 文字列認識結果
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        // 取得できた文字列配列を表示
        label.text = recognizedStrings.debugDescription

        // 矩形を表示
        showBoundingRect(observations)
    }
    
    // 文字列認識できた位置に赤い矩形を表示
    private func showBoundingRect(_ observations: [VNRecognizedTextObservation]) {
        // ①　画像のRectを取得。メソッド内にてy座標の反転を行う。
        let boundingRects = getBoundingRects(observations: observations)
        // ② 画像のUIImageView内でのRectを取得。
        let imageRectInView = imageRect()
        // ② 画像の縮小率を取得。
        let ratio = imageRectInView.width / image.size.width
        
        boundingRects.forEach { rect in
            let view = UIView()
            view.layer.borderColor = UIColor.red.cgColor
            view.layer.borderWidth = 1
            let resizedRect = CGRect(x: rect.minX * ratio + imageRectInView.minX, // ③ 画像を並行移動
                                     y: rect.minY * ratio + imageRectInView.minY, // ③ 画像を並行移動
                                     width: rect.width * ratio,
                                     height: rect.height * ratio)
            view.frame = resizedRect
            imageView.addSubview(view)
        }
    }
    
    // ② UIImageView内のimageのCGRectを取得
    func imageRect() -> CGRect {
        return AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
    }
    
    func getBoundingRects(observations: [VNRecognizedTextObservation]) -> [CGRect] {
        let boundingRects: [CGRect] = observations.compactMap { observation in
            guard let candidate = observation.topCandidates(1).first else { return .zero }
            let stringRange = candidate.string.startIndex..<candidate.string.endIndex
            let boxObservation = try? candidate.boundingBox(for: stringRange)
            let boundingBox = boxObservation?.boundingBox ?? .zero
            let normalizedRect = VNImageRectForNormalizedRect(boundingBox,
                                                              Int(image.size.width),
                                                              Int(image.size.height))
            // ① Visionのy座標はUIKitとは逆向きなので反転する必要がある
            let yInImage = image.size.height - normalizedRect.minY - normalizedRect.height
            return CGRect(x: normalizedRect.minX,
                          y: yInImage,
                          width: normalizedRect.width,
                          height: normalizedRect.height)
        }
        return boundingRects
    }

}

