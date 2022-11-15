//
//  ViewController.swift
//  ImageRecogenation
//
//  Created by Mamdouh on 06/11/2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUserPick = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = imageUserPick
            guard let ciimage = CIImage(image: imageUserPick) else {
                fatalError("loading image is failed")
            }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true)
    }
    
    
    func detect(image: CIImage){
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: Transportation(configuration: config).model)else{
            fatalError("loading core model failed")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("observation error")
            }
            let firstResult = results.first?.identifier
            self.navigationItem.title = firstResult
         }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
    @IBAction func CameraPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

