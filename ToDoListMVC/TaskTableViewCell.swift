//
//  TaskTableViewCell.swift
//  ToDoListMVC
//
//  Created by ИГОРЬ on 13/02/2021.
//

import UIKit

protocol CellDelegate { // протокол для того, чтобы можно было вызывать методы класса TaskTableViewCell из TableViewController
    func editCell(cell: TaskTableViewCell)
    func deleteCell(cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    
    var delegate: CellDelegate?
    
    
    @IBOutlet weak var labexTaskName: UILabel!
    @IBOutlet weak var comletedMark: UIImageView!
    @IBOutlet weak var delButton: UIButton!
    

    @IBAction func delButtonPressed(_ sender: UIButton) {
        delegate?.deleteCell(cell: self) // делегируем удвление задачи, реализовывать будеи в TableViewController
    }
    
    
    @IBAction func edtButtonPressed(_ sender: UIButton) {
        delegate?.editCell(cell: self) // делегируем редактирование задачи, реализовывать будеи в TableViewController
    }
}
