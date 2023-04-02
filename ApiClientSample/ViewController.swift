//
//  ViewController.swift
//  ApiClientSample
//
//  Created by Hikaru Kuroda on 2023/04/01.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapPostButton(_ sender: Any) {
        let article = QiitaApiPostArticleRequestJSON(
            body: "本文",
            private: true,
            tags: [
                .init(name: "swift", versions: ["0.0.1"])
            ],
            title: "title",
            tweet: false
        )
        let api = QiitaApiPostArticle()
        api.execute(article: article) { result in
            switch result {
            case .success(let response):
                self.showAlert(title: "成功", message: "\(response)")
            case .failure(let err):
                self.showAlert(title: "失敗", message: "\(err)")
            }
        }
    }
    
    @IBAction func didTapGetButton(_ sender: Any) {
        let api = QiitaApiGetUserProfile()
        api.execute()
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .success(let response):
                    self.showAlert(title: "成功", message: "\(response)")
                case .failure(let err):
                    self.showAlert(title: "失敗", message: "\(err)")
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        let api = QiitaApiDeleteArticle()
        
        Task {
            let result = await api.execute(itemID: "e3766591a506755a2d8d")
            
            switch result {
            case .success(let response):
                self.showAlert(title: "成功", message: "\(response)")
            case .failure(let err):
                self.showAlert(title: "失敗", message: "\(err)")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let closeAction = UIAlertAction(title: "閉じる", style: .default)
        alert.addAction(closeAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

