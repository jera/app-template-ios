//
//  CreateAccountWireFrame.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol CreateAccountWireFrameProtocol: class {
    func presentOn(viewController: UIViewController, presenterWireFrame: CreateAccountPresenterWireFrameProtocol)
    func chooseUserImageButtonPressed(showDeleteCurrentImage: Bool)
    func dismiss()
}

protocol CreateAccountPresenterWireFrameProtocol: PresenterWireFrameProtocol {
    
}

class CreateAccountWireFrame: BaseWireFrame {
    let navigationController: UINavigationController
    
    let createAccountPresenter: CreateAccountPresenterProtocol
    let createAccountInteractor: CreateAccountInteractorProtocol
    let createAccountViewController = CreateAccountViewController()
    let apiClient: APIClientProtocol = APIClient()
    
    var chooseUserImageAlertController: UIAlertController?
    var chooseUserImagePickerController: UIImagePickerController?
    
    override init() {
        createAccountInteractor = CreateAccountInteractor(repository: CreateAccountRepository(apiClient: apiClient))
        let createAccountPresenter = CreateAccountPresenter(interactor: createAccountInteractor)
        self.createAccountPresenter = createAccountPresenter
        
        createAccountViewController.presenter = createAccountPresenter
        
        navigationController = BaseNavigationController(rootViewController: createAccountViewController)
        
        super.init()
        
        createAccountPresenter.router = self
    }
    
    fileprivate func goToChooseUserImageFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.cameraDevice = .front
        imagePickerController.cameraCaptureMode = .photo
        
        createAccountViewController.present(imagePickerController, animated: true, completion: nil)
        
        chooseUserImagePickerController = imagePickerController
    }
    
    fileprivate func goToChooseUserImageFromLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        createAccountViewController.present(imagePickerController, animated: true, completion: nil)
        
        chooseUserImagePickerController = imagePickerController
    }
}

extension CreateAccountWireFrame: CreateAccountWireFrameProtocol {
    func presentOn(viewController: UIViewController, presenterWireFrame: CreateAccountPresenterWireFrameProtocol) {
        self.presenterWireFrame = presenterWireFrame
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func chooseUserImageButtonPressed(showDeleteCurrentImage: Bool) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) && !showDeleteCurrentImage {
            goToChooseUserImageFromLibrary()
            return
        }
        
        let alertController = UIAlertController(title: "Imagem para o seu perfil", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (_) in
                self?.goToChooseUserImageFromCamera()
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Rolo", style: .default, handler: { [weak self] (_) in
            self?.goToChooseUserImageFromLibrary()
        }))
        
        if showDeleteCurrentImage {
            alertController.addAction(UIAlertAction(title: "Apagar imagem atual", style: .destructive, handler: { [weak self] (_) in
                self?.createAccountInteractor.userImage.value = nil
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        createAccountViewController.present(alertController, animated: true) { [weak self] in
            self?.chooseUserImageAlertController = nil
        }
        
        chooseUserImageAlertController = alertController
    }
    
    func dismiss() {
        createAccountViewController.dismiss(animated: true) { [weak self] in
            self?.presenterWireFrame?.wireframeDidDismiss()
        }
    }
}

extension CreateAccountWireFrame: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        createAccountInteractor.userImage.value = choosenImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
