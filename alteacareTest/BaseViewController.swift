//
//  BaseViewController.swift
//  alteacareTest
//
//  Created by Edit sanrio Putra on 26/10/22.
//

import UIKit
import RxSwift

class BaseViewController : UIViewController {
    
    private var _disposeBag: DisposeBag?
    var disposeBag: DisposeBag {
        get {
            if let d = self._disposeBag {
                return d
            } else {
                self._disposeBag = DisposeBag()
                return self._disposeBag!
            }
        }
    }
    
    var loadingView : UIView = UIView()
    
    func showLoading() {
        loadingView.frame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let size : CGFloat = 250
        let indicator = UIActivityIndicatorView(frame: CGRect(x: (loadingView.frame.width-size)/2, y: (loadingView.frame.height-size)/2, width: size, height: size))
        if #available(iOS 13.0, *) {
            indicator.style = UIActivityIndicatorView.Style.large
        } else {
            indicator.style = UIActivityIndicatorView.Style.whiteLarge
        }
        indicator.color = UIColor.white
        indicator.startAnimating()
        loadingView.addSubview(indicator)
        self.view.addSubview(loadingView)
    }
    
    func hideLoading() {
        self.loadingView.removeFromSuperview()
    }
}


