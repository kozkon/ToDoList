//
//  DetailVC.swift
//  CD
//
//  Created by Константин Козлов on 29.11.2021.
//

import UIKit
import PhotosUI

class DetailVC: UIViewController{
    
    var task = Tasks()
    
    @IBOutlet weak var nameTaskLable: UILabel!
    @IBOutlet weak var imageTaskLable: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    
    private func configereNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDetailTask))
        title = task.name
    }
    
    func displayTask(task: Tasks) {
        nameTaskLable.text = task.name
        detailTextView.text = task.detailDescription
        imageTaskLable.image = fechTaskImage(task: task)
        
    }
    
    @objc func saveDetailTask(){
        
    }
    
    private func configureImageTapped(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageTaskLable.addGestureRecognizer(tapGestureRecognizer)
        imageTaskLable.isUserInteractionEnabled = true
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
        
        displayTask(task: task)
        configureImageTapped()
        
    }
    
    private func fechTaskImage(task: Tasks) -> (UIImage){
        guard let imageData = task.image else {return UIImage(named: "photoImage") ?? UIImage()}
        let taskImage = UIImage(data: imageData)
        return taskImage ?? UIImage(named: "photoImage")!
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
                        self.imageTaskLable.image = image
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


