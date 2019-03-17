//
//  TasksScreenViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 09/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Часть номер я не помню номер
//Здесь будет отображаться основной интерфейс приложения
//В частности здесь будет экран с отображением всех заданий пользователя, которые он ввёл


//Снова знакомый нам уже подход с делегированием
class TasksScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var sortTasks: UICollectionView!     //Коллекция отвечающая за выбор даты или тега задания
    @IBOutlet weak var sortTypePick: UISegmentedControl!    //Выбираем критерий выбора заданий - переключатель на два значения
    @IBOutlet weak var taskTable: UITableView!              //Таблица заданий
    //Вот тут начнется содомия - общее количество дней на диапазон 5 месяцев - что это за зверь, расскажу в классе менеджера дат
    let amountDays = ApplicationData.shared.dateManager.getAmountForSlider()
    var dataSourceTask = [Task]() //Задания для отображения - получается путем поиска в классе, хранящем этих красавцев
    let tagsList = ApplicationData.shared.currentUser?.getUserTags  //Список тегов данного пользователя, хранятся прямо в его сердце
    var dayToShow = Date()      //Задания с какой даты мы отображаем
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTable.delegate = self           //Снова делегируем
        taskTable.dataSource = self
        sortTasks.delegate = self
        sortTasks.dataSource = self
        sortTasks.allowsMultipleSelection = false   //Запрещаем возможность выбора нескольки заданий сразу
        makeGrayViewTable()
        makeMoveToCurrentDate()                     //Переводим коллекцию дат на текущий день - визуализация
        sortTypePick.addTarget(nil, action: #selector(switchData(segmented:)), for: .valueChanged) //Привязываем к переключателю действие, при изменении его значения. В нашем случае это изменение того, по какому критерию отображаем задания
    }
    
    //Я ИССЯК
    
    @objc func switchData(segmented : UISegmentedControl){  //Метод, вызываемый при изменении значения переключателя
        sortTasks.reloadData()
        
        switch segmented.selectedSegmentIndex { //классическая switch-case конструкция
        case 0:                             //если мы выбррали режим по дате, то загружаем сегодняшние дела
            loadTasksForDay(day: Date())
        default:
            loadTasksForTopic(topic: ApplicationData.shared.currentUser!.getUserTags.first!)    //По тегам - загружаем с первого тега данные
            sortTasks.allowsMultipleSelection = false
            sortTasks.isScrollEnabled = true
            
        }
        
    }
    
    func loadTasksForDay(day : Date){       //Загрузка заданий по определенной дате
       dataSourceTask = ApplicationData.shared.server.taskSystem.getTaskForUser(for: ApplicationData.shared.getCurrent!, day: day) ?? []
        taskTable.reloadData()
    }
    
    func loadTasksForTopic(topic : RelatedTopic){ //Загрузка заданий по определенному тэгу
        dataSourceTask = ApplicationData.shared.server.taskSystem.getTaskForUser(for: ApplicationData.shared.getCurrent!, topic: topic) ?? []
        taskTable.reloadData()
    }
    
    func makeGrayViewTable(){           //Тонируем вьюху внизу таблицы с целью декорации
        let viewBottom = UIView()

        taskTable.tableFooterView = viewBottom
        //taskTable.tableHeaderView = viewBottom
        taskTable.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
    }
    
    //Инициализация таблицы - уже было
    
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
        if (sortTypePick.selectedSegmentIndex == 0){
            return amountDays.last!
        }
        else{
            return tagsList!.count
        }
    }
    
    
    //С инициализацией коллекции немного посложнее - из-за того, что в одной коллекции в разные моменты времени могут храниться разные ячейки - нужно учитывать это
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Для понимания того, какие ячейки нужно отображать, мы опираемся на переключатель на 2 значения
        switch sortTypePick.selectedSegmentIndex {
        case 0: //У него ноль - загружаем ячейки даты и забиваем значения для них
            collectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "Date")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Date", for: indexPath) as! DateCell
            
            cell.blueChooseLine.isHidden = true
            
            cell.dateNumberLabel.text = "\(ApplicationData.shared.dateManager.countDayNumber(number: indexPath.row + 1, arrayMonthRanges: amountDays))"
            
            cell.dayOfWeekLabel.text = convertNumberToDay(number: (indexPath.row + 1) % 7 + 1)
            cell.frame.size.width = 50
            
            return cell
        default:        //Аналогично, но с тегом
            collectionView.register(UINib(nibName: "ColorTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ThemeTag")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeTag", for: indexPath) as! ColorTagCollectionViewCell
            cell.relatedTopic = tagsList![indexPath.row]
            cell.setDataForLabel()
            return cell
        }

    }
    
    //Нажимая на дату или тег, мы вызываем метод выборки заданий по определенным критериям
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (sortTypePick.selectedSegmentIndex == 0){
            (collectionView.cellForItem(at: indexPath) as! DateCell).blueChooseLine.isHidden = false
            let date = ApplicationData.shared.dateManager.countNumberToDay(number: indexPath.row + 1)
            loadTasksForDay(day: date)
        }
        else{
            (collectionView.cellForItem(at: indexPath) as? ColorTagCollectionViewCell)?.blueChooseLine.isHidden = false
            let topic = ApplicationData.shared.currentUser?.getUserTags[indexPath.row]
            loadTasksForTopic(topic: topic!)
        }
        
    }
    
    func makeMoveToCurrentDate(){
        let number = ApplicationData.shared.dateManager.convertToday(arrayMonthRanges: amountDays)
        sortTasks.scrollToItem(at: IndexPath(item: number, section: 0), at: .centeredHorizontally, animated: false)
        //sortTasks.selectItem(at: IndexPath(item: number % 7, section: 0), animated: true, scrollPosition: .centeredHorizontally)
  
    }
    
    //Прячем синюю линию
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if (sortTypePick.selectedSegmentIndex == 0){
            (collectionView.cellForItem(at: indexPath) as? DateCell)?.blueChooseLine.isHidden = true
        }
        else{
            (collectionView.cellForItem(at: indexPath) as? ColorTagCollectionViewCell)?.blueChooseLine.isHidden = true

        }
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
