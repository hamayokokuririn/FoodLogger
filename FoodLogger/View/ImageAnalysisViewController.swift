//
//  ImageAnalysisViewController.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/11.
//

import UIKit
import Vision
import VisionKit
import PhotosUI

class ImageAnalysisViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didPushImageChange(_ sender: Any) {
        // show image picker
        var conf = PHPickerConfiguration()
        conf.filter = .images
        conf.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: conf)
        picker.delegate = self
        photoAuth(picker: picker)
    }
    
    
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonToTextView()
        addTextRecognition()
        textView.delegate = self
    }
    
    private func photoAuth(picker: PHPickerViewController) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .notDetermined:
            // 初回起動時アルバムアクセス権限確認
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.present(picker, animated: true)
                    }
                default:
                    break
                }
            }
        case .restricted, .authorized, .limited:
            self.present(picker, animated: true)
        case .denied:
            // アクセス権限がないとき
            let alert = UIAlertController(title: "", message: "写真へのアクセスを許可してください", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "設定", style: .default, handler: { (_) -> Void in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
                    return
                }
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            })
            let closeAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        @unknown default:
            fatalError()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC = segue.destination as? InputFoodTableViewController else { return }
        nextVC.wordList = makeWords()
        Task {
            let mealList = await UIApplication.shared.contentsService.inputDataStore.getMealList()
            let inputedList = mealList.map {
                $0.foods
            }
            let array = Array(inputedList.joined())
            let matchingInputedList = array.map {
                MatchingInputFood(inputedFood: $0)
            }
            let shouldCheckList = await UIApplication.shared.contentsService.fetchShouldCheckFoodList()
            nextVC.viewModel = InputFoodTableViewModel(wordList: makeWords(),
                                                       inputedList: matchingInputedList,
                                                       shouldCheckList: shouldCheckList)
            
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // stackview
        let bottomTextField = textView.superview?.frame.maxY ?? .zero
        // top of keyboard
        let topKeyboard = UIScreen.main.bounds.height - keyboardFrame.size.height
        let safe = view.safeAreaInsets.top
        // 重なり
        let distance = bottomTextField + safe - topKeyboard
        
        if distance >= 0 {
            scrollView.contentOffset.y = distance
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
    
    private func makeWords() -> [String] {
        guard let input = textView.text else { return [] }
        let service = LinguisticService()
        let tags = service.makeTagByNL(text: input)
        return service.ommitPunctuation(array: tags)
    }
}

extension ImageAnalysisViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.resultLabel.text = makeWords().reduce("", { $0 + $1 + "/"})
    }
    
}

extension ImageAnalysisViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        let typeChecked = itemProvider.registeredTypeIdentifiers.map {
            itemProvider.hasItemConformingToTypeIdentifier($0)
        }
        if typeChecked.contains(false) {
            return
        }
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let url else {
                return
            }
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
        }
        
    }
    
}
