//
//  NewTaskViewController.swift
//  DeadLine
//
//  Created by Дмитрий Ванюшкин on 12/03/2019.
//  Copyright © 2019 Dmitry Vanyushkin. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var newTagNameTextField: UITextField!
    @IBOutlet weak var saveNewTagButton: UIButton!
    @IBOutlet weak var newTaskNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var newTagsColor: UICollectionView!
    @IBOutlet weak var tagsCollection: UICollectionView!
    @IBOutlet weak var setRemindButton: UIButton!
    
    var overallDate = Date()
    var isTimeEnabled = false
    var chosenTopic : RelatedTopic? = nil
    
    var rememberedColor : UIColor?
    var tagsList = ApplicationData.shared.currentUser?.getUserTags

    let datePicker = UIDatePicker()
    let timePicker = UIPickerView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveNewTagButton.relevantColorForState()
        setRemindButton.relevantColorForState()
        saveNewTagButton.isEnabled = false
        setRemindButton.isEnabled = false
        saveNewTagButton.setTitleColor(UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0), for: .disabled)
        saveNewTagButton.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        
        newTaskNameTextField.textColor = UIColor.black
        
        newTaskNameTextField.layer.borderWidth = 1
        newTaskNameTextField.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor
        newTagsColor.delegate = self
        newTagsColor.dataSource = self
        tagsCollection.delegate = self
        tagsCollection.dataSource = self
        newTagsColor.allowsMultipleSelection = false
        tagsCollection.allowsMultipleSelection = false
        
        newTagNameTextField.addTarget(nil, action: #selector(changeTextValue), for: .editingChanged)
        
        initDateTimePickers()
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    func initDateTimePickers(){
        datePicker.datePickerMode = .date
        timePicker.delegate = self
        timePicker.delegate = self
        datePicker.addTarget(nil, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        

    }
    
    @objc func datePickerChanged(datePicker : UIDatePicker){
        print(datePicker.date)
        overallDate.setDate(from : datePicker.date)
        dateTextField.text = overallDate.getDateWithNoTime()
    }
    
    
    @objc func changeTextValue(textField : UITextField){
        if !((textField.text ?? "").isEmpty || rememberedColor == nil){
            saveNewTagButton.isEnabled = true
        }
        else{
            saveNewTagButton.isEnabled = false
        }
    }
    
    
    @IBAction func addTag(_ sender: Any) {
        let short = newTagNameTextField.text!
        let color = rememberedColor!.toHexString()
        ApplicationData.shared.currentUser?.setNewTag(relatedTopic: RelatedTopic(short: short, color: color))
        tagsList = ApplicationData.shared.currentUser?.getUserTags
        tagsCollection.reloadData()
    }
    
    @IBAction func addTask(_ sender: Any) {
        if (!newTaskNameTextField.text!.isEmpty && chosenTopic != nil){
            ApplicationData.shared.server.taskSystem.addTaskForUser(for: ApplicationData.shared.currentUser!, task: Task(description: newTaskNameTextField.text!, date: overallDate, relatedTopic: chosenTopic!, taskOwn: ApplicationData.shared.currentUser!, isTime: isTimeEnabled))
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func setRemind(_ sender: Any) {
    }
    
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch  component {
        case 0:
            return 24
        default:
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !(isTimeEnabled){
            isTimeEnabled = true
        }
        
        let hours = pickerView.selectedRow(inComponent: 0)
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
