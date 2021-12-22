//
//  DetailVC.swift
//  CD
//
//  Created by Константин Козлов on 29.11.2021.
//

import UIKit
import PhotosUI

class DetailVC: UIViewController{
    
    var task = Tasks() //данные для отбражения деталей задания
    let dataStoreManager = DataStoreManager()
    var  placeholderLabel = UILabel()  //UILabel для отбражения предложения ввести текст в UITextView
    
    @IBOutlet weak var imageOfDetailTask: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailLable: UILabel!
    
   //конфигурирование NavigationBar
    private func configereNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDetailTask))
        title = task.name
    }
    
    //Отображение DetailVC
    func displayTask(task: Tasks) {
        
        imageOfDetailTask.layer.cornerRadius = imageOfDetailTask.frame.width / 10
        imageOfDetailTask.clipsToBounds = true
        
        detailTextView.layer.borderWidth = 5.0
        detailTextView.layer.borderColor = CGColor(genericCMYKCyan: 0.5, magenta: 0.5, yellow: 0.5, black: 0.5, alpha: 0.2)
        
        detailTextView.text =  task.detailDescription
        imageOfDetailTask.image = fechTaskImage(task: task)
    }
    
    //Сохранение изображения и детального описания задачи
    @objc func saveDetailTask(){
        
        let image = imageOfDetailTask.image ??  UIImage(named: "photoImage")!
        let detailText = detailTextView.text ?? ""
        dataStoreManager.saveDetailTask(task: task, image: image, detailDescription: detailText)
        navigationController?.popViewController(animated: true)
        
    }
    
    //обработка нажатия по изображению
    private func configureImageTapped(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageOfDetailTask.addGestureRecognizer(tapGestureRecognizer)
        imageOfDetailTask.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(){
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePecker(source: .camera)
        }
        let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
            self.choosePHPiecker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cameraAction)
        ac.addAction(photoAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configereNavBar()
        displayTask(task: task)
        configureImageTapped()
        registerForKeyboardNotification()
        detailTextView.resignFirstResponder()
        detailTextView.delegate = self
        setupToHideKeyboardOnTapOnView()
        configurePlaceholderOfTextView()
    }
    
    
    
    deinit{
        removeKeyboardNotification()
    }
    
    //получение изображения при открытии DetailVC
    private func fechTaskImage(task: Tasks) -> (UIImage){
        guard let imageData = task.image else {return UIImage(named: "photoImage") ?? UIImage()}
        guard let taskImage = UIImage(data: imageData) else {return UIImage(named: "photoImage") ?? UIImage()}
        return taskImage
    }
    
    //регистрация обзерверов работы с клавиатурой
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //удаление обзерверов работы с клавиатурой
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Сдвиг контента при поднятии клавиатуры
    @objc func kbWillShow(notification: NSNotification){
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardSize.height)
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardSize.height)
    }
    
    //Сдвиг контента при опуске клавиатуры
    @objc func kbWillHide(notification: NSNotification){
        scrollView.contentOffset = CGPoint.zero
    }
}

extension DetailVC: UITextViewDelegate
{
    
    //Опуск клавиатуры по тапу на свободном месте
  func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    //конфигурирование  UITextView
    func configurePlaceholderOfTextView(){
        placeholderLabel = UILabel()
        placeholderLabel.text = " Введите здесь описание задачи..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (detailTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        detailTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (detailTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.gray
        placeholderLabel.isHidden = !detailTextView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !detailTextView.text.isEmpty
    }
    
  }


//MARK: Work with image

extension DetailVC: PHPickerViewControllerDelegate {
    
    func chooseImagePecker(source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true, completion: nil)
        
        for item in results {
            
            item.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    
                    DispatchQueue.main.async {
                        self.imageOfDetailTask.image = image
                    }
                }
            }
        }
        
    }
    
    func choosePHPiecker(){
        var configPHPiecker = PHPickerConfiguration()
        configPHPiecker.filter = .images
        configPHPiecker.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configPHPiecker)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
}


