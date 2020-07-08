//
//  BigImageHorizontalViewModel.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 30/06/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import Foundation

protocol BigImageHorizontalViewModelType {
    func numberOfSections() -> Int
    func item(at indexPath: IndexPath) -> BigImageHorizontalViewModel.Data
}

final class BigImageHorizontalViewModel: BigImageHorizontalViewModelType {

}

extension BigImageHorizontalViewModel {
  
}
