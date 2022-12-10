//
//  CustomTableCell.swift
//  MyToDoList_With_MVC
//
//  Created by Raman Kozar on 10/12/2022.
//

import UIKit

// MARK: Writing delegation protocols
protocol CustomTableCellDelegate {
    
    func editCell(cell: CustomTableCell)
    func deleteCell(cell: CustomTableCell)
    
}

// MARK: Class for a custom cell
class CustomTableCell: UITableViewCell {
    
    // MARK: Cell ID
    var identifier: String = "Cell"
    
    // MARK: Delegate-variable
    var delegate: CustomTableCellDelegate?
    
    // MARK: Adding outlets of cell elements
    
    @IBOutlet weak var customTableCellTextLabel: UILabel!
    @IBOutlet weak var customTableCellEditButton: UIButton!
    @IBOutlet weak var customTableCellDeleteButton: UIButton!
    
    //MARK: Adding actions on clicking cell buttons
    
    //MARK: Editing
    @IBAction func customTableCellEditButtonAction(_ sender: UIButton) {
        delegate?.editCell(cell: self)
    }
    
    //MARK: Deleting
    @IBAction func customTableCellDeleteButtonAction(_ sender: UIButton) {
        delegate?.deleteCell(cell: self)
    }
    
}
