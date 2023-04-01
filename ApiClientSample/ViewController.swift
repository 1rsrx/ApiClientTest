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
        let api = QiitaApiGetUserProfile()
        api.execute()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    print("失敗: \(err)")
                }
            } receiveValue: { json in
                print("成功")
                print(json)
            }
            .store(in: &cancellables)
    }
    
}

