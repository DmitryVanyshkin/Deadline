//
//  NewTaskViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 12/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

//Класс, отвечающий за страницу добавления товаров

//Уххх, как тут много делегатов. Все мы уже видели, кроме делегатов на пикер. Что такое пикер, объяснять я не буду. Данные делегаты позволяют внутри класса описать методы пикера - откуда ему брать данные для отображения и что происходит при выборе

class NewTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var newTagNameTextField: UITextField!        //Текстовое поле для названия нового тека
    @IBOutlet weak var saveNewTagButton: UIButton!
    @IBOutlet weak var newTaskNameTextField: UITextField!       //Для описания задания
    @IBOutlet weak var dateTextField: UITextField!              //Это текстовые поля, но с подвохом - в них нельзя ничего писать и при их нажатии вызываются пикеры
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var newTagsColor: UICollectionView!          //Коллекция выбора цвета для нового тега
    @IBOutlet weak var tagsCollection: UICollectionView!        //Для выбора тега, к которому всё привязывать
    @IBOutlet weak var setRemindButton: UIButton!
    
    var overallDate = Date()                                    //Дата задания
    var isTimeEnabled = false                                   //Нужно ли уточнсять время выполнения задания
    var chosenTopic : RelatedTopic? = nil                       //Какому тегу соответствует это дело. Изначально никакому
    
    var rememberedColor : UIColor?                              //Какой цвет добавить на новый тег
    var tagsList = ApplicationData.shared.currentUser?.getUserTags  //Список тегов пользоватедя

    let datePicker = UIDatePicker()                             //Пикер даты - системный и не требует особых делегатов
    let timePicker = UIPickerView()                             //Пикер времени - он блин обосранский и требует делегатов на часы и минуты
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveNewTagButton.relevantColorForState()    //Выставляем правильные цвета для каждого состояния кнопки
        setRemindButton.relevantColorForState()
        saveNewTagButton.isEnabled = false          //Кнопки эти пока недоступны, тк ничего не выбрали
        setRemindButton.isEnabled = false
        //РАСКРАСКИ УУУУ ЕЕЕЕ АААА ЭЭЭЭ
        saveNewTagButton.setTitleColor(UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0), for: .disabled)
        saveNewTagButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        
        newTaskNameTextField.textColor = UIColor.black
        
        newTaskNameTextField.layer.borderWidth = 1
        newTaskNameTextField.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor
        newTagsColor.delegate = self    // Выставляем все делегаты и датасурсы
        newTagsColor.dataSource = self
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        newTagsColor.allowsMultipleSelection = false
        tagsCollection.allowsMultipleSelection = false
        //Привязываем действие к полю, отвечающему за имя нового тега - данное действие проверяет, выбрали ли мы цвет нового тега и название
        newTagNameTextField.addTarget(nil, action: #selector(changeTextValue), for: .editingChanged)
        
        initDateTimePickers()
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    func initDateTimePickers(){ //Выставляем красоту, делегаты и привязку действий для пикеров
        datePicker.datePickerMode = .date
        timePicker.delegate = self
        timePicker.delegate = self
        datePicker.addTarget(nil, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged) //действие, вызываемое при изменении значения пикера
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        

    }
    
    @objc func datePickerChanged(datePicker : UIDatePicker){ //Изменили дату в пикере - обновите текстовое поле, отвечающее за дату
        print(datePicker.date)
        overallDate.setDate(from : datePicker.date)
        dateTextField.text = overallDate.getDateWithNoTime()
    }
    
    
    @objc func changeTextValue(textField : UITextField){    //Написали новое имя у тега - надо сделать проверку, можно ли его уже обновлять
        if !((textField.text ?? "").isEmpty || rememberedColor == nil){
            saveNewTagButton.isEnabled = true
        }
        else{
            saveNewTagButton.isEnabled = false
        }
    }
    
    
    @IBAction func addTag(_ sender: Any) {      //Метод добавления тэга - всё просто. Берем текст и цвет, преобразуем цвет в hex-код и закидываем в контруктор, обновляем таблицу тегов
        let short = newTagNameTextField.text!
        let color = rememberedColor!.toHexString()
        ApplicationData.shared.currentUser?.setNewTag(relatedTopic: RelatedTopic(short: short, color: color))
        tagsList = ApplicationData.shared.currentUser?.getUserTags
        tagsCollection.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {     //Добавление нового задания
        if (!newTaskNameTextField.text!.isEmpty && chosenTopic != nil){ //Проверка на непустоту текста и наличие выбранного тега
            ApplicationData.shared.server.taskSystem.addTaskForUser(for: ApplicationData.shared.currentUser!, task: Task(description: newTaskNameTextField.text!, date: overallDate, relatedTopic: chosenTopic!, taskOwn: ApplicationData.shared.currentUser!, isTime: isTimeEnabled))
            self.navigationController?.popToRootViewController(animated: true) //Закрываем это всё за собой
        }
    }
    
    @IBAction func setRemind(_ sender: Any) {   //Выставить уведомление - пока пусто
    }
    
    //Инициализация коллекций - всё как всегда, просто их две и нужно проверять, добавили условную конструкцию для этого
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === tagsCollection{
            return ApplicationData.shared.currentUser?.getUserTags.count ?? 0
        }
            
        else{
            return colorsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === tagsCollection{
            collectionView.register(UINib(nibName: "ColorTagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ThemeTag")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeTag", for: indexPath) as! ColorTagCollectionViewCell
            cell.relatedTopic = tagsList![indexPath.row]
            cell.setDataForLabel()
            
            return cell
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorTag", for: indexPath) as! ColorTagCell
            cell.setColor(hex : colorsList[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === tagsCollection{
            (collectionView.cellForItem(at: indexPath) as? ColorTagCollectionViewCell)?.changeBlueLine()
            chosenTopic = (collectionView.cellForItem(at: indexPath) as! ColorTagCollectionViewCell).relatedTopic
            
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! ColorTagCell
            cell.switchState()
            rememberedColor = cell.backgroundColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView === tagsCollection{
            (collectionView.cellForItem(at: indexPath) as? ColorTagCollectionViewCell)?.changeBlueLine()
            
        }
        else{
            (collectionView.cellForItem(at: indexPath) as? ColorTagCell)?.switchState()
        }
    }
    
    //Инициализация пикера - количество стобликов с правом выбора
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //Количество компонент в каждом столбике
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch  component {
        case 0:
            return 24
        default:
            return 60
        }
    }
    
    //Как выглядит контент пикера
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    //Что происходит при изменении значения в пикере
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !(isTimeEnabled){            //Если мы первый раз решили выбрать время, то флаг поменяется
            isTimeEnabled = true
        }
        
        let hours = pickerView.selectedRow(inComponent: 0)      //Записываем значения в текстфилд
        let minutes = pickerView.selectedRow(inComponent: 1)
        
        overallDate.setTime(hours: hours, minutes: minutes)
        timeTextField.text = overallDate.getTime()
        
    }

}

extension UIButton{
    func relevantColorForState(){
        self.setTitleColor(UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0), for: .disabled)
        self.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
    }
}
