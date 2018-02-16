//
//  ViewResponse.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 09/02/18.
//  Copyright © 2018 Jera. All rights reserved.
//

import UIKit

enum ViewState {
    case normal
    case loading(PlaceholderViewModel)
    case failure(PlaceholderViewModel)
}

enum ListResponse<T> {
    case new
    case loading
    case success(T)
    case failure(String)
}
