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
    
    let presenter: CreateAccountPresenterProtocol
    let interactor: CreateAccountInteractorProtocol
    let viewController: CreateAccountViewController
    
    var chooseUserImageAlertController: UIAlertController?
    var chooseUserImagePickerController: UIImagePickerController?
    
    override init() {
        interactor = CreateAccountInteractor(repository: CreateAccountRepository(apiClient: APIClient()))
        let presenter = CreateAccountPresenter(interactor: interactor)
        
        self.viewController = CreateAccountViewController(presenter: presenter)
        self.presenter = presenter
        
        viewController.presenter = presenter
        
        navigationController = BaseNavigationController(rootViewController: viewController)
        
        super.init()
        
        presenter.router = self
    }
    
    fileprivate func goToChooseUserImageFromCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.cameraDevice = .front
        imagePickerController.cameraCaptureMode = .photo
        
        viewController.present(imagePickerController, animated: true, completion: nil)
        
        chooseUserImagePickerController = imagePickerController
    }
    
    fileprivate func goToChooseUserImageFromLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        viewController.present(imagePickerController, animated: true, completion: nil)
        
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
                self?.interactor.userImage.value = nil
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        viewController.present(alertController, animated: true) { [weak self] in
            self?.chooseUserImageAlertController = nil
        }
        
        chooseUserImageAlertController = alertController
    }
    
    func dismiss() {
        viewController.dismiss(animated: true) { [weak self] in
            self?.presenterWireFrame?.wireframeDidDismiss()
        }
    }
}

extension CreateAccountWireFrame: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let choosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        interactor.userImage.value = choosenImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
