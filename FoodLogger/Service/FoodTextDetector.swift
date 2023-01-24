//
//  ViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/10.
//

import UIKit
import Vision
import AVFoundation

class FoodTextDetector {
    
    let image: UIImage
    let imageRectInView: CGRect
    let detectionTarget: String
    var text: String = ""
    var rect: CGRect = .null
    
    init(image: UIImage, of imageView: UIImageView, detectionTarget: String) {
        self.image = image
        self.imageRectInView = Self.imageRect(image: image, imageView: imageView)
        self.detectionTarget = detectionTarget
    }
    
    // UIImageView内のimageのCGRectを取得
    static func imageRect(image: UIImage, imageView: UIImageView) -> CGRect {
        return AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
    }

    // 文字列認識実行
    func run() {
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

        let recognizedIndex = observations.firstIndex(where: { observation in
            guard let string = observation.topCandidates(1).first?.string else {
                return false
            }
            return string.contains(detectionTarget)
        })
        guard let recognizedIndex else {
            return
        }

        let observation = observations[recognizedIndex]
        self.rect = boundingRect(observation: observation)
        text = observation.topCandidates(1).first!.string
    }
    
    // 文字列認識できた位置
    private func boundingRect(observation: VNRecognizedTextObservation) -> CGRect {
        // ①　画像のRectを取得。メソッド内にてy座標の反転を行う。
        let boundingRect = getBoundingRects(observation: observation)
        
        // ② 画像の縮小率を取得。
        let ratio = imageRectInView.width / image.size.width
        
        
        let resizedRect = CGRect(x: boundingRect.minX * ratio + imageRectInView.minX,
                                 y: boundingRect.minY * ratio + imageRectInView.minY, // ③ 画像を並行移動
                                 width: boundingRect.width * ratio,
                                 height: boundingRect.height * ratio)
        return resizedRect
    }
    
    func getBoundingRects(observation: VNRecognizedTextObservation) -> CGRect {
        
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

}

