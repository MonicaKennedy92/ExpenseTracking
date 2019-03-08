

import UIKit
import CoreData
import MessageUI
import Zip
class ReportsViewController: UIViewController,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var menuButton: RoundButton!
    @IBOutlet weak var expensBtn: UIButton!
    @IBOutlet weak var snapBtn: RoundButton!
    
    @IBOutlet weak var enterBillBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBAction func reportGenerate(_ sender: Any) {
        
        generateReportforExpense()
    }
    @IBOutlet weak var reportBtn: UIButton!
   
    @IBOutlet weak var generatereportBtn: UIButton!
    @IBOutlet weak var reimbursementBtn: UIButton!
    @IBAction func reportsSegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.expenseContainer.isHidden = false
            self.reimburseContainer.isHidden = true
            generatereportBtn.isHidden = false
        } else if sender.selectedSegmentIndex == 1 {
            self.expenseContainer.isHidden = true
            self.reimburseContainer.isHidden = false
             generatereportBtn.isHidden = false
        }
    }
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    var isMenuActive = false
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    
    @IBAction func goHoem(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result.rawValue == 2 {
          //  updateSubmitted()
        }
        controller.dismiss(animated: true)
    }
    
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    @IBOutlet weak var reimburseContainer: UIView!
    @IBOutlet weak var expenseContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        generatereportBtn.isHidden = false
        uploadBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        uploadBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        uploadBtn.layer.shadowOpacity = 1.0
        uploadBtn.layer.shadowRadius = 10.0
        uploadBtn.layer.masksToBounds = false
        
        snapBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        snapBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        snapBtn.layer.shadowOpacity = 1.0
        snapBtn.layer.shadowRadius = 10.0
        snapBtn.layer.masksToBounds = false
        
        
        enterBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        enterBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        enterBillBtn.layer.shadowOpacity = 1.0
        enterBillBtn.layer.shadowRadius = 10.0
        enterBillBtn.layer.masksToBounds = false
        
        
        
        reimbursementBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        reimbursementBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        reimbursementBtn.layer.shadowOpacity = 1.0
        reimbursementBtn.layer.shadowRadius = 10.0
        reimbursementBtn.layer.masksToBounds = false
        
        reportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        reportBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        reportBtn.layer.shadowOpacity = 1.0
        reportBtn.layer.shadowRadius = 10.0
        reportBtn.layer.masksToBounds = false
        
        menuButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        menuButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        menuButton.layer.shadowOpacity = 1.0
        menuButton.layer.shadowRadius = 10.0
        menuButton.layer.masksToBounds = false
        
        
        
        expensBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        expensBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        expensBtn.layer.shadowOpacity = 1.0
        expensBtn.layer.shadowRadius = 10.0
        expensBtn.layer.masksToBounds = false
        
        settingsBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        settingsBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        settingsBtn.layer.shadowOpacity = 1.0
        settingsBtn.layer.shadowRadius = 10.0
        settingsBtn.layer.masksToBounds = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        hideMenu()
        
        isMenuActive = false
    }
    @IBAction func menuButtonAction(_ sender: Any) {
        
        if isMenuActive {
            self.stack1.isHidden = false
            self.stack2.isHidden = false
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            hideMenu()
            
            isMenuActive = false
        } else {
            self.stack1.isHidden = true
            self.stack2.isHidden = true
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
            self.showMenu()
            isMenuActive = true
        }
        
    }
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBAction func manualEntry(_ sender: Any) {
        UserDefaults.standard.set("Manual", forKey: "AddExpenseType")
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    var expenseListArray = [ExpenseListInfo]()

    @IBAction func uploadBill(_ sender: Any) {
        
        UserDefaults.standard.set("Upload", forKey: "AddExpenseType")
        
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func snapBill(_ sender: Any) {
        UserDefaults.standard.set("Snap", forKey: "AddExpenseType")
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    
    
    func generateReportforExpense() {
        expenseListArray = [ExpenseListInfo]()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                for exp in fetchedtype {
                    
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    addAcc.expenseMode = exp.expenseMode

                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.expenseorIncome
                    addAcc.category = exp.expenseCategory
                    addAcc.claimed = exp.isClaimed
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String] as Any)
                    addAcc.notes = exp.notes
                    
                    if exp.billImage != nil {
                        addAcc.billImg =  exp.billImage
                    }
                    
                    expenseListArray.append(addAcc)
                }
                
                
                if expenseListArray.count > 0 {
                    let fileName = "Expense.csv"
                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                    var csvText = "Date,Time,Category,Merchant,Amount,Tags,Description,Expense mode,Image\n"
                    
                    //                                    var logo = UIImage(named: "335863679")
                    //                                    let imageData:Data =  logo!.pngData()!
                    //                                    let base64String = imageData.base64EncodedString()
                    //                                    print(base64String)
                    //
                    var billImages: NSMutableArray = [] //
                    var zipBill = [emailBill]()

                    
                    for task in expenseListArray {
                        let dateFormatter = DateFormatter()
                        //                        dateFormatter.dateStyle = .short
                        print(task.date)
                        //                        let convertedDate = dateFormatter.date(from: task.date!)
                        //                        let convertedString = dateFormatter.string(from: convertedDate!)
                        //                        print(convertedString)
                        var tags = task.tags
                        var tagString : NSMutableString = ""
                        
                        if task.tags?.count > 0 {
                            let valueString = task.tags
                            for val in valueString! {
                                tagString.append("#\(val) ")
                            }
                            //                                            emptyTag.text = tagString as String
                        } else {
                            tagString = "---"
                        }
                        var notes : String = "---"
                        if task.notes != "" {
                            notes = task.notes!
                        }
                        
                        var billImg : String = ""
                        print(task.billImg);
                        if (task.billImg != nil) {
                            print("bill Available")
                            var bills = emailBill()
                            bills.name = "\(task.id!).png"
                            bills.image = task.billImg!
                            billImg = "\(task.id!).png"
                            zipBill.append(bills)
                            billImages.add(task.billImg!)
                        }
                        
                        let newLine = "\(task.date!),\(task.time!),\(task.category!),\(task.merchantName!),\(task.currencySymbol!)\(task.amount!),\(tagString),\(notes),\(task.expenseMode!),\(billImg) \n"
                        csvText.append(contentsOf: newLine)
                    }
                    
                    do {
                        print(path)
                        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                        
//                        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
//                        vc.excludedActivityTypes = [
//                            UIActivity.ActivityType.assignToContact,
//                            UIActivity.ActivityType.saveToCameraRoll,
//                            UIActivity.ActivityType.postToFlickr,
//                            UIActivity.ActivityType.postToVimeo,
//                            UIActivity.ActivityType.postToTencentWeibo,
//                            UIActivity.ActivityType.postToTwitter,
//                            UIActivity.ActivityType.postToFacebook,
//                            UIActivity.ActivityType.openInIBooks
//                        ]
//                        present(vc, animated: true, completion: nil)
                        
//                        if billImages.count > 0 {
//                            let fileManager = FileManager.default
//                            if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//                                let filePath =  tDocumentDirectory.appendingPathComponent("Expense_Receipt")
//                                if !fileManager.fileExists(atPath: filePath.path) {
//                                    do {
//                                        try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
//
//
//                                    } catch {
//                                        NSLog("Couldn't create document directory")
//                                    }
//                                }
//
//                                for value in zipBill {
//                                    let fileURL = filePath.appendingPathComponent(value.name!)
//                                    print(fileURL)
//
//                                    var image = UIImage(data: value.image!)
//                                    if let data = image?.jpegData(compressionQuality:1.0) ,//UIImageJPEGRepresentation(image!, 1.0),
//                                        !FileManager.default.fileExists(atPath: fileURL.path) {
//                                        do {
//                                            // writes the image data to disk
//                                            try data.write(to: fileURL)
//                                            print("file saved")
//                                        } catch {
//                                            print("error saving file:", error)
//                                        }
//                                    }
//                                }
//
//
//                                NSLog("Document directory is \(filePath)")
//                            }
//                        }
                        
                                                                if MFMailComposeViewController.canSendMail() {
                                                                    let emailController = MFMailComposeViewController()
                                                                    emailController.mailComposeDelegate = self
                                                                    emailController.setToRecipients([])
                                                                    emailController.setSubject("Expense data export")
                                                                    emailController.setMessageBody("Hi,\n\nThe .csv data export is attached\n\n\nSent from the Expense app", isHTML: true)
                                                                    emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "csv", fileName: "Expense.csv")
                                                                    

                                                                    
                                                                    for value in billImages {
                                                                        emailController.addAttachmentData(value as! Data, mimeType: "image/png", fileName: "Expense.png")
                                                                    }
                                                                  
//                                                                    do {
//                                                                        let filePath = Bundle.main.url(forResource: "file", withExtension: "zip")!
//                                                                        let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
//                                                                        let zipFilePath = try Zip.quickZipFiles([filePath], fileName: "archive") // Zip
//
//                                                                        emailController.addAttachmentData(NSData(contentsOf: zipFilePath)! as Data, mimeType: "application/zip", fileName: "ExpenseImages.zip")
//                                                                    }
//                                                                    catch {
//                                                                        print("Something went wrong")
//                                                                    }

                                                                    present(emailController, animated: true, completion: nil)
                                                                } else {
                                                                    showSendMailErrorAlert()
                        }
                        
//                        var picker = MFMailComposeViewController()
//                        picker.mailComposeDelegate = self
//                        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//
//                        var documentsDirectory = paths[0]
//
//                        var WritableDBPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("Expense.zip").absoluteString
//
//                        var data = NSData(contentsOfFile: WritableDBPath) as Data?
//
//                        if let data = data {
//                            picker.addAttachmentData(data, mimeType: "application/zip", fileName: "/abc.zip")
//                        }
//                        picker.setSubject("Database")
//
//                        picker.setMessageBody("Database testing", isHTML: false)
//
//                        present(picker, animated: true)
                        
                        
                    } catch {
                        print("Failed to create file")
                        print("\(error)")
                    }
                }

            } else {
                if (self.expenseListArray.count == 0) {
                } else {
                }
            }
        } catch {
            
            
        }
        
        
    }
    
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Email Failed", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
