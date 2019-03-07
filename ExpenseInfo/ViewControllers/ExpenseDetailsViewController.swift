

import UIKit
import WSTagsField
import CoreData
import MessageUI
extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
class ExpenseDetailsViewController: UIViewController,MFMailComposeViewControllerDelegate {
    var expenseListArray = ExpenseListInfo()
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var detailView: RoundView!
    @IBOutlet weak var mEmptyTag: UILabel!
    @IBOutlet weak var roundImages: RoundImage!
    @IBOutlet weak var mAmount: UILabel!
    @IBOutlet weak var shortView: UIView!
    @IBOutlet weak var mmerchantName: UILabel!
    @IBOutlet weak var mCategory: UILabel!
    @IBOutlet weak var mDescription: UITextView!
    @IBOutlet weak var mCategoryImg: UIImageView!
    @IBOutlet weak var claimBtn: UIButton!
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var screenShot: UIImageView!
    func sendEmail() {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([])
        mailVC.setSubject("Subject for email")
        mailVC.setMessageBody("Email message string", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result.rawValue == 2 {
            updateSubmitted()
        }
        controller.dismiss(animated: true)
    }
    
    @IBOutlet weak var claimedBttn: UIButton!
    @IBAction func doneClaim(_ sender: Any) {
        
        updateClaimed()
        
    }
    @IBAction func claimedAction(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            shortView.isHidden = false
            let renderer = UIGraphicsImageRenderer(size: shortView.bounds.size)
            let image = renderer.image { ctx in
                shortView.drawHierarchy(in: shortView.bounds, afterScreenUpdates: true)
            }
            
            screenShot.image = image
            screenShot.contentMode = .scaleAspectFit
            detailView.isHidden = false
            shortView.isHidden = true
            screenShot.isHidden = true
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self;
            mail.setSubject("Claim Expense")
            mail.setMessageBody("", isHTML: false)
            var imageData: Data? = screenShot.image!.pngData()
            
            mail.addAttachmentData(imageData!, mimeType: "image/png", fileName: "imageName.png")
            if expenseListArray.billImg != nil {
                mail.addAttachmentData(expenseListArray.billImg!, mimeType: "image/png", fileName: "attachment.png")
            }
            self.present(mail, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        
        
    }
    
    func updateSubmitted() {
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "id == %@", expenseListArray.id!)
        
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count == 1 {
                for expenseContent in fetchedtype {
                    expenseContent.id = expenseListArray.id!
                    expenseContent.reimbursable = true
                    expenseContent.isClaimed = "SB"
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ReimbursementViewController") as! ReimbursementViewController
                    
                    self.present(imageVC, animated: true, completion: nil)
                    
                }
                
            }
        } catch {
            
            
        }
    }
    
    func updateClaimed() {
        
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "id == %@", expenseListArray.id!)
        
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count == 1 {
                for expenseContent in fetchedtype {
                    expenseContent.id = expenseListArray.id!
                    expenseContent.reimbursable = false
                    expenseContent.isClaimed = "CL"
                    
                    do {
                        try managedObjectContext.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                    let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ReimbursementViewController") as! ReimbursementViewController
                    
                    self.present(imageVC, animated: true, completion: nil)
                    
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
    @IBAction func deleteExpense(_ sender: Any) {
        print(expenseListArray.id as Any)
        deleteProfile(withID: expenseListArray.id!)
        
        
    }
    @IBAction func editExpense(_ sender: Any) {
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        UserDefaults.standard.set("Edit", forKey: "AddExpenseType")
        UserDefaults.standard.set(expenseListArray.id, forKey: "expenseListArray")
        self.present(imageVC, animated: true, completion: nil)
        
    }
    fileprivate let tagsField = WSTagsField()
    func deleteProfile(withID: String) {
        
        let alert = UIAlertController(title: "Alert", message: "Would you like to Delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            switch action.style{
            case .default:
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
                fetchRequest.predicate =  NSPredicate(format: "id == %@  ", withID)
                
                do {
                    let test = try context.fetch(fetchRequest)
                    let objectToDelete = test[0] as! NSManagedObject
                    context.delete(objectToDelete)
                    do {
                        try context.save()
                        self.dismiss(animated: true, completion: nil)
                    }
                    catch {
                        print(error)
                    }
                }
                catch {
                    print(error)
                }
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                
                print("destructive")
                
                
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    @IBOutlet weak var mdate: UILabel!
    @IBOutlet weak var MerchantName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var dateandTime: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var emptyTag: UILabel!
    @IBOutlet weak var mTagsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        roundImages.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        roundImages.layer.shadowOffset = CGSize(width: 0, height: 3)
        roundImages.layer.shadowOpacity = 1.0
        roundImages.layer.shadowRadius = 10.0
        roundImages.layer.masksToBounds = false
        
        detailView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        detailView.layer.shadowOffset = CGSize(width: 0, height: 3)
        detailView.layer.shadowOpacity = 1.0
        detailView.layer.shadowRadius = 10.0
        detailView.layer.masksToBounds = false
        
        
        claimBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        claimBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        claimBtn.layer.shadowOpacity = 1.0
        claimBtn.layer.shadowRadius = 10.0
        claimBtn.layer.masksToBounds = false
        
        catImage.image = UIImage(data: expenseListArray.categoryImg!)
        mCategoryImg.image = UIImage(data: expenseListArray.categoryImg!)
        MerchantName.text = expenseListArray.merchantName
        mmerchantName.text = expenseListArray.merchantName
        
        dateandTime.text = "\(String(describing: expenseListArray.date!)) - \(String(describing: expenseListArray.time!))"
        
        mdate.text = "\(String(describing: expenseListArray.date!)) - \(String(describing: expenseListArray.time!))"
        
        
        
        amount.text = "\(expenseListArray.currencySymbol!)\(expenseListArray.amount!)"
        mAmount.text = "\(expenseListArray.currencySymbol!)\(expenseListArray.amount!)"
        
        notes.text = expenseListArray.notes
        if notes.text == "" {
            notes.text = "---"
        }
        
        mDescription.text = expenseListArray.notes
        if mDescription.text == "" {
            mDescription.text = "---"
        }
        
        
        category.text = expenseListArray.category
        mCategory.text = expenseListArray.category
        
        tagsField.readOnly = true
        
        if expenseListArray.claimed == "NC" {
            claimBtn.isHidden = false
            claimedBttn.isHidden = true
        } else if expenseListArray.claimed == "SB" {
            claimBtn.isHidden = true
            claimedBttn.isHidden = false
        } else {
            claimBtn.isHidden = true
            claimedBttn.isHidden = true
            
        }
        
        tagsField.layoutMargins = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        
        tagsField.spaceBetweenTags = 10
        tagsField.backgroundColor = .clear
        tagsField.font = UIFont(name: "WorkSans-Regular", size: 14.0)
        tagsField.textColor = UIColor(hexString: "2F3C4B")
        tagsField.fieldTextColor = UIColor(hexString: "2F3C4B")
        tagsField.selectedColor = UIColor(hexString: "FCECD4")
        tagsField.selectedTextColor = UIColor(hexString: "2F3C4B")
        tagsField.tintColor = UIColor(hexString: "FCECD4")
        tagsField.acceptTagOption = .space
        tagsField.frame = (self.tagsView?.bounds)!
        tagsField.frame(forAlignmentRect: CGRect(x: 10, y: 10, width: Int(tagsField.width), height: Int(tagsField.height)))
        tagsView?.addSubview(tagsField)
        mTagsView?.addSubview(tagsField)
        
        if expenseListArray.tags?.count > 0 {
            let valueString = expenseListArray.tags
            let tagString : NSMutableString = ""
            for val in valueString! {
                tagString.append("#\(val) ")
            }
            emptyTag.text = tagString as String
            mEmptyTag.text = tagString as String
            
        } else {
            self.emptyTag.isHidden = false
            self.mEmptyTag.isHidden = false
            
        }
    }
    
    
    
    
}
