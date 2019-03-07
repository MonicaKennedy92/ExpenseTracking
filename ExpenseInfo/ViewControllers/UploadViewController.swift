

import UIKit
import SafariServices
import Photos
import Foundation

import CoreTelephony
import MobileCoreServices

class UploadViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    private var displayedRectangleResult: RectangleDetectorResult?
    
    @IBOutlet weak var uploadBtn: UIButton!
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    
    @IBAction func cloaseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    @discardableResult private  func displayRectangleResult(rectangleResult: RectangleDetectorResult) -> Quadrilateral {
        displayedRectangleResult = rectangleResult
        
        let quad = rectangleResult.rectangle.toCartesian(withHeight: rectangleResult.imageSize.height)
        
        DispatchQueue.main.async { [weak self] in
            guard self != nil else {
                return
            }
            
        }
        
        return quad
    }
    @IBAction func uploadAction(_ sender: Any) {
        UserDefaults.standard.set("Upload", forKey: "AddExpenseType")
        
        
        alert.dismiss(animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        
        if imageView.image != nil {
            //
            let crop = self.storyboard?.instantiateViewController(withIdentifier: "EditScanViewController") as? EditScanViewController
            crop?.image = imageView.image
            
            if let aCrop = crop {
                self.present(aCrop, animated: true)
            }
            
            
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        imagePicker.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        uploadBtn.layer.shadowOpacity = 1.0
        uploadBtn.layer.shadowRadius = 10.0
        uploadBtn.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }
    func metadata(fromImageData imageData: Data?) -> [AnyHashable: Any]? {
        let imageSource = CGImageSourceCreateWithData((imageData) as? CFData? as! CFData, nil)
        if imageSource != nil {
            let options = [kCGImageSourceShouldCache as String: (0)]
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, (options as? CFDictionary?)!)
            if imageProperties != nil {
                let metadata = imageProperties as? [AnyHashable: Any]
                if let aMetadata = metadata {
                    print("Metadata of selected image\(aMetadata)")
                }
                return metadata
            }
        }
        print("Can't read metadata")
        return nil
    }
    
    
}
private struct RectangleDetectorResult {
    
    let rectangle: Quadrilateral
    
    let imageSize: CGSize
    
}
