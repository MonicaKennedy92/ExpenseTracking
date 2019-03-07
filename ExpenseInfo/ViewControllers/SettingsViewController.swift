

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var expensBtn: UIButton!
    @IBOutlet weak var snapBtn: RoundButton!
    
    @IBOutlet weak var enterBillBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var reimbursementBtn: UIButton!
    @IBAction func setPasswordAction(_ sender: Any) {
        setPassword()
    }
    @IBAction func setCurrencyAction(_ sender: Any) {
        setCurrency()
    }
    @IBOutlet weak var menuButton: RoundButton!
    func hideMenu() {
        self.shadowView.isHidden = true
        self.optionsView.isHidden = true
    }
    @IBAction func goHoem(_ sender: Any) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.present(firstVC!, animated: true, completion: nil)
    }
    func showMenu() {
        
        
        self.shadowView.isHidden = false
        self.optionsView.isHidden = false
        
    }
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    var isMenuActive = false
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var shadowView: UIView!
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
    @IBOutlet weak var passwordLbl: UILabel!
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
    func setPassword() {
        let alert = UIAlertController(title: "Password", message: "", preferredStyle: .alert
        )
        
        let textField: TextField.Config = { textField in
            textField.leftViewPadding = 0
            textField.becomeFirstResponder()
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.textColor = .black
            textField.placeholder = "Enter Password"
            textField.keyboardAppearance = .default
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .done
            textField.action { textField in
                Log("textField = \(String(describing: textField.text))")
                
                _ = textField.text ?? ""
                
                self.passwordLbl.text = "\(String(describing: textField.text!))"
                UserDefaults.standard.set(self.passwordLbl.text!, forKey: "Password")
            }
        }
        
        alert.addOneTextField(configuration: textField)
        
        alert.addAction(title: "Done", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        //        alert.show()
    }
    @IBOutlet weak var currency: UILabel!
    func setCurrency() {
        let alert = UIAlertController(title: "Currencies", message: "", preferredStyle: .actionSheet
        )
        
        
        alert.addLocalePicker(type: .currency) { info in
            alert.title = info?.currencyCode
            alert.message = "is selected"
            print("==========> \(String(describing: info?.currencySymbol))")
            self.currency.text = "\(info!.currencySymbol!) \(info!.currencyCode!)"
            UserDefaults.standard.set(info!.currencySymbol!, forKey: "CurrencySymbol")
            UserDefaults.standard.set(info!.currencyCode!, forKey: "CurrencyCode")
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
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
        
        if let currencyCode = UserDefaults.standard.value(forKey: "CurrencyCode") {
            if let currencySymbol = UserDefaults.standard.value(forKey: "CurrencySymbol") {
                self.currency.text = "\(currencySymbol) \(currencyCode)"
            }
        }
        
    }
    
    
    
    
}
