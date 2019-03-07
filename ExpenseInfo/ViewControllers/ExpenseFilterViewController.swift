

import UIKit

class ExpenseFilterViewController: UIViewController {
    @IBOutlet weak var topBar: UIView!
    
    @IBAction func categorySelected(_ sender: Any) {
    }
    @IBAction func merchantSelected(_ sender: Any) {
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var merchantBtn: RoundButton!
    @IBOutlet weak var expenseorincome: UITextField!
    @IBOutlet weak var accountType: UITextField!
    @IBOutlet weak var cuatomeDate: UITextField!
    @IBOutlet weak var reimbursable: UITextField!
    @IBOutlet weak var periodic: UITextField!
    @IBOutlet weak var calenderImg: UIImageView!
    @IBOutlet weak var categoryButton: RoundButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
