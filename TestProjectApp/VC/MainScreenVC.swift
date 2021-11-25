//
//  ViewController.swift
//  TestProjectApp
//
//  Created by Igor Abovyan on 14.11.2021.
//

import UIKit

class MainScreenVC: UITableViewController {

    var tasks = [Task].init()

}

//MARK: Life cycle
extension MainScreenVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //прозрачные границы ячейки
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.config()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTasks()
    }
}

//MARK: Config
extension MainScreenVC {
    private func config() {
        
        let swipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(createTaskVC))
        swipeRecognizer.direction = .right
        view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc private func createTaskVC() {
        let vc = CreateTaskVC.init()
        let task = CoreDataManager.shered.createTask()
        vc.task = task
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func loadTasks() {
        tasks = CoreDataManager.shered.getAllTasks()
        tableView.reloadData()
    }
}

//MARK: Table view data source
extension MainScreenVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: identifier)
        }
        
        let task = tasks[indexPath.row]
        cell?.textLabel?.text = task.name
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 23, weight: .light)
        
        return cell!
    }
}

//MARK: Table view Delegate
extension MainScreenVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TimeVC.init()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteTask(indexPath: indexPath)
        }
    }
}

//MARK: Delete
extension MainScreenVC {
    func deleteTask(indexPath: IndexPath) {
        let title = "Delete Task"
        let message = "Delete choose task ?"
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let yes = UIAlertAction.init(title: "Yes", style: .destructive) { _ in
            let task = self.tasks.remove(at: indexPath.row)
            CoreDataManager.shered.delete(task: task)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        
        let no = UIAlertAction.init(title: "No", style: .default)
        alert.addAction(yes)
        alert.addAction(no)
        self.present(alert, animated: true)
    }
}
