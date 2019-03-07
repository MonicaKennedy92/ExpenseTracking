

import UIKit
import CoreData
class SearchViewController: UIViewController,UISearchBarDelegate {
    var expenseListArray = [ExpenseListInfo]()
    var filtered = [ExpenseListInfo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let cellId = "ShareCell"
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    private let itemHeight: CGFloat = 90
    
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
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        let nib = UINib(nibName: cellId, bundle: nil)
        collectionView.register( nib, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset.bottom = itemHeight
        configureCollectionViewLayout()
        getExpenseList()
        
    }
    
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
                    addAcc.expenseMode = exp.expenseMode

                    let myFloat = (myString! as NSString).doubleValue
                    addAcc.date = exp.dateString
                    addAcc.categoryImg = exp.expenseCategoryImg
                    addAcc.time = exp.timeString
                    addAcc.reimbursable = exp.reimbursable
                    addAcc.id = exp.id
                    addAcc.currencySymbol = exp.expenseorIncome
                    addAcc.category = exp.expenseCategory
                    addAcc.tags = exp.tags as? [String]
                    print(exp.tags as? [String] as Any)
                    addAcc.notes = exp.notes
                    if exp.billImage != nil {
                        addAcc.billImg =  exp.billImage
                    }
                    expenseListArray.append(addAcc)
                }
            } else {
                if (self.expenseListArray.count == 0) {
                } else {
                    self.collectionView.restore()
                }
            }
        } catch {
            
            
        }
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("didchange")
        
        if searchText.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                searchBar.resignFirstResponder()
            })
        }
        
        filtered = expenseListArray.filter {$0.merchantName?.range(of: searchText, options: [.anchored, .caseInsensitive, .diacriticInsensitive]) != nil }
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.collectionView.reloadData()
    }
    
}
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseDetailsViewController") as? ExpenseDetailsViewController
        
        
        let share = filtered[indexPath.row]
        vc2?.expenseListArray = share
        self.present(vc2!, animated: true)
        
    }
}
extension SearchViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShareCell
        let share = filtered[indexPath.row]
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
        print("indexPath \(indexPath.row) value : \(String(describing: share.tags))")
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.filtered.count == 0) {
            self.collectionView.setEmptyMessage("Nothing to show :(")
        } else {
            self.collectionView.restore()
        }
        
        
        return filtered.count
    }
}

