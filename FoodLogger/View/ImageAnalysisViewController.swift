//
//  ImageAnalysisViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/11.
//

import UIKit
import Vision
import VisionKit

class ImageAnalysisViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonToTextView()
        addTextRecognition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // bottom of textField
        let bottomTextField = textView.frame.maxY
        // top of keyboard
        let topKeyboard = UIScreen.main.bounds.height - keyboardFrame.size.height
        // 重なり
        let distance = bottomTextField - topKeyboard
        
        if distance >= 0 {
            // scrollViewのコンテツを上へオフセット + 50.0(追加のオフセット)
            scrollView.contentOffset.y = distance + 50.0
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // キーボードが閉じる時の処理
    }
    
    private func addTextRecognition() {
        guard DataScannerViewController.isSupported else {
            print("no supported")
            return
        }
        guard DataScannerViewController.isAvailable else {
            print("no available")
            return
        }
        imageView.addInteraction(interaction)
        analyze()
    }
    
    private func addDoneButtonToTextView() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        
        // BarButtonItemの配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        textView.inputAccessoryView = toolBar
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    func analyze() {
        guard let image = imageView.image else { return }
        Task {
            do {
                let config = ImageAnalyzer.Configuration(.text)
                let analysis = try await analyzer.analyze(image, configuration: config)
                interaction.analysis = analysis
                interaction.preferredInteractionTypes = .textSelection
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func didPushRegister(_ sender: Any) {
        guard let input = textView.text else { return }
        let service = LinguisticService()
        let tags = service.makeTagByNL(text: input)
        let words = service.ommitPunctuation(array: tags)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "tableViewController") as? InputFoodTableViewController else {return}
        vc.wordList = words
        navigationController?.pushViewController(vc, animated: true)
    }
    

}