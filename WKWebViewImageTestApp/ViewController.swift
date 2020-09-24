//
//  ViewController.swift
//  WKWebViewImageTestApp
//
//

import UIKit
import WebKit
import WebViewJavascriptBridge

class ViewController: UIViewController {
    var webView:WKWebView?
    var bridge:WebViewJavascriptBridge?

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewのViewへの追加
        self.webView = WKWebView(frame: view.frame)
        view.addSubview(self.webView!)
        // WebViewJavascriptBridge初期化
        self.bridge = WebViewJavascriptBridge.init(forWebView: webView)
        // WKWebView内のjavascriptからSwift内のデータを取得
        self.bridge!.registerHandler("image") { (data, callback) in
            if let imagePath = Bundle.main.path(forResource: "PNG", ofType: "png") {
                // PNGデータをUIImageに
                let image = UIImage(contentsOfFile: imagePath)
                // Data型へ変換
                let data = image?.pngData()
                // PNGのデータをbase64エンコードしてWebViewで表示できるよう修正
                let base64Image = data?.base64EncodedString(options: .endLineWithLineFeed)
                callback!(base64Image)
            }
        }
        let htmlPath = Bundle.main.path(forResource: "content", ofType: "html")
        let baseURL = URL.init(fileURLWithPath: htmlPath!)
        webView!.loadFileURL(baseURL, allowingReadAccessTo: baseURL)
    }
}

