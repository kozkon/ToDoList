//
//  TableViewController.swift
//  CD
//
//  Created by Константин Козлов on 20.10.2021.
//

import UIKit


class TableViewController: UITableViewController {
    
    var dataStoreManager = DataStoreManager()
   
    private var tasks: [Tasks] = []
    private var filteredTasks: [Tasks] = []
    
    private var taskForSearch: Tasks = Tasks()
    private let search = UISearchController(searchResultsController: nil)
    
    
    private var searchBarIsEmpty: Bool {
        guard let text = search.searchBar.text else {return false}
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return search.isActive && !searchBarIsEmpty
    }
    
    private func fechFilteredTask(filteredTasks: [Tasks], task: [Tasks], indexPath: IndexPath ) -> Tasks{
     
        if isFiltering {
            taskForSearch = filteredTasks[indexPath.row]
        }else{
            taskForSearch = tasks[indexPath.row]
        }
        return taskForSearch
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        configureNavBar()
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    
    
    private func configureNavBar(){
        
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "search"
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
        //        search.searchBar.showsCancelButton = false
        definesPresentationContext = true
        
        var searchBarIsEmpty: Bool {
            guard let text = search.searchBar.text else {return false}
            return text.isEmpty
        }
        
        var isFiltering: Bool {
            return search.isActive && !searchBarIsEmpty
        }
        
        self.navigationItem.searchController = search
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Task"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundImage = UIImage(named: "navBarImage")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.gray]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(red: 21/255, green: 100/255, blue: 200/255, alpha: 255/255)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: UIBarButtonItem.Style.done, target: self, action: #selector(sortAlert))
        navigationController?.navigationBar.tintColor = .white
        
        
    }
    
    
    
    private func fetchData(){
        
        tasks = dataStoreManager.fetchData()
    }
    
    @objc private func addNewTask(){
        let newTaskVC = NewTaskViewController()
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true, completion: nil)
        
        //        openSaveAlert(with: "New task", message: "Добавьте новый таск:")
        
    }
    
    @objc private func sortAlert(){
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortByNameIncrease = UIAlertAction(title: "Сортировать по возрастанию имени", style: .default) { UIAlertAction in
            
            self.tasks = self.tasks.sorted(by: { $0.name ?? "" < $1.name ?? "" })
            self.tableView.reloadData()
            }
            
        
        let sortByNameDescending = UIAlertAction(title: "Сортировать по убыванию имени", style: .default) { UIAlertAction in
            self.tasks = self.tasks.sorted(by: { $0.name ?? "" > $1.name ?? "" })
            self.tableView.reloadData()
        }
        
        let sortByDateIncrease = UIAlertAction(title: "Сортировать по возрастанию даты", style: .default) { UIAlertAction in
            
            self.tasks = self.tasks.sorted(by: { $0.date ?? Date() < $1.date ?? Date()  })
            self.tableView.reloadData()
            }
        
        let sortByDateDescending = UIAlertAction(title: "Сортировать по убыванию даты", style: .default) { UIAlertAction in
            
            self.tasks = self.tasks.sorted(by: { $0.date ?? Date() > $1.date ?? Date()  })
            self.tableView.reloadData()
            }
        let canclAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        ac.addAction(sortByNameIncrease)
        ac.addAction(sortByNameDescending)
        ac.addAction(sortByDateIncrease)
        ac.addAction(sortByDateDescending)
        ac.addAction(canclAction)
        
        present(ac, animated: true, completion: nil)
     
    }
    
    private func openSaveAlert(with title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            guard let task = ac.textFields?.first?.text, !task.isEmpty else { return }
            //            self.save(task)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(okButton)
        ac.addAction(cancelButton)
        ac.addTextField(configurationHandler: nil)
        present(ac, animated: true, completion: nil)
        
    }
    
    
    //     MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var tasksForCheck: [Tasks] = []
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
           let taskToDelete = self.fechFilteredTask(filteredTasks: self.filteredTasks, task: self.tasks, indexPath: indexPath)
            
            self.dataStoreManager.deleteTask(task: taskToDelete)
             
            if self.isFiltering {
                self.filteredTasks.remove(at: indexPath.row)
            
            }else{
                self.tasks.remove(at: indexPath.row)
             }
         tableView.deleteRows(at: [indexPath], with: .automatic)
       }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(named: "trash")
        
        if isFiltering {
            tasksForCheck = filteredTasks
        }else{
            tasksForCheck = tasks
        }
        
        if tasksForCheck[indexPath.row].important == true {
        
            let flagAction = UIContextualAction(style: .normal, title: "Снять флажок") { _, _, completionHandler  in
                self.dataStoreManager.deleteImportantTask(taskForDelete: tasksForCheck[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }
            flagAction.backgroundColor = .orange
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, flagAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
            
        }else{
            
            let flagAction = UIContextualAction(style: .normal, title: "Пометить как важное") { _, _, completionHandler in
                
                var taskForFlag = Tasks()
                
                if self.isFiltering{
                    taskForFlag = self.filteredTasks[indexPath.row]
                }else{
                    taskForFlag = self.tasks[indexPath.row]
                }
                
                self.dataStoreManager.saveImportantTask(task: taskForFlag)
                completionHandler(true)
                tableView.reloadRows(at: [indexPath], with: .fade)
                
            }
            flagAction.backgroundColor = .orange
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, flagAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cancelFlag = UIContextualAction(style: .normal, title: "Снять флажок") { _, _, completionHandler  in
            
            var taskForDeleteFlag = Tasks()
            if self.isFiltering {
                taskForDeleteFlag = self.filteredTasks[indexPath.row]
            }else{
                taskForDeleteFlag = self.tasks[indexPath.row]
            }
          self.dataStoreManager.deleteImportantTask(taskForDelete: taskForDeleteFlag)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        cancelFlag.backgroundColor = .orange
        
        let configuration = UISwipeActionsConfiguration(actions: [cancelFlag])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTasks.count
        }
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell {
        
            let task = fechFilteredTask(filteredTasks: filteredTasks, task: tasks, indexPath: indexPath)
           if task.important == true {
               cell.setupCell(image: UIImage(named: "flag") ?? UIImage(), text: task.name ?? "", dateText: task.date ?? Date() )
                return cell
            } else {
                cell.setupCell(image: UIImage(), text: task.name ?? "", dateText: task.date ?? Date())
                return cell
            }
        } else {
            return UITableViewCell()
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


//        guard let indexPath = tableView.indexPathForSelectedRow else {return}
//        let task = tasks[indexPath.row]
//
//        delegate?.displayTask(task: task)
       
       
        
       
        performSegue(withIdentifier: "toDetailVC", sender: nil)
//
//        guard let indexPath = tableView.indexPathForSelectedRow else {return}
//        let task = tasks[indexPath.row]
        
        

      
    }

    /*
 
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    /*
     
  
     
     /Users/repository/Developer/CD/CD.xcodeproj
     
     
     
     */
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            
            let detailVC = segue.destination as! DetailVC
            
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let task = tasks[indexPath.row]
            detailVC.task = task
            
        }
    }
    
    

}



extension TableViewController: UISearchResultsUpdating{
 func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String){
        
        filteredTasks = tasks.filter({ (task: Tasks) -> Bool in
            return task.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        tableView.reloadData()
    }
 }

extension TableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchData()
        tableView.reloadData()
    }
}
