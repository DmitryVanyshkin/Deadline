//
//  ChooseSomeTypesTableViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 05/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Класс, создающий в новом окне таблицу для выбора значения из определенных
//По сути, данный класс - таблица с внедрением поискового окна

class ChooseSomeTypesTableViewController: UITableViewController {
    
    //Контроллер, служащий для поиска и тд
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredData = [String]()   //Массив, в котором будут хранится критерии, удовлетворяющее результату поиска
    private let overallData = ApplicationData.shared.getData    //Все данные по данному критерию
    
    private var searchBarIsEmpty: Bool { //Проверка на  то, идет ли поиск - проверка на пустоту поисковой строким
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {     //Схоже с предыдущим
        return searchController.isActive && !searchBarIsEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self            //Делегируем методы поиска наш местный класс
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    


    //Что это за методы я уже писал в другом классе, опять повторяться не буду

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredData.count
        }
        return overallData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoDataCell", for: indexPath) as! InfoDataCell
        
        if isFiltering{
            cell.textContent.text = filteredData[indexPath.row]
        }
        
        else{
            cell.textContent.text = overallData[indexPath.row]
        }
        // Configure the cell...

        return cell
    }
    
    //Здесь немного веселее
    //В чем фишка - данная таблица, в зависимости от того, что нажал пользователь, предлагает выбрать майнор/группу или образовательную программу - текст, естественно будет разный. Обеспечивается осознание того, что выбрал пользователь через enum - enumeration (перечисление)
    //Соответственно, мы выбрали какой-то текст, а вот то, к чему он относится и определяет наш enum

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let content = (tableView.cellForRow(at: indexPath) as! InfoDataCell).textContent.text else{
            return
        }
        if ApplicationData.shared.getUserToAdd == nil{
            ApplicationData.shared.createUserToAdd()
        }
        switch  ApplicationData.shared.getDisplay {
        case .minors:
            ApplicationData.shared.getUserToAdd?.setMinor(minor: content)
        case .groupName:
            let educationAdd = ApplicationData.shared.getEducationProgramForName(name : content)
            ApplicationData.shared.getUserToAdd?.setProgramName(educationProgram : educationAdd)
        case .groupNumber:
            ApplicationData.shared.getUserToAdd?.setGroup(group: content)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        //(self.navigationController as! RegistrationScreenNavigation).reloadInfoAtRegistrationScreen()
        self.navigationController?.popViewController(animated: true)        //Выбрал майнор - молодец, мы закрываемся
        
    }
    

}


//Расширение для поиска
extension ChooseSomeTypesTableViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {    //Метод, посылающий делать поиск
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {     //Метод, делающий поиск (терпила)
        
        filteredData = overallData.filter({ (toSearch: String) -> Bool in
            return toSearch.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    
}


//Я устал, честно
