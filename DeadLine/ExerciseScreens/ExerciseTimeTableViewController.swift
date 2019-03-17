//
//  ExerciseTimeTableViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 17/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class ExerciseTimeTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

 //Данный класс - класс, описывающий экран с таблицей расписания пар. По сути, данный экран состоит из двух частей - таблица пар и небольшой collectionView (это такая более кастомная таблица) для выбора желаемой даты

//Как может показаться выше, данный класс от 5 классов. Нет, наследуется он только от UIViewController, остальное - делегаты, позволяющие внутри нашего класса выполнять определенные методы для таблица и коллекции, ниже они будут

    @IBOutlet weak var exercisesTimeTable: UITableView!         //Собственно герои нашего времени - таблица
    @IBOutlet weak var pickDateCollection: UICollectionView!    //И collectionView
    
    let amountDays = ApplicationData.shared.dateManager.getAmountForSlider()    //Подпитываем количество дней с самописного Синглтона. Да, я больной и запихнул половину вещей в синглтон
    var dayToShow = Date()      //Переменная, означающая текущий день, ну точнее на какой день отскроллить расписание
    //var dayToLoad = Date()
    var dataToLoad = [Exercise]()   //Массив типа "упражнение" - используется для прогрузки таблицы и хранит все пары на определенный день, когда мы его отображаем
    
    override func viewDidLoad() {       //Метод, вызываемый при первой инициализации
        super.viewDidLoad()
        pickDateCollection.delegate = self              //Далее мы как раз таки указываемый, что класс, описывающий количество ячеек и какие ячейки использовать в таблице и коллекции
        pickDateCollection.dataSource = self
        exercisesTimeTable.delegate = self
        exercisesTimeTable.dataSource = self
        exercisesTimeTable.tableFooterView = UIView()       //Маленькое наведение красоты - чтобы внизу таблицы отображался монотонный серый вид
        exercisesTimeTable.estimatedRowHeight = 50          //Из-за того, что название предмета и адрес могут быть многострочными, то и размер ячейки будет динамическим - в этих двух строчка мы про это и говорим
        exercisesTimeTable.rowHeight = UITableView.automaticDimension
        exercisesTimeTable.sectionHeaderHeight = 38
    }
    
    func  loadExercisesForDay(day: Date){       //Функция загрузки пар на определенный день? Идиот, зачем запихнул одну строчку в отдельный метод? Бесит писать 15 точек, да и в перспективе тут будет > 1 строки, например веселье с асинхронностью и загрузкой данных с сервера
        dataToLoad = ApplicationData.shared.server.exerciseSystem.getExercisesForUser(for: ApplicationData.shared.currentUser!, day: day)!
        //Но пока что мы просто обращаемся к синглтону и просим у класса, отвечающего за хранение пар получить пары для нашего юзера
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {   //Один из методов, которым мы делигировали наш класс - возвращает количество строчек в каждой секции таблицы
        return amountDays.last!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {       //Метод, описывающий происходящее для инициализации ячейки коллекции на определенной позиции - здесь мы прикручиваем ячейки даты
        
        //В чём сущность данного метода - мы создаем объект ячейки, настраиваем его, возвращаем, а затем коллекция его хавает. В таблице всё работает аналогичер
        
        //Сначала мы региструем в нашу коллекцию ячейку, взятую из других файлов за счет наличия у оной уникального идентификатора
        //Затем мы достаем её из пула регистрированных по указанному идентификатору и делаем принудительное приведение типа для обращения к её полям
        collectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "Date")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Date", for: indexPath) as! DateCell
        
        
        cell.blueChooseLine.isHidden = true     //Прячем линию выбора
        
        cell.dateNumberLabel.text = "\(ApplicationData.shared.dateManager.countDayNumber(number: indexPath.row + 1, arrayMonthRanges: amountDays))"     //Узнаем, какое число сегодня, этот метод есть в другом классе
        
        cell.dayOfWeekLabel.text = convertNumberToDay(number: (indexPath.row + 1) % 7 + 1)  //Вычисляем день недели
        cell.frame.size.width = 50  //Размер выставляем
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Метод, вызвающийся при нажатии на ячейку коллекции - должен бытиь переход к соответствующей дате
            (collectionView.cellForItem(at: indexPath) as! DateCell).blueChooseLine.isHidden = false
            let date = ApplicationData.shared.dateManager.countNumberToDay(number: indexPath.row + 1)   //Конвертируем дату из числа (я в классе DateManager опишу это подробно)
            loadExercisesForDay(day: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //Что происходит при отмене выбора ячейки
        (collectionView.cellForItem(at: indexPath) as? DateCell)?.blueChooseLine.isHidden = true
    }
    
    //Далее идёт инициализация таблицы - там всё очень похоже на коллекцию, тонкости опишу
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        loadExercisesForDay(day: ApplicationData.shared.dateManager.countNumberToDay(number: section + 1))
        return dataToLoad.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {   //Возвращение количества секции. Другими словами, разбиение таблицы на подтаблицы
        return amountDays.last!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{  //Если это первое обращение к данной секции, то надо прогрузить занятия на данную секцию
            loadExercisesForDay(day: ApplicationData.shared.dateManager.countNumberToDay(number: indexPath.section + 1))
        }
        
        tableView.register(UINib(nibName: "ExerciseViewCell", bundle: nil), forCellReuseIdentifier: "Exercise")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise") as! ExerciseViewCell
        cell.linkedExercise = dataToLoad[indexPath.row]
        cell.preloadCellInfo()
        return cell
    }
    
    //Метод, настраивающий внешний вид промежутка между секциями таблицы - у нас там написана дата и день недели
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 38))
        headerView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
        //Вытстраиваем цвета и размеры
        
        let textDate = UILabel()
        textDate.frame = CGRect(x: 0, y: 0, width: 46, height: 15)
        textDate.backgroundColor = .white
        
        textDate.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        textDate.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.0)
        textDate.font = UIFont(name: "SFProText-Regular", size: 12)
        
        //Здесь загружаем день недели
        let day = ApplicationData.shared.dateManager.countDayNumber(number: section + 1, arrayMonthRanges: amountDays)
        let nday = self.convertNumberToDay(number: ((section + 1) % 7 + 1))
        textDate.text = "\(day), \(nday)"
        
        headerView.addSubview(textDate)
        textDate.layer.position.x = 69
        textDate.layer.position.y = 20
        
        return headerView
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
