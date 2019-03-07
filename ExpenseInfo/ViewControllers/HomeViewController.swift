

import UIKit
import SafariServices
import Photos
import CoreTelephony
import CoreData
import MobileCoreServices
import WeScan

class HomeViewController: UIViewController {
    
    @IBOutlet weak var reimbursementBtn: RoundButton!
    @IBOutlet weak var expenseBtn: RoundButton!
    @IBOutlet weak var reportBtn: RoundButton!
    @IBOutlet weak var snapBillBtn: RoundButton!
    @IBOutlet weak var uploadBillBtn: RoundButton!
    @IBOutlet weak var enterBillBtn: RoundButton!
    @IBOutlet weak var expenseYearandMonth: UILabel!
    @IBOutlet weak var reimbursementYearandMonth: UILabel!
    @IBOutlet weak var unClaimedLbl: UILabel!
    @IBOutlet weak var claimedLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reimbursementBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        reimbursementBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        reimbursementBtn.layer.shadowOpacity = 1.0
        reimbursementBtn.layer.shadowRadius = 10.0
        reimbursementBtn.layer.masksToBounds = false
        
        expenseBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        expenseBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        expenseBtn.layer.shadowOpacity = 1.0
        expenseBtn.layer.shadowRadius = 10.0
        expenseBtn.layer.masksToBounds = false
        
        
        reportBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        reportBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        reportBtn.layer.shadowOpacity = 1.0
        reportBtn.layer.shadowRadius = 10.0
        reportBtn.layer.masksToBounds = false
        
        
        snapBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        snapBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        snapBillBtn.layer.shadowOpacity = 1.0
        snapBillBtn.layer.shadowRadius = 10.0
        snapBillBtn.layer.masksToBounds = false
        
        uploadBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        uploadBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        uploadBillBtn.layer.shadowOpacity = 1.0
        uploadBillBtn.layer.shadowRadius = 10.0
        uploadBillBtn.layer.masksToBounds = false
        
        enterBillBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        enterBillBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        enterBillBtn.layer.shadowOpacity = 1.0
        enterBillBtn.layer.shadowRadius = 10.0
        enterBillBtn.layer.masksToBounds = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserDefaults.standard.value(forKey: "CurrencyCode") != nil {
            if let currencySymbol = UserDefaults.standard.value(forKey: "CurrencySymbol") {
                globalCurrencySymbol = "\(currencySymbol)"
            } else {
                globalCurrencySymbol = ""
            }
        }
        let defaults = UserDefaults.standard
        
        let month : String = defaults.value(forKey: "Month") as! String
        self.expenseYearandMonth.text = "\(month.uppercased()) - \(defaults.value(forKey: "Year")!)"
        self.reimbursementYearandMonth.text = "\(month.uppercased()) - \(defaults.value(forKey: "Year")!)"
        
          updateBlocks()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func goToReports(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportsViewController") as? ReportsViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    @IBAction func goToReimbursement(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ReimbursementViewController") as? ReimbursementViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    @IBAction func goToExpense(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseViewController") as? ExpenseViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    func getClaimedandUnclaimedList() {
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "isClaimed == %@ ","CL")
        
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                for exp in fetchedtype {
                    
                    if let myString : String = exp.amount! {
                        let myFloat = (myString as NSString).doubleValue
                        
                        claimedValueBlock += myFloat
                    }
                }
            }
            
            let value = String(format:"%.2f", claimedValueBlock)
            
            claimedLbl.text = "\(globalCurrencySymbol)\(value)"
        } catch {
            
            
        }
        
        
        let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch1.predicate = NSPredicate(format: "isClaimed == %@ ","NC")
        
        do {
            let fetchedtype1 = try managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {
                for exp in fetchedtype1 {
                    
                    if let myString : String = exp.amount! {
                        let myFloat = (myString as NSString).doubleValue
                        
                        unclaimedValueBlock += myFloat
                    }
                }
            }
            
            let value = String(format:"%.2f", unclaimedValueBlock)
            
            unClaimedLbl.text = "\(globalCurrencySymbol)\(value)"
        } catch {
            
            
        }
        
    }
    @IBOutlet weak var expenseLBL: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        expenseValueBlock  = 0.0
        claimedValueBlock = 0.0
        unclaimedValueBlock = 0.0
        updateBlocks()
        getClaimedandUnclaimedList()
        
    }
    var globalCurrencySymbol : String = ""
    var expenseValueBlock : Double = 0.0
    var claimedValueBlock : Double = 0.0
    var unclaimedValueBlock : Double = 0.0
    func updateBlocks() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                for exp in fetchedtype {
                    if let myString : String = exp.amount! {
                        //                    let myString = exp.amount
                        let myFloat = (myString as NSString).doubleValue
                        
                        expenseValueBlock += myFloat
                    }
                }
                var value = String(format:"%.2f", expenseValueBlock)
                expenseLBL.text = "\(globalCurrencySymbol)\(value)"
                
            } else {
                var value = String(format:"%.2f", expenseValueBlock)

                expenseLBL.text = "\(globalCurrencySymbol)\(value)"

            }
        } catch {
            print(error)
        }
    }
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = false
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    fileprivate var alertStyle: UIAlertController.Style = .actionSheet
    
    @IBAction func uploadBill(_ sender: Any) {
        UserDefaults.standard.set("Upload", forKey: "AddExpenseType")
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController
        self.present(firstVC!, animated: true, completion: nil)
        
        
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
                // It will display the metadata of image after converting NSData into NSDictionary
                return metadata
            }
        }
        print("Can't read metadata")
        return nil
    }
    @IBAction func snapBill(_ sender: Any) {
        
        
        UserDefaults.standard.set("Snap", forKey: "AddExpenseType")
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    @IBAction func enterBillAction(_ sender: Any) {
        UserDefaults.standard.set("Manual", forKey: "AddExpenseType")
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
        
    }
    
}
