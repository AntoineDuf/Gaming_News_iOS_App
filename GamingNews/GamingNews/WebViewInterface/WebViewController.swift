//
//  WebViewController.swift
//  GamingNews
//
//  Created by Antoine Dufayet on 06/08/2020.
//  Copyright © 2020 NatProd. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private weak var webView: WKWebView!

    var viewModel: WebViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUrl()
        guard let request = viewModel.request else { return }
        webView.load(request)
    }
    @IBAction func goBackButton(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func goForwardButton(_ sender: Any) {
        webView.goForward()
    }
    @IBAction func refreshButton(_ sender: Any) {
        webView.reload()
    }
}
