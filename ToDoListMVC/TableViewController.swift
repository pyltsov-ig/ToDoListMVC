//
//  TableViewController.swift
//  ToDoListMVC
//
//  Created by ИГОРЬ on 10/02/2021.
//

import UIKit

class TableViewController: UITableViewController, CellDelegate{
    
    
    let model = Model()
    var alert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.toDoTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TaskTableViewCell
        cell.delegate = self
        
        let currentTask = model.toDoTasks[indexPath.row]
        cell.labexTaskName?.text = currentTask.caption
        
        // релизуем отображение состояния задачи через отрисовку ImageView
        if currentTask.completed {
            cell.comletedMark.image = .checkmark
        } else {
            cell.comletedMark.image = .none
        }
       
        // можно было бы сделать как написано ниже. Было бы красивие и быстрее, но для тренировки надо было сделать как-то иначе
       // cell.accessoryType = currentTask.completed ? .checkmark : .none
        
        return cell
    }
    
  
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //если тапнули по задаче
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell // получаем экземляр ячеки, на который тапнули
        
        if model.changeTaskState(at: indexPath.row) == true { // меняем статус посредством обращения к модели.
            cell.comletedMark.image = .checkmark
        } else {
            cell.comletedMark.image = .none
        }
    }
    
    @IBAction func addNewTaskButtonAction(_ sender: Any) { // добавлять новую задачу будем через диалоговое модальное окошко с кнопками (типа MessageBox)
        
        alert = UIAlertController(title: "Создать новую задачу", message: nil, preferredStyle: .alert) //создаем мессадж бокс
        
        alert.addTextField { (textField: UITextField) in // добавляем на мессадж бокс текстовое поле для ввода названия новой задчи
            textField.placeholder = "Введите задачу"
            textField.addTarget(self,action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            
        }
        
        let createNewAlertAction = UIAlertAction(title: "Создать", style: .default, handler: { (createAlert)
            in //создаем действие и кнопку для добавления новой задачи
            guard let textFieldValue = self.alert.textFields?[0].text else {return}
            self.model.addTask(itemCaption: textFieldValue)
            self.tableView.reloadData()
        })
        
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil) // действие в случае отмены (ничего не делаем).
        
        // добавляем оба действия с кнопками на наш мессадж бокс
        alert.addAction(cancelAlertAction)
        alert.addAction(createNewAlertAction)
        
        present(alert,animated: true, completion: nil) // отображаем наш модальный мессадж бокс
        createNewAlertAction.isEnabled  = false // дизейблим дейстие создания. чтобы случайно не добавить несколько раз
    }
    

    func editCell(cell: TaskTableViewCell) { //реализация делегированного метода редактирования задачи
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }//получаем индекс ячейки в таблице, ниже пригодится
        
        alert = UIAlertController(title: "Редактировать задачу", message: nil, preferredStyle: .alert) // создаем модальное окно - alert
        
       
        alert.addTextField(configurationHandler: { (textField) -> Void in //добавляем текстовое поле на alert
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.labexTaskName.text
        })
        
        // создаем два действия-акшена на сабмит и cancel
        let cancelAlertAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let submitAlertAction = UIAlertAction(title: "Изменить", style: .default) { (createAlert) in
            
            guard let textFields = self.alert.textFields, textFields.count > 0 else {return}
            guard let textValue = self.alert.textFields?[0].text else {return}
            
            self.model.updateTask(at: indexPath.row, with: textValue) // меняем caption задачи на новый посредством модели
            self.tableView.reloadData()
        }
        // добавляем акшены на alert
        alert.addAction(cancelAlertAction)
        alert.addAction(submitAlertAction)
        
        present(alert,animated: true, completion: nil) // отоброжаем модальное окно alert
        submitAlertAction.isEnabled = false
        
        
    }
    
    func deleteCell(cell: TaskTableViewCell) { // реализация делегированное метода удаления задачи
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        //guard let indPth = indexPath else {return}
        model.removeTask(at: indexPath.row)
        tableView.reloadData()
    }
    
    
    @objc func alertTextFieldDidChange(_ sender:UITextField) { // этой функциеей дизейблим акшн если в текстовом модального окна (добавления иил редактирования)  ничего нет
        guard let senderText = sender.text, alert.actions.indices.contains(1) else {
            return
        }

        let action = alert.actions[1]
        action.isEnabled = senderText.count > 0

    }
}
