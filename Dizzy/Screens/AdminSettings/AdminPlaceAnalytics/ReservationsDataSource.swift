//
//  ReservationsDataSource.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 02/12/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

final class ReservationsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let viewModel: AdminPlaceAnalyticsVMType
    
    init(viewModel: AdminPlaceAnalyticsVMType) {
        self.viewModel = viewModel
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReservationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = viewModel.getReservation(at: indexPath)
        cell.configure(with: data)
        return cell
    }
}
