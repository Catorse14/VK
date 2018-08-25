//
//  ViewController.swift
//  VKclient
//
//  Created by Никита Латышев on 24.08.2018.
//  Copyright © 2018 Никита Латышев. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  LoginViewController будет являтся navigationDelegate (протокол)
        webView.navigationDelegate = self
        
        //  Вызваем метод создания строки
        if let request = vkAuthRequest() {
            webView.load(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //  Создаем адрес, по которому переходим в Web View
    func vkAuthRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6672064"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "wall,friends,photos"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.80")
        ]
        if let url = urlComponents.url {
            return URLRequest(url: url)
        }
        return nil
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        //  Проверяем, содержит ли строка /blank.html. После успешного логина переходим в redirect_uri
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        //  Получаем token
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        if let token = params["access_token"] {
            
            // Сохраняем token
            UserDefaults.standard.set(token, forKey: "token")
            performSegue(withIdentifier: "myTabSegue", sender: nil)
        }
        decisionHandler(.cancel)
    }
}
