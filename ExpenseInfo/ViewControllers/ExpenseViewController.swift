

import UIKit
import CoreData
import VegaScrollFlowLayout
//import FastScroll
struct ExpenseListInfo : JSONSerializable {
    var id : String?
    var expenseMode : String?
    var expenseOrincome : String?
    var time : String?
    var accountType : String?
    var billImg : Data?
    var periodic : String?
    var reimbursable : Bool?
    var split : String?
    var notes : String?
    var tax : String?
    var tips : String?
    var totalAmount : String?
    var merchantName : String?
    var currencySymbol : String?
    var date : String?
    var userId : String?
    var categoryImg : Data?
    var amount : String?
    var claimed : String?
    var category : String?
    var expenseTypeId : Int16?
    var expenseHeading : String?
    var tags : [String]?
    
}

struct emailBill : JSONSerializable{
    var name: String?
    var image: Data?
}
class ExpenseViewController: UIViewController,JCActionSheetDelegate  {
    func igcMenuSelected(_ selectedMenuName: String!, at index: Int) {
        
    }
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let cellId = "ShareCell"
    var globalExpense : Double = 0.0
    @IBOutlet weak var expensBtn: UIButton!
    @IBOutlet weak var snapBtn: RoundButton!
    
    @IBOutlet weak var enterBillBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var reimbursementBtn: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
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
    
    @IBAction func snapBill(_ sender: Any) {
        UserDefaults.standard.set("Snap", forKey: "AddExpenseType")
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController") as? ScannerViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    func hideMenu() {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
        isMenuActive = false
    }
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
        
    }
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    var isMenuActive = false
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goHoem(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    // iphone se = 8
    //iphone x =
    //iphone 7 =
    
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
            return 8
        }
    }
    private let itemHeight: CGFloat = 90
    private let xInset: CGFloat = 10
    private let topInset: CGFloat = 10
    private func configureCollectionViewLayout() {
        var lineSpacing: CGFloat = self.lineSpacingValue()

        guard let layout = collectionView.collectionViewLayout as? VegaScrollFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        let itemWidth = UIScreen.main.bounds.width - 2 * xInset
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    var expenseListArray = [ExpenseListInfo]()
    func getExpenseList() {
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
                    globalExpense += myFloat
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
                collectionView.reloadData()
            } else {
                if (self.expenseListArray.count == 0) {
                    collectionView.reloadData()
                    self.collectionView.setEmptyMessage("Nothing to show :(")
                } else {
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        hideMenu()
        let nib = UINib(nibName: cellId, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset.bottom = itemHeight
        getExpenseList()
        configureCollectionViewLayout()

        
        
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
        
        
    //    collectionView.setup()
        
    }
    
    
    
//    fileprivate func configFastScroll() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        //bubble
//        collectionView.bubbleFocus = .dynamic
//        collectionView.bubbleTextSize = 14.0
//        collectionView.bubbleMarginRight = 50.0
//        collectionView.bubbleColor = UIColor(red: 38.0 / 255.0, green: 48.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
//
//        //handle
//        collectionView.handleHeight = 40.0
//        collectionView.handleWidth = 40.0
//        collectionView.handleRadius = 20.0
//        collectionView.handleMarginRight = -20
//        collectionView.handleColor = UIColor(red: 38.0 / 255.0, green: 48.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
//
//        //scrollbar
//        collectionView.scrollbarWidth = 0.0
//        collectionView.scrollbarMarginTop = 20.0
//        collectionView.scrollbarMarginBottom = 0.0
//        collectionView.scrollbarMarginRight = 10.0
//
//        //callback action to display bubble name
////        collectionView.bubbleNameForIndexPath = { indexPath in
////            let visibleSection: Section = self.data[indexPath.section]
////            return visibleSection.sectionTitle
////        }
//    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        
        
    }
    
    var currentCheckedIndex = 0;
    
    override func viewDidDisappear(_ animated: Bool) {
        print(globalExpense)
        UserDefaults.standard.set(globalExpense, forKey: "GlobalExpense")
        UserDefaults.standard.synchronize()
        
        hideMenu()
        
        isMenuActive = false
    }
    
    @IBAction func showActionSheet(_ sender: UIButton) {
        let actionSheet = JCActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Low - High","High - Low"], textColor: UIColor.blue, checkedButtonIndex:self.currentCheckedIndex);
        self.present(actionSheet, animated: true, completion: nil);
    }
    
    func actionSheet(_ actionSheet: JCActionSheet, clickedButtonAt buttonIndex: Int) {
        self.currentCheckedIndex = buttonIndex;
        if buttonIndex == 0 {
            expenseListArray =  expenseListArray.sorted(by: { $0.amount > $1.amount})
        } else if buttonIndex == 1 {
            expenseListArray =  expenseListArray.sorted(by: { $1.amount > $0.amount})
        }
        collectionView.reloadData()
    }
    
    func actionSheetCancel(_ actionSheet: JCActionSheet) {
        //do something with cancel action
    }
    
    func actionSheetDetructive(_ actionSheet: JCActionSheet) {
        //do something with detructive action
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
    
    
}

//extension ExpenseViewController : UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView : UIScrollView) {
//        collectionView.scrollViewDidScroll(scrollView)
//    }
//    
//    func scrollViewWillBeginDragging(_ scrollView : UIScrollView) {
//        collectionView.scrollViewWillBeginDragging(scrollView)
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView : UIScrollView) {
//        collectionView.scrollViewDidEndDecelerating(scrollView)
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView : UIScrollView, willDecelerate decelerate : Bool) {
//        collectionView.scrollViewDidEndDragging(scrollView, willDecelerate : decelerate)
//    }
//}
extension ExpenseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseDetailsViewController") as? ExpenseDetailsViewController
        
        
        let share = expenseListArray[indexPath.row]
        vc2?.expenseListArray = share
        self.present(vc2!, animated: true)
        
    }
}
extension ExpenseViewController: UICollectionViewDataSource {
    
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShareCell
        let share = expenseListArray[indexPath.row]
        //        cell.configureWith(share)
        cell.clearCell()
        cell.merchantDetails.text = share.merchantName
        var modeImg = UIImage()
        if share.expenseMode == "Manual" {
            modeImg = UIImage(named: "manual-bill")!
        }else if share.expenseMode == "Snap" {
            modeImg = UIImage(named: "snap-bills")!

        } else if share.expenseMode == "Upload" {
            modeImg = UIImage(named: "upload-bill")!

        }
        cell.modeImg.image = modeImg
        
        cell.categoryIcon.image = UIImage(data:share.categoryImg!)
        cell.amount.text = "\(share.currencySymbol!)\(share.amount!)"
        if share.claimed! == "CL" {
            cell.claimedLbl.isHidden = false
        } else {
            cell.claimedLbl.isHidden = true
        }
        cell.tagsView = nil
        print("indexPath \(indexPath.row) value : \(String(describing: share.tags))")
        if share.tags != nil {
            cell.configureTags(value: (share.tags)!)
            cell.tagsView?.isHidden = false
        } else {
            cell.tagsView?.isHidden = true
            
        }
        
        
        cell.date.text =
        "\(share.date!)   \(share.time!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.expenseListArray.count == 0) {
            self.collectionView.setEmptyMessage("Nothing to show :(")
        } else {
            self.collectionView.restore()
        }
        
        
        return expenseListArray.count
    }
}
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
