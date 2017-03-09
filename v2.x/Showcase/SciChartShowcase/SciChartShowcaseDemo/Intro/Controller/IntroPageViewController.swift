//
//  ViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/21/17.
//  Copyright © 2017 Yaroslav Pelyukh. All rights reserved.
//

import UIKit

class IntroPageViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize.init(width: 800, height: 950)
    }
}
