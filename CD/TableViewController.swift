//
//  TableViewController.swift
//  CD
//
//  Created by Константин Козлов on 20.10.2021.
//

import UIKit


class TableViewController: UITableViewController {
    
    var dataStoreManager = DataStoreManager()
    private var tasks: [Tasks] = []  //массив для формирования таблицы
    private var filteredTasks: [Tasks] = []  //массив для формирования таблицы отфильтрованных данных
    private var taskForDeleteOrImportant: Tasks = Tasks()  // ячейка для удаления или пометки флажком
    private let search = UISearchController(searchResultsController: nil)
    
    
    //наличие текста в UISearchBar
    private var searchBarIsEmpty: Bool {
        guard let text = search.searchBar.text else {return false}
        return text.isEmpty
    }
    
    //активен ли поиск
    private var isFiltering: Bool {
        return search.isActive && !searchBarIsEmpty
    }
    
    //получение ячейки в отфильтрованном списке
    private func fechFilteredTask(filteredTasks: [Tasks], task: [Tasks], indexPath: IndexPath ) -> Tasks{
     
        if isFiltering {
            taskForDeleteOrImportant = filteredTasks[indexPath.row]
        }else{
            taskForDeleteOrImportant = tasks[indexPath.row]
        }
        return taskForDeleteOrImportant
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
        dataStoreManager.saveContext()  //сохранение данных при переходе из  DetailVC
    }
    
    //конфигурирование NavigationBar
    private func configureNavBar(){
        
        search.searchBar.delegate = self
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "search"
        search.searchBar.searchTextField.backgroundColor = .white
        search.searchBar.tintColor = .black
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
    
    //Получение массива для формирования таблицы
   private func fetchData(){
        tasks = dataStoreManager.fetchData()
    }
    
    //Вызов UIViewController для создания новой задачи
    @objc private func addNewTask(){
        let newTaskVC = NewTaskViewController()
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true, completion: nil)
   }
    
    //Вызов UIAlertController для сортировки таблицы
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
               cell.setupCell(image: UIImage(named: "flag") ?? UIImage(), text: task.name ?? "", dateText: task.date ?? Date(), imageOfTask: ((task.image ?? UIImage(named: "photoImage")?.pngData())!))
                return cell
            } else {
                cell.setupCell(image: UIImage(), text: task.name ?? "", dateText: task.date ?? Date(), imageOfTask: (task.image  ?? UIImage(named: "photoImage")?.pngData())!)
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

        performSegue(withIdentifier: "toDetailVC", sender: nil)

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


//     MARK: - extension for search
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
