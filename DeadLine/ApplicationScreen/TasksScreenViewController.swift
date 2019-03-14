//
//  TasksScreenViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 09/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class TasksScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var sortTasks: UICollectionView!
    @IBOutlet weak var sortTypePick: UISegmentedControl!
    @IBOutlet weak var taskTable: UITableView!
    let amountDays = ApplicationData.shared.dateManager.getAmountForSlider()
    var dataSourceTask = [Task]()
    var dayToShow = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self
        taskTable.dataSource = self
        sortTasks.delegate = self
        sortTasks.dataSource = self
        sortTasks.allowsMultipleSelection = false
        makeGrayViewTable()
        makeMoveToCurrentDate()
        // Do any additional setup after loading the view.
    }
    
    func loadTasksForDay(day : Date){
       dataSourceTask = ApplicationData.shared.server.taskSystem.getTaskForUser(for: ApplicationData.shared.getCurrent!, day: day) ?? []
        print(dataSourceTask.count)
        taskTable.reloadData()
    }
    
    func makeGrayViewTable(){
        let viewBottom = UIView()

        taskTable.tableFooterView = viewBottom
        //taskTable.tableHeaderView = viewBottom
        taskTable.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TaskViewCell", bundle: nil), forCellReuseIdentifier: "Task")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task") as! TaskViewCell
        let linkedTask = dataSourceTask[indexPath.row]
        cell.linkedTask = linkedTask
        cell.loadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amountDays.last!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "Date")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Date", for: indexPath) as! DateCell

        cell.blueChooseLine.isHidden = true
        
        cell.dateNumberLabel.text = "\(ApplicationData.shared.dateManager.countDayNumber(number: indexPath.row + 1, arrayMonthRanges: amountDays))"
        
        cell.dayOfWeekLabel.text = convertNumberToDay(number: (indexPath.row + 1) % 7 + 1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as! DateCell).blueChooseLine.isHidden = false
        let date = ApplicationData.shared.dateManager.countNumberToDay(number: indexPath.row + 1)
        loadTasksForDay(day: date)
        
    }
    
    func makeMoveToCurrentDate(){
        let number = ApplicationData.shared.dateManager.convertToday(arrayMonthRanges: amountDays)
        sortTasks.scrollToItem(at: IndexPath(item: number, section: 0), at: .centeredHorizontally, animated: false)
        //sortTasks.selectItem(at: IndexPath(item: number % 7, section: 0), animated: true, scrollPosition: .centeredHorizontally)
  
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? DateCell)?.blueChooseLine.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController{
    func convertNumberToDay(number : Int) -> String{
        switch number {
        case 1:
            return "пн"
        case 2:
            return "вт"
        case 3:
            return "ср"
        case 4:
            return "чт"
        case 5:
            return "пт"
        case 6:
            return "сб"
        case 7:
            return "вс"
        default:
            return "error"
        }
    }
}
