

import UIKit
import CoreData
protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String, image: String, id: String , color: String)
}
struct ExpenseCategory  {
    
    var categoryName : String?
    var categoryImg : String?
    var categoryId : String?
    var categoryColor : String?
    
}
class ExpenseCategoryViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var bottomView: UIView!
    
    
    
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var categoryCollection: UICollectionView!
    fileprivate let cellId = "categoryCell"
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCollectionViewCell
        let value = expenseCategory[indexPath.row]
        cell.catName.text = value.categoryName
        
        cell.catImage.image = UIImage(named: value.categoryImg!)
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let value = expenseCategory[indexPath.row]//categNameArray[indexPath.row]
        delegate?.userDidEnterInformation(info: value.categoryName!, image: value.categoryImg! , id: value.categoryId!, color: value.categoryColor!)
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return expenseCategory.count
    }
    var cate = ExpenseCategory()
    
    
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var searchBar: UISearchBar!
    var callback : ((String) -> Void)?
    var expenseCategory = [ExpenseCategory]()
    
    var resultSearchController = UISearchController()
    func setSearchIconToFavicon() {
        var searchField: UITextField? = nil
        
        let image = UIImage(named: "merchant-search")
        let iView = UIImageView(image: image)
        
        
    }
    @IBOutlet weak var categoryTableView: UITableView!
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cate.categoryId = "1"
        cate.categoryName = "Cloths"
        cate.categoryImg = "clothes"
        cate.categoryColor = "ff5252"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "2"
        cate.categoryName = "Food"
        cate.categoryImg = "food"
        cate.categoryColor = "455a64"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "3"
        cate.categoryName = "Health"
        cate.categoryImg = "health"
        cate.categoryColor = "ff4081"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "4"
        cate.categoryName = "Hotel"
        cate.categoryImg = "hotel"
        cate.categoryColor = "616161"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "5"
        cate.categoryName = "Party"
        cate.categoryImg = "party"
        cate.categoryColor = "e040fb"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "6"
        cate.categoryName = "Travel"
        cate.categoryImg = "Travel"
        cate.categoryColor = "5d4037"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "7"
        cate.categoryName = "Education"
        cate.categoryImg = "education"
        cate.categoryColor = "7c4dff"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "8"
        cate.categoryName = "Entertainment"
        cate.categoryImg = "entertainment"
        cate.categoryColor = "ff6e40"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "9"
        cate.categoryName = "Fitness"
        cate.categoryImg = "fitness"
        cate.categoryColor = "536dfe"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "10"
        cate.categoryName = "Gift"
        cate.categoryImg = "gift"
        cate.categoryColor = "ffd180"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "11"
        cate.categoryName = "Labour"
        cate.categoryImg = "labour"
        cate.categoryColor = "40c4ff"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "12"
        cate.categoryName = "Loan"
        cate.categoryImg = "loan"
        cate.categoryColor = "ffd740"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "13"
        cate.categoryName = "Shop"
        cate.categoryImg = "shop"
        cate.categoryColor = "18ffff"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "14"
        cate.categoryName = "Sports"
        cate.categoryImg = "sports"
        cate.categoryColor = "eeff41"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "15"
        cate.categoryName = "Transport"
        cate.categoryImg = "transport"
        cate.categoryColor = "64ffda"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "16"
        cate.categoryName = "Utilities"
        cate.categoryImg = "utilities"
        cate.categoryColor = "b2ff59"
        
        expenseCategory.append(cate)
        
        cate.categoryId = "17"
        cate.categoryName = "Others"
        cate.categoryImg = "others"
        cate.categoryColor = "1b5e20"
        
        expenseCategory.append(cate)
        
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = categoryCollection.frame.width
        layout.itemSize = CGSize(width: categoryCollection.frame.width / 3  , height:  categoryCollection.frame.width / 3 )//CGSize(width: width / 3, height: width / 3)
        
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        
        categoryCollection.reloadData()
        let imageSize = CGSize(width: 50 , height: 30)
        let headertitle = UILabel(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        
        headertitle.text = "Category"
        headertitle.textColor = .white
        headertitle.font = UIFont(name: "WorkSans-Regular", size: 18)
        
        self.navigationItem.titleView = headertitle
        categoryCollection.reloadData()
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    
}
