

import UIKit
import CoreData
import MessageUI
class ReimbursementViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,MFMailComposeViewControllerDelegate {
    private let itemHeight: CGFloat = 90
//    private let lineSpacing: CGFloat = 8
    
    func lineSpacingValue() -> CGFloat {
        switch UIDevice.current.model {
        case "iPhone 4":
            return 8
        case "iPhone 5":
            return 8
        case "iPhone 6,7":
            return 15
        case "iPhone Plus":
            return 18
        default:
            return 7
        }
    }
    private let xInset: CGFloat = 10
    private let topInset: CGFloat = 10
    @IBOutlet weak var menuButton: RoundButton!
    @IBOutlet weak var expensBtn: UIButton!
    @IBOutlet weak var snapBtn: RoundButton!
    
    @IBOutlet weak var enterBillBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var reimbursementBtn: UIButton!
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.collectionView.isHidden = false
            collectionView.reloadData()
            self.unClaimedCollectionView.isHidden = true
            self.submittedCollectionView.isHidden = true
            
        } else if sender.selectedSegmentIndex == 1 {
            self.collectionView.isHidden = true
            self.unClaimedCollectionView.isHidden = true
            self.submittedCollectionView.isHidden = false
            submittedCollectionView.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            self.collectionView.isHidden = true
            self.unClaimedCollectionView.isHidden = false
            self.submittedCollectionView.isHidden = true
            
            unClaimedCollectionView.reloadData()
        }
    }
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    var isMenuActive = false
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var shadowView: UIView!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseDetailsViewController") as? ExpenseDetailsViewController
        if collectionView == unClaimedCollectionView {
            
            let share = unclaimedListArray[indexPath.row]
            vc2?.expenseListArray = share
            self.present(vc2!, animated: true)
        } else if collectionView == submittedCollectionView {
            
            let share = submittedListArray[indexPath.row]
            vc2?.expenseListArray = share
            self.present(vc2!, animated: true)
        }
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
    @IBAction func manualEntry(_ sender: Any) {
        UserDefaults.standard.set("Manual", forKey: "AddExpenseType")
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadBill(_ sender: Any) {
        
        UserDefaults.standard.set("Upload", forKey: "AddExpenseType")
        
        
        
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController
        self.present(firstVC!, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var submittedCollectionView: UICollectionView!
    @IBAction func snapBill(_ sender: Any) {
        UserDefaults.standard.set("Snap", forKey: "AddExpenseType")
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    private func configureCollectionViewLayout() {
         var lineSpacing: CGFloat = self.lineSpacingValue()

        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
        unClaimedCollectionView.collectionViewLayout.invalidateLayout()
    }
    private func configureCollectionViewLayout1() {
        var lineSpacing: CGFloat = self.lineSpacingValue()

        guard let layout = unClaimedCollectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        unClaimedCollectionView.collectionViewLayout.invalidateLayout()
    }
    private func configureCollectionViewLayout2() {
        var lineSpacing: CGFloat = self.lineSpacingValue()

        guard let layout = submittedCollectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        submittedCollectionView.collectionViewLayout.invalidateLayout()
    }
    @IBOutlet weak var unClaimedCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        getExpenseList()
        
        collectionView.reloadData()
        submittedCollectionView.reloadData()
        unClaimedCollectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      
        
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
        
        let nib = UINib(nibName: cellId1, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: cellId1)
        collectionView.contentInset.bottom = itemHeight
        let nib1 = UINib(nibName: cellId2, bundle: nil)
        let nib2 = UINib(nibName: cellId3, bundle: nil)
        submittedCollectionView.register( nib2, forCellWithReuseIdentifier: cellId3)
        
        unClaimedCollectionView.register( nib1, forCellWithReuseIdentifier: cellId2)
        unClaimedCollectionView.contentInset.bottom = itemHeight
        configureCollectionViewLayout()
        configureCollectionViewLayout1()
        configureCollectionViewLayout2()
        
        collectionView.reloadData()
        submittedCollectionView.reloadData()
        unClaimedCollectionView.reloadData()
        self.collectionView.isHidden = false
        self.submittedCollectionView.isHidden = true
        self.unClaimedCollectionView.isHidden = true
    }
    var unclaimedListArray = [ExpenseListInfo]()
    var claimedListArray = [ExpenseListInfo]()
    var submittedListArray = [ExpenseListInfo]()
    
    func getExpenseList() {
        unclaimedListArray = [ExpenseListInfo]()
        claimedListArray = [ExpenseListInfo]()
        submittedListArray = [ExpenseListInfo]()
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch.predicate = NSPredicate(format: "isClaimed == %@ ","CL")
        
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            
            if fetchedtype.count > 0 {
                for exp in fetchedtype {
                    
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    let myString = exp.amount
                    let myFloat = (myString as! NSString).doubleValue
                    addAcc.expenseMode = exp.expenseMode

                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.expenseorIncome
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String])
                    addAcc.claimed = exp.isClaimed
                    addAcc.notes = exp.notes
                    if exp.billImage != nil {
                        addAcc.billImg =  exp.billImage
                    }
                    claimedListArray.append(addAcc)
                }
                

                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
            } else {
                if (self.claimedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    self.collectionView.setEmptyMessage("Nothing to show :(")
                } else {
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
        
        let typefetch2 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch2.predicate = NSPredicate(format: "isClaimed == %@ ","SB")
        
        do {
            let fetchedtype1 = try managedObjectContext.fetch(typefetch2) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {
                for exp in fetchedtype1 {
                    
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    let myString = exp.amount
                    let myFloat = (myString as! NSString).doubleValue
                    addAcc.expenseMode = exp.expenseMode

                    addAcc.date = exp.dateString
                    addAcc.claimed = exp.isClaimed
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.expenseorIncome
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String])
                    addAcc.notes = exp.notes
                    
                    if exp.billImage != nil {
                        addAcc.billImg =  exp.billImage
                    }
                    submittedListArray.append(addAcc)
                }
                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
                submittedCollectionView.reloadData()
            } else {
                if (self.submittedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    submittedCollectionView.reloadData()
                    self.submittedCollectionView.setEmptyMessage("Nothing to show :(")
                } else {
                    self.submittedCollectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
        
        let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        typefetch1.predicate = NSPredicate(format: "isClaimed == %@ ","NC")
        
        do {
            let fetchedtype1 = try managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
            
            if fetchedtype1.count > 0 {
                for exp in fetchedtype1 {
                    
                    var addAcc = ExpenseListInfo()
                    addAcc.merchantName = exp.merchantName
                    addAcc.amount = exp.amount
                    let myString = exp.amount
                    let myFloat = (myString as! NSString).doubleValue
                    addAcc.expenseMode = exp.expenseMode

                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.expenseorIncome
                    addAcc.claimed = exp.isClaimed
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String])
                    addAcc.notes = exp.notes
                    
                    if exp.billImage != nil {
                        addAcc.billImg =  exp.billImage
                    }
                    unclaimedListArray.append(addAcc)
                }
                
//                if unclaimedListArray.count > 0 {
//                    let fileName = "Expense.csv"
//                    let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
//                    var csvText = "Date,Time,Category,Merchant,Amount,Tags,Description\n"
//
//
//                    for task in unclaimedListArray {
//                        let dateFormatter = DateFormatter()
////                        dateFormatter.dateStyle = .short
//                        print(task.date)
////                        let convertedDate = dateFormatter.date(from: task.date!)
////                        let convertedString = dateFormatter.string(from: convertedDate!)
////                        print(convertedString)
//                        var tags = task.tags
//                        if task.tags?.count > 0 {
//
//                        } else {
//
//                        }
//                        let newLine = "\(task.date!),\(task.time!),\(task.category!),\(task.merchantName!),\(task.amount!),\(task.tags!),\(task.notes!)\n"
//                        csvText.append(contentsOf: newLine)
//                    }
//
//                    do {
//                        print(path)
//                        try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
//
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
//
//
////                        if MFMailComposeViewController.canSendMail() {
////                            let emailController = MFMailComposeViewController()
////                            emailController.mailComposeDelegate = self
////                            emailController.setToRecipients([])
////                            emailController.setSubject("Expense data export")
////                            emailController.setMessageBody("Hi,\n\nThe .csv data export is attached\n\n\nSent from the Expense app", isHTML: false)
////
////                            emailController.addAttachmentData(NSData(contentsOf: path!)! as Data, mimeType: "text/csv", fileName: "Expense.csv")
////
////                            present(emailController, animated: true, completion: nil)
////                        }
//                    } catch {
//                        print("Failed to create file")
//                        print("\(error)")
//                    }
//                }
                collectionView.reloadData()
                unClaimedCollectionView.reloadData()
            } else {
                if (self.unclaimedListArray.count == 0) {
                    collectionView.reloadData()
                    unClaimedCollectionView.reloadData()
                    self.unClaimedCollectionView.setEmptyMessage("Nothing to show :(")
                } else {
                    self.unClaimedCollectionView.restore()
                }
            }
        } catch {
            
            
        }
        
    }
    fileprivate let cellId1 = "ShareCell"
    fileprivate let cellId2 = "ShareCell"
    fileprivate let cellId3 = "ShareCell"
    
    @IBAction func goHoem(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! ShareCell
            
            let share = claimedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode == "Manual" {
                modeImg = UIImage(named: "manual-bill")!
            }else if share.expenseMode == "Snap" {
                modeImg = UIImage(named: "snap-bills")!
                
            } else if share.expenseMode == "Upload" {
                modeImg = UIImage(named: "upload-bill")!
                
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            print("indexPath \(indexPath.row) value : \(share.tags)")
            if share.tags != nil {
                cell.configureTags(value: (share.tags)!)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
                
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        } else if collectionView == self.unClaimedCollectionView   {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ShareCell
            
            let share = unclaimedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode == "Manual" {
                modeImg = UIImage(named: "manual-bill")!
            }else if share.expenseMode == "Snap" {
                modeImg = UIImage(named: "snap-bills")!
                
            } else if share.expenseMode == "Upload" {
                modeImg = UIImage(named: "upload-bill")!
                
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            print("indexPath \(indexPath.row) value : \(share.tags)")
            if share.tags != nil {
                cell.configureTags(value: (share.tags)!)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
                
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! ShareCell
            
            let share = submittedListArray[indexPath.row]
            cell.clearCell()
            var modeImg = UIImage()
            if share.expenseMode == "Manual" {
                modeImg = UIImage(named: "manual-bill")!
            }else if share.expenseMode == "Snap" {
                modeImg = UIImage(named: "snap-bills")!
                
            } else if share.expenseMode == "Upload" {
                modeImg = UIImage(named: "upload-bill")!
                
            }
            cell.modeImg.image = modeImg
            cell.merchantDetails.text = share.merchantName
            cell.categoryIcon.image = UIImage(data:share.categoryImg!)
            cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
            
            cell.tagsView = nil
            print("indexPath \(indexPath.row) value : \(share.tags)")
            if share.tags != nil {
                cell.configureTags(value: (share.tags)!)
                cell.tagsView?.isHidden = false
            } else {
                cell.tagsView?.isHidden = true
            }
            
            
            cell.date.text =
            "\(share.date!) - \(share.time!)"
            
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView {
            if (self.claimedListArray.count == 0) {
                self.collectionView.setEmptyMessage("Nothing to show :(")
            } else {
                self.collectionView.restore()
            }
            
            
            return claimedListArray.count
        } else if collectionView == self.unClaimedCollectionView {
            if (self.unclaimedListArray.count == 0) {
                self.unClaimedCollectionView.setEmptyMessage("Nothing to show :(")
            } else {
                self.unClaimedCollectionView.restore()
            }
            
            
            return unclaimedListArray.count
        } else if collectionView == self.submittedCollectionView {
            if (self.submittedListArray.count == 0) {
                self.submittedCollectionView.setEmptyMessage("Nothing to show :(")
            } else {
                self.submittedCollectionView.restore()
            }
            
            
            return submittedListArray.count
        }
        return 0
    }
    
    
    
}
