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

    @IBAction func didTapButton(_ sender: Any) {
        let api = QiitaApiDeleteArticle()
        api.execute()
            .sink { result in
                switch result {
                case .success(let response):
                    print("成功: ", response)
                case .failure(let err):
                    print("エラー: ", err)
                }
            }
            .store(in: &cancellables)
    }
    
}

