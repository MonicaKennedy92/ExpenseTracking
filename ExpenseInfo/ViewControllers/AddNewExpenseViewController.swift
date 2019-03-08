

import UIKit
import DatePickerDialog
import LLSwitch
import WSTagsField
import Vision
import Firebase
import FirebaseMLVision
import CoreData




class AddNewExpenseViewController: UIViewController,LLSwitchDelegate,UITextFieldDelegate,DataEnteredDelegate,UITextViewDelegate, UIViewControllerTransitioningDelegate {
    var fromCategory : Bool = false
    @IBOutlet weak var catId: UILabel!
    @IBOutlet weak var catColor: UILabel!
    @IBOutlet weak var merchantIcon: UIButton!
    func userDidEnterInformation(info: String, image: String, id: String , color: String) {
        category.text = info
        categoryImg.image = UIImage(named: image)
        catId.text = id
        catColor.text = color
        fromCategory = true
    }
    fileprivate let tagsField = WSTagsField()
    struct ImageDisplay {
        let file: String
        let name: String
    }
    
    var currencySymbol : String = "$"
    var currencyCode : String = "USD"
    @IBOutlet weak var imageView: UIImageView!
    var tagsString : [String] = []
    
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio) ?
            imageViewHeight / imageHeight :
            imageViewWidth / imageWidth
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    fileprivate enum Constants {
        static let lineWidth: CGFloat = 3.0
        static let lineColor = UIColor.yellow.cgColor
        static let fillColor = UIColor.clear.cgColor
        static let smallDotRadius: CGFloat = 5.0
        static let largeDotRadius: CGFloat = 10.0
        static let detectionNoResultsMessage = "No results returned."
        static let failedToDetectObjectsMessage = "Failed to detect objects in image."
        static let labelsFilename = "labels"
        static let labelsExtension = "txt"
        static let labelsSeparator = "\n"
        static let modelExtension = "tflite"
        static let dimensionBatchSize: NSNumber = 1
        static let dimensionImageWidth: NSNumber = 224
        static let dimensionImageHeight: NSNumber = 224
        static let dimensionComponents: NSNumber = 3
        static let modelInputIndex: UInt = 0
        static let localModelFilename = "mobilenet_v1.0_224_quant"
        static let hostedModelFilename = "mobilenet_v1_224_quant"
        static let maxRGBValue: Float32 = 255.0
        static let topResultsCount: Int = 5
        static let inputDimensions = [
            dimensionBatchSize,
            dimensionImageWidth,
            dimensionImageHeight,
            dimensionComponents,
            ]
        static let modelElementType: ModelElementType = .uInt8
        
        static let images = [
            ImageDisplay(file: "Please_walk_on_the_grass.jpg", name: "Image 1"),
            ImageDisplay(file: "non-latin.jpg", name: "Image 2"),
            ImageDisplay(file: "nl2.jpg", name: "Image 3"),
            ImageDisplay(file: "grace_hopper.jpg", name: "Image 4"),
            ImageDisplay(file: "tennis.jpg", name: "Image 5"),
            ImageDisplay(file: "mountain.jpg", name: "Image 6"),
            ]
    }
    var activeField: UITextField?
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var merchant: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var reimbursement: LLSwitch!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var currency: UIButton!
    var isKeyboardUp: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let currencyCode1 = UserDefaults.standard.value(forKey: "CurrencyCode") {
            currencyCode = currencyCode1 as! String
        }
        if let currencySymbol1 = UserDefaults.standard.value(forKey: "CurrencySymbol") {
            currencySymbol = currencySymbol1 as! String
        }
        
        self.currency.setTitle(currencyCode, for: .normal)
        
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        reimbursement.delegate = self
        
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        tagsField.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        
        notes.delegate = self
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = UIColor(hexString: "687792")
        tagsField.placeholderAlwaysVisible = false
        tagsField.backgroundColor = .clear
        tagsField.returnKeyType = .done
        tagsField.delimiter = ""
        tagsField.font = UIFont(name: "WorkSans-Regular", size: 18.0)
        tagsField.textColor = UIColor(hexString: "2F3C4B")//UIColor(hexString: "426891")
        tagsField.fieldTextColor = UIColor(hexString: "2F3C4B")
        tagsField.selectedColor = UIColor(hexString: "DADEEB")
        tagsField.selectedTextColor = UIColor(hexString: "2F3C4B")
        tagsField.tintColor = UIColor(hexString: "DADEEB")
        tagsField.textDelegate = self
        tagsField.acceptTagOption = .space
        
        textFieldEvents()
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: currentdate)
        date.text = result
        
        let timestamp = NSDate().timeIntervalSince1970

        
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
       var currentTime = formatter.string(from: Date())
        
        print(currentTime)
        time.text = currentTime
        
        let type = UserDefaults.standard.value(forKey: "AddExpenseType") as! String
        
        if type == "Edit" {
            
            
            reimbursement.setOn(reimburseSwitch, animated: true)
        }
        if type == "Manual" {
            UserDefaults.standard.setValue(nil, forKey: "DisplayImg")
            UserDefaults.standard.synchronize()
        }
        if (type != "Manual" && type != "Edit") {
            EZLoadingActivity.show("ocr ....", disableUI: true)
            if  UserDefaults.standard.value(forKey: "DisplayImg") != nil {
                
                
                let billimage = UIImage(data: UserDefaults.standard.value(forKey: "DisplayImg") as! Data)
                _ = fixOrientation(image:billimage!)
                if  UserDefaults.standard.value(forKey: "ReceiptImg") != nil {
                    
                    
                    let imagePath = UserDefaults.standard.object(forKey: "ReceiptImg") as? Data
                    if imagePath != nil {
                        imageView.image = UIImage(data: imagePath!)
                    }
                    
                    let billimage = imageView.image
                    if billimage != nil {
                        
                    } else {
                        
                    }
                    firstTask { (success) -> Void in
                        if success {
                            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(AddNewExpenseViewController.ocrUpdate), userInfo: nil, repeats: false)
                        }
                    }
                    
                }
            }
        }
        
        
    }
    // MARK: - Switch Delegate
    func didTap(_ llSwitch: LLSwitch?) {
        print("start")
    }
    
    func animationDidStop(for llSwitch: LLSwitch?) {
        print("stop")
    }
    var reimburseSwitch : Bool = false
    func valueDidChanged(_ llSwitch: LLSwitch?, on: Bool) {
        print(String(format: "stop --- on:%hhd", on))
        if on {
            reimburseSwitch = true
        } else {
            reimburseSwitch = false
        }
        
    }
    var gotTotal: Bool = false
    @objc func ocrUpdate()
    {
        print("Total Array ============================>  \(lineArray)")
        print("Bloacks =====================> \(blockArray)")
        
        for (index , value) in self.blockArray.enumerated() {
            
            if gotTotal {
                print("Total============> :\(value)")
            }
            if (( (value as! String).lowercased()).contains("total") ||  ((value as! String).lowercased()).contains("net")  || ((value as! String).lowercased()).contains("tend") || ((value as! String).lowercased()).contains("card") || ((value as! String).lowercased()).contains("amount")) {
                gotTotal = true
                
            }
            
            
            
        }
        
        
        var cassPaid : Bool = false
        if lineArray.count > 0 {
            for (index , value) in self.lineArray.enumerated() {
                //                if (( (value as! String).lowercased()).contains("total") ||  ((value as! String).lowercased()).contains("net")  || ((value as! String).lowercased()).contains("tend") || ((value as! String).lowercased()).contains("card") || ((value as! String).lowercased()).contains("amount")) {
                //                    print("Total============> :\(value)")
                //
                //                    if (((value as! String).lowercased()).contains("cash")) {
                //                        cassPaid = true
                //                        break
                //                    } else {
                //                        self.amountArray.add(index)
                //                        self.amountArrayValue.add(value)
                //
                //                    }
                //                }
                var string: String = value as! String
                if (string as AnyObject).contains(".") {
                    string = string.trimmingCharacters(in: .whitespaces)
                    string = string.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
                    string = string.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                    string = string.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
                    
                    var intValues = Float(string)
                    print("exists  \(intValues)")
                    if intValues > 0 {
                        if let i = intValues {
                            print("Amounts Float ===============> \(i)")
                            
                            var roundedString = String(format: "%.2f", i)
                            self.amountArray.add(index)
                            self.amountArrayValue.add(roundedString)
                            if (roundedString == String(i)) {
                                print("Amounts ===============> \(roundedString)")
                            }
                        } else {
                            // Tell user the value is invalid
                        }
                    }
                }
                
            }
            
        }
        print("Amounts ===============> \(amountArrayValue)")
        print(self.amountArray)
        let totalArrayCount : NSMutableArray = []
        //        if amountArray.count > 0 {
        //            for val in amountArray {
        //                let value = val as! Int
        //                let lastObject = amountArray.lastObject as! Int
        //                if (lastObject == value) {
        //
        //                    if cassPaid {
        //                        var topValue = String("\(lineArray[value - 1])").trimmingCharacters(in: .whitespaces)
        //                        topValue = topValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        //                        topValue = topValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        //
        //                        topValue = topValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //
        //                        if Float(topValue) != nil {
        //                            totalArrayCount.add(Float(topValue)!)
        //                        }
        //
        //
        //                    } else {
        //                        var topValue = String("\(lineArray[value - 1])").trimmingCharacters(in: .whitespaces)
        //                        var bottomValue = String("\(lineArray[value + 1])").trimmingCharacters(in: .whitespaces)
        //                        topValue = topValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        //                        topValue = topValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        //
        //                        bottomValue = bottomValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        //                        bottomValue = bottomValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        //
        //                        topValue = topValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //                        bottomValue = bottomValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //
        //                        if Float(topValue) != nil {
        //                            totalArrayCount.add(Float(topValue)!)
        //                        }
        //                        if Float(bottomValue) != nil {
        //                            totalArrayCount.add(Float(bottomValue)!)
        //                        }
        //
        //                    }
        //
        //
        //                } else {
        //                    var topValue = String("\(lineArray[value - 1])").trimmingCharacters(in: .whitespaces)
        //                    var bottomValue = String("\(lineArray[value + 1])").trimmingCharacters(in: .whitespaces)
        //                    topValue = topValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        //                    topValue = topValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        //
        //                    bottomValue = bottomValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
        //                    bottomValue = bottomValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        //
        //                    topValue = topValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //                    bottomValue = bottomValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //
        //                    if Float(topValue) != nil {
        //                        totalArrayCount.add(Float(topValue)!)
        //                    }
        //                    if Float(bottomValue) != nil {
        //                        totalArrayCount.add(Float(bottomValue)!)
        //                    }
        //
        //
        //                }
        //
        //            }
        //        }
        
        
        if amountArrayValue.count > 0 {
            for val in amountArrayValue {
                let valueString = val as! String
                var topValue = valueString.trimmingCharacters(in: .whitespaces)
                topValue = topValue.replacingOccurrences(of: "$ ", with: "", options: NSString.CompareOptions.literal, range: nil)
                topValue = topValue.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                topValue = topValue.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
                
                if Float(topValue) != nil {
                    totalArrayCount.add(Float(topValue)!)
                }
                
            }
        }
        print(totalArrayCount)
        var counts: [Float: Int] = [:]
        
        for item in totalArrayCount as! [Float]{
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        print("Amount : \(counts)")  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
        }
        var restAmount : [Float] = []
        var findTotAmount : [Float] = []
        var totalAmountValue : Float = 0.00
        var taxAmount : Float = 0.00
        var amountTotal : Float = 0.00
        
        for (key,value) in counts {
            findTotAmount.append(key)
        }
        
        if findTotAmount.count > 0 {
            totalAmountValue = findTotAmount.max()!
            amount.text = " \(totalAmountValue)"
            counts.removeValue(forKey: totalAmountValue)
        }
        
        for (key,value) in counts {
            
            restAmount.append(key)
        }
        //        if restAmount.count > 0 {
        //            taxAmount = restAmount.min()!
        //            let predictedAmount = totalAmountValue - taxAmount
        //
        //            amountTotal = restAmount.max()!
        //            if amountTotal == predictedAmount {
        //                taxCell.taxTxtFld.text = "\(currencyForExpense) \(taxAmount)"
        //                amountCell.amountTxtFld.text = "\(currencyForExpense) \(amountTotal)"
        //            } else {
        //                taxCell.taxTxtFld.text = "\(currencyForExpense) \(taxAmount)"
        //                amountCell.amountTxtFld.text = "\(currencyForExpense) \(amountTotal)"
        //            }
        //            print(totalAmountValue)
        //            print(amountTotal)
        //            print(taxAmount)
        //
        //        }
        print(counts)
        EZLoadingActivity.hide()
        
    }
    
    
    @IBAction func merchantListOpen(_ sender: Any) {
        
        deregisterFromKeyboardNotifications()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)

      
    }
    func updatenewMerchant(merchantName : String) {
        merchant.text = merchantName
        merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)//imageView?.image =
    }
    func getExpenseforEdit() {
        var expenseListArray = [ExpenseListInfo]()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let idString = UserDefaults.standard.value(forKey: "expenseListArray") as? String
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        
        
        typefetch.predicate = NSPredicate(format: "id == %@", idString!)
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count == 1 {
                for exp in fetchedtype {
                    currency.setTitle(exp.currencyCode, for: .normal)
                    date.text = exp.dateString
                    time.text = exp.timeString
                    merchant.text = exp.merchantName
                    category.text = exp.expenseCategory
                    catId.text = exp.categoryId
                    catColor.text = exp.categoryColor
                    categoryImg.image = UIImage(data: exp.expenseCategoryImg!)
                    amount.text = exp.amount!
                    reimburseSwitch = exp.reimbursable
                    reimbursement.setOn(reimburseSwitch, animated: true)
                    let share = exp.tags
                    configureTags(value: share as! [String])
                    print(exp.tags as? [String] as Any)
                    
                    notes.text = exp.notes
                }
            } else {
            }
        } catch {
            
            
        }
        
        
    }
    
    func configureTags(value : [String])  {
        for val in value {
            self.tagsField.addTag(val)
        }
    }
    func addnewExpenseNow() {
        
        let type = UserDefaults.standard.value(forKey: "AddExpenseType") as! String
        
        
        
        if merchant.text != "" && date.text != "" && time.text != "" && category.text != "" && amount.text != ""   {
            
            
            
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchedtype = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
            let idString = UserDefaults.standard.value(forKey: "expenseListArray") as? String
            
            if type == "Edit" {
                
                fetchedtype.predicate = NSPredicate(format: "id == %@ ",idString! )
            }
            do {
                let fetchDefault = try managedObjectContext.fetch(fetchedtype) as! [ExpenseContent]
                if type == "Edit" {
                    if fetchDefault.count == 1 {
                        for expenseContent in fetchDefault {
                            expenseContent.id = idString
                            expenseContent.merchantName = merchant.text
                            expenseContent.dateString = date.text
                            expenseContent.timeString = time.text
                            expenseContent.expenseCategory = category.text
                            expenseContent.reimbursable = reimburseSwitch
//                            let type = UserDefaults.standard.value(forKey: "AddExpenseType") as! String
//
//                            expenseContent.expenseMode = type
                            if let catimg =  categoryImg.image {
                                expenseContent.expenseCategoryImg  = catimg.pngData() as? Data
                            }
                            
                            expenseContent.expenseorIncome = currencySymbol
                            expenseContent.currencyCode = currencyCode
                            let trimmedString = amount.text!.trimmingCharacters(in: .whitespaces)
                            expenseContent.amount = trimmedString
                            expenseContent.notes = notes.text
                            expenseContent.categoryId = catId.text
                            expenseContent.categoryColor = catColor.text
                            expenseContent.tags = self.tagsString as NSObject
                            
                            if reimburseSwitch {
                                expenseContent.isClaimed = "NC"
                            } else {
                                expenseContent.isClaimed = "NA"
                            }
                            do {
                                try managedObjectContext.save()
                            } catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                        
                    }
                } else {
                    
                    
                    let expenseContent = NSEntityDescription.insertNewObject(forEntityName: "ExpenseContent", into: managedObjectContext) as! ExpenseContent
                    expenseContent.id = NSUUID().uuidString.lowercased()
                    expenseContent.merchantName = merchant.text
                    expenseContent.dateString = date.text
                    expenseContent.timeString = time.text
                    expenseContent.expenseCategory = category.text
                    expenseContent.reimbursable = reimburseSwitch
                    let type = UserDefaults.standard.value(forKey: "AddExpenseType") as! String
                    
                    expenseContent.expenseMode = type

                    if let catimg =  categoryImg.image {
                        expenseContent.expenseCategoryImg  = catimg.pngData() as? Data
                    }
                    
                    if let billimg =  imageView.image {
                        expenseContent.billImage  = billimg.pngData() as? Data
                    }
//                    if UserDefaults.standard.value(forKey: "DisplayImg") != nil {
//                        var imageData = UserDefaults.standard.value(forKey: "DisplayImg")
//                        expenseContent.billImage = imageData as! Data
//                    }
                    expenseContent.expenseorIncome = currencySymbol
                    expenseContent.currencyCode = currencyCode
                    if reimburseSwitch {
                        expenseContent.isClaimed = "NC"
                    } else {
                        expenseContent.isClaimed = "NA"
                    }
                    
                    
                    expenseContent.categoryId = catId.text
                    expenseContent.categoryColor = catColor.text
                    let trimmedString = amount.text!.trimmingCharacters(in: .whitespaces)
                    
                    expenseContent.amount = trimmedString
                    expenseContent.notes = notes.text
                    expenseContent.tags = self.tagsString as NSObject
                    do {
                        try managedObjectContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    
                }
                
            } catch {
                
                
            }
            
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseViewController") as? ExpenseViewController
            self.present(secondVC!, animated: true)
            
        } else {
            
            let alertMessage = UIAlertController(title: "Add Expense", message: "please fill the empty fields", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
    }
    
    
    func getScannedImage(inputImage: UIImage) -> UIImage? {
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        
        let filter = CIFilter(name: "CIColorControls")
        let coreImage = CIImage(image: inputImage)
        
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(20.0, forKey: kCIInputContrastKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        filter?.setValue(1.2, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let output = context.createCGImage(outputImage, from: outputImage.extent)
            return UIImage(cgImage: output!)
        }
        return nil
    }
    func firstTask(completion: (_ success: Bool) -> Void) {
        if  UserDefaults.standard.value(forKey: "ReceiptImg") != nil {
            
            
            let imagePath = UserDefaults.standard.object(forKey: "ReceiptImg") as? Data
            if imagePath != nil {
                imageView.image = UIImage(data: imagePath!)
            }
            
            
            let billimage = imageView.image
            var realImage = getScannedImage(inputImage: billimage!)
            imageView.image = billimage
            guard let cgImage = realImage?.cgImage,
                let initialOrientation = realImage?.imageOrientation,
                let filter = CIFilter(name: "CIPhotoEffectNoir")
                else { return }
            let sourceImage = CIImage(cgImage: cgImage)
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)
            guard let outputImage = filter.outputImage,
                let cgImageOut = context.createCGImage(outputImage, from: outputImage.extent)
                else { return }
            let imageview = UIImageView()
            imageview.image = billimage
            realImage = UIImage(cgImage: cgImageOut, scale: 1, orientation: initialOrientation)
            
            runTextRecognition(with: imageView.image!)
        }
        completion(true)
    }
    
    func textDetect(dectect_image:UIImage, display_image_view:UIImageView)->UIImage{
        let handler:VNImageRequestHandler = VNImageRequestHandler.init(cgImage: (dectect_image.cgImage)!)
        let result_img:UIImage = UIImage.init();
        let request:VNDetectTextRectanglesRequest = VNDetectTextRectanglesRequest.init(completionHandler: { (request, error) in
            if( (error) != nil){
                print("Got Error In Run Text Dectect Request");
            }else{
            }
        })
        
        //        print(self.globalArray)
        //        print(self.amountArray)
        request.reportCharacterBoxes = true
        do {
            try handler.perform([request])
            return result_img;
            print("Successful Run Text Dectect Request");
        } catch {
            return result_img;
        }
    }
    func addScreenShotToTextImages(sourceImage image: UIImage, boundingBox: CGRect) {
        let pct = 0.1 as CGFloat
        let newRect = boundingBox.insetBy(dx: -boundingBox.width*pct/2, dy: -boundingBox.height*pct/2)
        
        let imageRef = image.cgImage!.cropping(to: newRect)
        if imageRef != nil {
            let croppedImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
            textImages.append(croppedImage)
        }
    }
    var textImages = [UIImage]()
    lazy var vision = Vision.vision()
    var lineArray : NSMutableArray = []
    var amountArray : NSMutableArray = []
    var amountArrayValue : NSMutableArray = []
    
    var globalArray :NSMutableArray = []
    func runTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { features, error in
            self.processResult(from: features, error: error)
        }
    }
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    private func drawFrame(_ frame: CGRect, in color: UIColor, transform: CGAffineTransform) {
        let transformedRect = frame.applying(transform)
        UIUtilities.addRectangle(
            transformedRect,
            to: self.annotationOverlayView,
            color: color
        )
    }
    
    var blockArray:NSMutableArray = []
    
    
    func processResult(from text: VisionText?, error: Error?) {
        removeDetectionAnnotations()
        guard error == nil, let text = text else {
            let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
            print("Text recognizer failed with error: \(errorString)")
            return
        }
        let transform = self.transformMatrix()
        // Blocks.
        for block in text.blocks {
            drawFrame(block.frame, in: .purple, transform: transform)
            print("block ================================= > \(block.text)")
            blockArray.add(block.text)
            // Lines.
            for line in block.lines {
                drawFrame(line.frame, in: .orange, transform: transform)
                self.lineArray.add(line.text)
                merchant.text = self.lineArray[0] as? String
                print("Line ================================= > \(line.text)")
                // Elements.
                for element in line.elements {
                    drawFrame(element.frame, in: .green, transform: transform)
                    //  print("Element ================================= > \(element.text)")
                    self.isValidDate(dateString: element.text)
                    self.isValidTime(timeString: element.text)
                    let transformedRect = element.frame.applying(transform)
                    let label = UILabel(frame: transformedRect)
                    label.text = element.text
                    label.adjustsFontSizeToFitWidth = true
                    self.annotationOverlayView.addSubview(label)
                }
            }
        }
    }
    lazy var textRecognizer = vision.onDeviceTextRecognizer()
    func drawRectangleForTextDectect(image: UIImage, results:Array<VNTextObservation>) -> UIImage {
        //        let renderer = UIGraphicsImageRenderer(size: image.size)
        //        var t:CGAffineTransform = CGAffineTransform.identity;
        //        var theStringWithReplacements = NSMutableString()
        //        t = t.scaledBy( x: image.size.width, y: -image.size.height);
        //        t = t.translatedBy(x: 0, y: -1 );
        //        let img = renderer.image { ctx in
        //            for item in results {
        //                let TextObservation:VNTextObservation = item
        //                ctx.cgContext.setFillColor(UIColor.clear.cgColor)
        //                ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
        //                ctx.cgContext.setLineWidth(2)
        //                ctx.cgContext.addRect(item.boundingBox.applying(t))
        //                ctx.cgContext.drawPath(using: .fillStroke)
        //                addScreenShotToTextImages(sourceImage: image, boundingBox: item.boundingBox.applying(t))
        //            }
        //            for (index,image) in textImages.enumerated() {
        //                let visionImage = VisionImage(image: image)
        //                // [START detect_text]
        //                textDetector.process(visionImage, completion: { (features, error) in
        //                    guard error == nil, let features = features else {
        //                        // Error. You should also check the console for error messages.
        //                        // [START_EXCLUDE]
        //                        // [END_EXCLUDE]
        //                        return
        //                    }
        //                   print(features.text)
        ////                    let value = features.map { feature in
        ////                        print("\(feature.text) ")
        ////                        self.lineArray.add("\(feature.text) ")
        ////                        var string = "\(feature.text)"
        ////
        ////                        //                        self.findAddress(string: string, count: self.lineArray.count)
        ////
        ////                        //                        if self.addressArray.count == 1 {
        ////                        //
        ////                        //
        ////                        //                            for (index,value) in self.lineArray.enumerated() {
        ////                        //                                if index == 0 {
        ////                        //
        ////                        //                                } else if (value as! String).contains(".") {
        ////                        //
        ////                        //                                } else {
        ////                        //                                    //print("Address ===== > \(value)")
        ////                        //                                    theStringWithReplacements.append("\(value)" as! String)
        ////                        //
        ////                        //                                }
        ////                        //                            }
        ////                        //
        ////                        //
        ////                        //
        ////                        //                        }
        ////
        ////                        let wordArr : [String] = string.components(separatedBy: " ")
        ////                        for val in wordArr {
        ////                            print("Words :\(val)")
        ////                            self.isValidTime(timeString: val)
        ////                            self.isValidDate(dateString: val)
        ////
        ////                        }
        ////                        //  self.findTotal()
        ////
        ////
        ////                        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.blue ]
        ////                        let myAttrString = NSAttributedString(string: feature.text, attributes: myAttribute)
        ////
        ////                        return myAttrString //"Text: \(feature.text)"
        ////                        }.joined(separator: "")
        //
        //
        //                    //  print("Merchant Name : \(lineArray[0]) ")
        //
        //                    self.merchant.text = "\(self.lineArray[0])"
        //
        //
        //                    //                    var myMutableString = NSMutableAttributedString()
        //                    //
        //                    //                    myMutableString = NSMutableAttributedString(string: "\(self.lineArray[0])")
        //                    //
        //                    //                    //  self.findTotal()
        //                    //                    let main_string = theStringWithReplacements
        //                    //                    let string_to_color = "\(self.lineArray[0])"
        //                    //                    self.merchantName = string_to_color
        //                    //                    self.merchantAddress = main_string as String
        //                    //
        //
        //                    //                    let myMutableTitle : NSMutableAttributedString! = NSMutableAttributedString(string: string_to_color, attributes: [NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        //                    //                    var mutDj = NSMutableAttributedString(string: "\n\(main_string)", attributes: [NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: 14.0)!])
        //                    //                    myMutableTitle.append(mutDj)
        //                    //
        //                    //
        //                    //                    self.merchantDetails.merchantDetailsLbl.attributedText = myMutableTitle
        //                })
        ////                textDetector.detect(in: visionImage) { (features, error) in
        ////                    guard error == nil, let features = features, !features.isEmpty else {
        ////                        // Error. You should also check the console for error messages.
        ////                        // [START_EXCLUDE]
        ////                        // [END_EXCLUDE]
        ////                        return
        ////                    }
        ////                    let value = features.map { feature in
        ////                        print("\(feature.text) ")
        ////                        self.lineArray.add("\(feature.text) ")
        ////                        var string = "\(feature.text)"
        ////
        //////                        self.findAddress(string: string, count: self.lineArray.count)
        ////
        //////                        if self.addressArray.count == 1 {
        //////
        //////
        //////                            for (index,value) in self.lineArray.enumerated() {
        //////                                if index == 0 {
        //////
        //////                                } else if (value as! String).contains(".") {
        //////
        //////                                } else {
        //////                                    //print("Address ===== > \(value)")
        //////                                    theStringWithReplacements.append("\(value)" as! String)
        //////
        //////                                }
        //////                            }
        //////
        //////
        //////
        //////                        }
        ////
        ////                        let wordArr : [String] = string.components(separatedBy: " ")
        ////                        for val in wordArr {
        ////                            print("Words :\(val)")
        ////                            self.isValidTime(timeString: val)
        ////                            self.isValidDate(dateString: val)
        ////
        ////                        }
        ////                        //  self.findTotal()
        ////
        ////
        ////                        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.blue ]
        ////                        let myAttrString = NSAttributedString(string: feature.text, attributes: myAttribute)
        ////
        ////                        return myAttrString //"Text: \(feature.text)"
        ////                        }.joined(separator: "")
        ////
        ////
        ////                    //  print("Merchant Name : \(lineArray[0]) ")
        ////
        ////                    self.merchant.text = "\(self.lineArray[0])"
        ////
        ////
        //////                    var myMutableString = NSMutableAttributedString()
        //////
        //////                    myMutableString = NSMutableAttributedString(string: "\(self.lineArray[0])")
        //////
        //////                    //  self.findTotal()
        //////                    let main_string = theStringWithReplacements
        //////                    let string_to_color = "\(self.lineArray[0])"
        //////                    self.merchantName = string_to_color
        //////                    self.merchantAddress = main_string as String
        //////
        ////
        //////                    let myMutableTitle : NSMutableAttributedString! = NSMutableAttributedString(string: string_to_color, attributes: [NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        //////                    var mutDj = NSMutableAttributedString(string: "\n\(main_string)", attributes: [NSAttributedString.Key.font: UIFont(name: "WorkSans-Regular", size: 14.0)!])
        //////                    myMutableTitle.append(mutDj)
        //////
        //////
        //////                    self.merchantDetails.merchantDetailsLbl.attributedText = myMutableTitle
        ////
        ////
        ////                }
        //
        //
        //            }
        //
        //
        //
        //
        //            textImages = []
        //
        //
        //        }
        //
        let img = UIImage()
        
        return img
    }
    
    func isValidDate(dateString: String) {
        let dateFormatterGet = DateFormatter()
        //
        //  print(dateString)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        guard let date = dateFormatter.date(from: dateString) else {
            //  fatalError()
            return
        }
        print(date)
        dateFormatter.dateFormat = "MM/dd/yyyy" //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        print("Date=======================>   \(newDate)")
        self.date.text = newDate
        
        //      dateFormatterGet.dateStyle = DateFormatter.Style.short
        //        if dateFormatterGet.date(from: dateString) != nil {
        //            dateFormatterGet.dateFormat = "dd MMM, yyyy"
        //            let dateValue = dateFormatterGet.date(from: dateString)
        //
        //            let inputFormatter = DateFormatter()
        //            inputFormatter.dateFormat = "MM/dd/YYYY"
        //
        //            let outputFormatter = DateFormatter()
        //            outputFormatter.dateFormat = "dd MMM, yyyy"
        //
        //            let showDate = inputFormatter.date(from: dateString)
        //            if let resultString: String = outputFormatter.string(from: showDate!) {
        //                self.date.text = resultString
        //            }
        //
        //        } else {
        //            dateFormatterGet.dateStyle = DateFormatter.Style.medium
        //            if dateFormatterGet.date(from: dateString) != nil {
        //                self.date.text = dateString
        //            } else {
        //                dateFormatterGet.dateFormat = "dd MMM, yyyy"
        //                if let _ = dateFormatterGet.date(from: dateString) {
        //                    print("Date :=======>  \(dateString)")
        //                    self.date.text = dateString
        //                    //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
        //
        //                } else {
        //                    // Invalid date
        //
        //                }
        //
        //
        //            }
        //        }
    }
    
    
    func isValidTime(timeString: String) {
        let timeformatter = DateFormatter()
        
        
        
        
        
        //        print(dateString)
        
        if timeString.contains(":") {
            print("Time ============> \(timeString)")
            timeformatter.dateStyle = DateFormatter.Style.short
            if timeformatter.date(from: timeString) != nil {
                self.time.text = "\(timeString) PM"
                print("shortTime ============> \(timeString)")
            } else {
                timeformatter.dateStyle = DateFormatter.Style.medium
                if timeformatter.date(from: timeString) != nil {
                    self.time.text = "\(timeString) PM"
                    print("longTime ============> \(timeString)")
                    
                } else {
                    timeformatter.dateFormat = "HH:mm:ss"
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "HH:mm "
                    //   print(dateString)
                    
                    if formatter1.date(from: timeString) != nil {
                        print("Time 2222  :=======>  \(timeString) PM")
                        self.time.text = "\(timeString) PM"
                    }
                    
                    
                    if timeformatter.date(from: timeString) != nil {
                        print("Time:=======>  \(timeString)")
                        self.time.text = "\(timeString) PM"
                    }
                }
            }
        }
        
        print(self.lineArray)
    }
    func mixImage(top_image:UIImage, bottom_image:UIImage, top_image_point:CGPoint=CGPoint.zero, isHaveBackground:Bool = true)-> UIImage{
        let bottomImage = bottom_image//self.Camera_Image_View.image
        let newSize = bottomImage.size // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        if(isHaveBackground==true){
            bottomImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        top_image.draw(in: CGRect(origin: top_image_point, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage!
    }
    func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return image
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action:#selector(self.doneButtonAction))
        
        toolbarDone.items = [barBtnDone]
        amount.inputAccessoryView = toolbarDone
        reimbursement.delegate = self
        let type = UserDefaults.standard.value(forKey: "AddExpenseType") as! String
        
        if type == "Edit" {
            
            merchantIcon.setImage(UIImage(named: "merchant-list-color"), for: .normal)

            if !fromCategory {
                getExpenseforEdit()
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        fromCategory = false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
    }
    @IBOutlet weak var tagsView: UIView!
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    @objc func doneButtonAction() {
        amount.resignFirstResponder()
    }
    func slotPickerOpen() {
        
        let alert = UIAlertController(title: "Currencies", message: "", preferredStyle: .alert
        )
        
        
        alert.addLocalePicker(type: .currency) { info in
            alert.title = info?.currencyCode
            alert.message = "is selected"
            self.currencySymbol = (info?.currencySymbol)!
            self.currencyCode = (info?.currencyCode)!
            self.currency.setTitle(info?.currencyCode, for: .normal)
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func registerForKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func deregisterFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @IBAction func chooseCurrency(_ sender: Any) {
        
        slotPickerOpen()
        
    }
    @objc func keyboardWasShown(notification: NSNotification)
    {
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    func textViewShouldReturn(textView: UITextView!) -> Bool {
        self.view.endEditing(true);
        return true;
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        
    }
    func datePickerTapped() {
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .gray,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        
        datePicker.show("ExpenseDatePicker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: NSDate() as Date,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MM/dd/yyyy"
                                self.date.text = formatter.string(from: dt)
                                
                            }
                            
        }
        
    }
    func timePickerTapped() {
        
        let datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .gray,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        datePicker.show("ExpenseTimePicker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: nil,
                        maximumDate: NSDate() as Date,
                        datePickerMode: .time) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm:ss a"
                                self.time.text = formatter.string(from: dt)
                            }
                            
        }
        
    }
    // MARK: - Textfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
        if textField == notes {
            let beginning: UITextPosition = textField.beginningOfDocument
            textField.selectedTextRange = textField.textRange(from: beginning, to: beginning)
        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == date {
            datePickerTapped()
            textField.resignFirstResponder()
            return false
        }
        if textField == time  {
            timePickerTapped()
            textField.resignFirstResponder()
            return false
        }
        if textField == category  {
            openExpenseCategory()
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    fileprivate func textFieldEvents() {
        tagsField.onDidAddTag = { _, tagValue in
            self.tagsString.append("\(tagValue.text)")
        }
        
        tagsField.onDidRemoveTag = { _, tag in
            self.tagsString.removeAll("\(tag.text)")
            print("onDidRemoveTag")
        }
        
        tagsField.onDidChangeText = { _, text in
            print("onDidChangeText \(String(describing: text))")
        }
        
        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo \(height)")
        }
        
        tagsField.onDidSelectTagView = { _, tagView in
            print("Select \(tagView)")
        }
        
        tagsField.onDidUnselectTagView = { _, tagView in
            print("Unselect \(tagView)")
        }
    }
    
    func openExpenseCategory() {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseCategoryViewController") as? ExpenseCategoryViewController
        secondVC?.delegate = self
        self.present(secondVC!, animated: true, completion: nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder! {
            nextResponder.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
        
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
}

