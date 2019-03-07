

import UIKit



class MainViewController: UIViewController {
    var isMenuActive = false
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var topBar: UIView!
    
    @IBOutlet weak var expensBtn: UIButton!
    @IBOutlet weak var snapBtn: RoundButton!
    
    @IBOutlet weak var enterBillBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var reimbursementBtn: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    func hideMenu() {
        self.blackView.isHidden = true
        self.optionsView.isHidden = true
    }
    func showMenu() {
        
        
        self.blackView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    @IBAction func menuButtonAction(_ sender: Any) {
        
        if isMenuActive {
            self.blackView.isHidden = true
            self.stack1.isHidden = false
            self.stack2.isHidden = false
            menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
            
            isMenuActive = false
        } else {
            self.blackView.isHidden = false
            self.stack1.isHidden = true
            self.stack2.isHidden = true
            menuButton.setImage(UIImage(named: "retakeButton"), for: .normal)
            
            isMenuActive = true
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    @IBAction func merchantListOpen(_ sender: Any) {
//        var dataList = NSArray()
//        
//     
//        let searchPicker = SearchAndFindPicker.createPicker(dataArray: dataList as NSArray, typeStr: "Data")
//        //  searchPicker.show(vc: self)
//        addChild(searchPicker)
//        self.view.addSubview(searchPicker.view)
//        searchPicker.didMove(toParent: self)
//        searchPicker.doneButtonTapped =  { selectedData in
//            print(selectedData)
//        }
//    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        var imageVC : AddNewExpenseViewController = self.children[0] as! AddNewExpenseViewController
        
        imageVC.addnewExpenseNow()
        
    }
    @objc func someActionToBePerformed () {
        // this will be called when hashTag is changed
        // do something when hashTag is changed
        
//        let path = Bundle.main.path(forResource: "Retail", ofType: "plist")
//        let dataList = NSArray(contentsOfFile: path!)
        var myEnglishArray: [String] = []
        if let URL = Bundle.main.url(forResource: "Retail", withExtension: "plist") {
            if let englishFromPlist = NSArray(contentsOf: URL) as? [String] {
                myEnglishArray = englishFromPlist
            }
        }
        
        print(myEnglishArray)
        
        var dataList = [[String:AnyObject]]()

        for i in myEnglishArray {
            dataList.append(["id":NSNumber(integerLiteral: 1+1), "name":"\(i)" as AnyObject])
        }
        let searchPicker = SearchAndFindPicker.createPicker(dataArray: dataList as! [[String : AnyObject]] , typeStr: "Data")
        //  searchPicker.show(vc: self)
        addChild(searchPicker)
        self.view.addSubview(searchPicker.view)
        searchPicker.didMove(toParent: self)
        searchPicker.doneButtonTapped =  { selectedData in
            print(selectedData)
            
            if let name = selectedData["name"] as? String {
                // no error
                var imageVC : AddNewExpenseViewController = self.children[0] as! AddNewExpenseViewController
                imageVC.updatenewMerchant(merchantName: name)
            }
            
//imageVC.updatenewMerchant(merchantName: selectedData.)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        isMenuActive = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.someActionToBePerformed), name: NSNotification.Name(rawValue: "myNotification"), object: nil)

        
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        var imageVC : AddNewExpenseViewController = self.children[0] as! AddNewExpenseViewController
        
        
        
    }
    
    
    func igcMenuSelected(_ selectedMenuName: String?, at index: Int) {
        print(String(format: "selected menu name = %@ at index = %ld", selectedMenuName ?? "", index))
        
        let alertView = UIAlertView(title: "", message: String(format: "%@ at index %ld is selected", selectedMenuName ?? "", index), delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
        alertView.show()
        
        switch index {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.stack1.isHidden = false
        self.stack2.isHidden = false
        menuButton.setImage(UIImage(named: "add-bill-b"), for: .normal)
        hideMenu()
        
        isMenuActive = false
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
    
    @IBAction func snapBill(_ sender: Any) {
        UserDefaults.standard.set("Snap", forKey: "AddExpenseType")
        
        let cameraPicker = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "camera") as! UIViewController
        self.present(cameraPicker, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
}
