//
//  BaseViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography

protocol BaseViewProtocol: class {
    
}

class BaseViewController: UIViewController {
    
    internal let basePresenter: BasePresenterProtocol
    internal var viewControllerDisposeBag: DisposeBag!
    
    private var backgroundImageView: UIImageView?
    private var placeholderView: UIView?
    
    init(presenter: BasePresenterProtocol, nibName: String?) {
        basePresenter = presenter
        super.init(nibName: nibName, bundle: nil)
    }
    
    init(presenter: BasePresenterProtocol) {
        basePresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    private func bind() {
        viewControllerDisposeBag = DisposeBag()
        
        basePresenter.viewState
            .bind {[weak self] (state) in
                guard let strongSelf = self else { return }
                switch state {
                    
                case .normal:
                    strongSelf.removePlaceholder()
                    
                case .failure(let viewModel):
                    strongSelf.showPlaceholderWith(viewModel: viewModel, type: .error)
                    
                case .loading(let viewModel):
                    strongSelf.showPlaceholderWith(viewModel: viewModel, type: .loading)
                    
                }
            }
            .disposed(by: viewControllerDisposeBag)
        
        basePresenter.alert
            .bind {[weak self] (alertViewModel) in
                guard let strongSelf = self else { return }
                strongSelf.buidlAlertWith(viewModel: alertViewModel)
            }
            .disposed(by: viewControllerDisposeBag)
    }
    
    func addBackgroundImage(_ image: UIImage) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = UIImageView(image: image)
        backgroundImageView?.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView!)
        view.sendSubview(toBack: backgroundImageView!)
        constrain(view, backgroundImageView!) { (container, image) in
            image.edges == container.edges
        }
    }
    
    public func addCloseButton(image: UIImage, block: @escaping () -> Void ) {
        let closeBarButton = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        _ = closeBarButton.rx.tap
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { (_) in
                block()
            })
        navigationItem.leftBarButtonItem = closeBarButton
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BaseViewController {
    
    private func removePlaceholder() {
        placeholderView?.removeFromSuperview()
    }
    
    private func showPlaceholderWith(viewModel: PlaceholderViewModel, type: PlaceholderType) {
        view.endEditing(true)
        
        switch type {
        case .loading:
            showLoading(viewModel: viewModel)
            
        case .error:
            showError(viewModel: viewModel)
        }
    }
    
    private func showLoading(viewModel: PlaceholderViewModel) {
        removePlaceholder()
        
        let loadingView = LoadingView()
        loadingView.presentOn(parentView: self.view, with: viewModel)
        self.placeholderView = loadingView
    }
    
    private func showError(viewModel: PlaceholderViewModel) {
        removePlaceholder()
        
        let errorView = ErrorView()
        errorView.presentOn(parentView: self.view, with: viewModel)
        self.placeholderView = errorView
    }
}

extension BaseViewController {
    
    private func buidlAlertWith(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        viewModel.alertActions.forEach { (alertActionViewModel) in
            alert.addAction(alertActionViewModel.transform())
        }
        present(alert, animated: true)
    }
}
