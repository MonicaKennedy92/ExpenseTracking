

import UIKit
import CoreData
import RKPieChart

class ExpenseReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var expenseTable: UITableView!
    @IBOutlet weak var viewsize: UIView!
    @IBOutlet weak var midview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var expenseValueBlock : Double = 0.0
    var reportItemsArray = [ReportItem]()
    var globalCurrencySymbol : String = "$"
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "CurrencyCode") != nil {
            if let currencySymbol = UserDefaults.standard.value(forKey: "CurrencySymbol") {
                globalCurrencySymbol = "\(currencySymbol)"
            } else {
                globalCurrencySymbol = "$"
            }
        }
        updateBlocks()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportItemsArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBOutlet weak var emptyLbl: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "reportCell")! as! ReportsTableViewCell
        let myItem = reportItemsArray[indexPath.row]
        print(myItem)
        cell.colorImg.backgroundColor = myItem.color
        cell.typeLbl.text = myItem.type
        let valuePercent = String(format:"%.2f", myItem.percentage!)
        cell.percentage.text = "\(valuePercent)%"
        let value = String(format:"%.2f", myItem.amount!)
        cell.amount.text = "\(globalCurrencySymbol)\(value)"
        
        return cell
    }
    
    func updateBlocks() {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var itemsArray = [RKPieChartItem]()
        let typefetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
        
        do {
            let fetchedtype = try managedObjectContext.fetch(typefetch) as! [ExpenseContent]
            if fetchedtype.count > 0 {
                for exp in fetchedtype {
                    let myString = exp.amount
                    let myFloat = (myString! as NSString).doubleValue
                    expenseValueBlock += myFloat
                }
                
            }
        } catch {
            
        }
        
        
        
        
        let catId : [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17"]
        var categorycolor : String = ""
        
        for i in catId {
            let typefetch1 = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseContent")
            typefetch1.predicate = NSPredicate(format: "categoryId == %@ ",i)
            
            do {
                let fetchedtype = try managedObjectContext.fetch(typefetch1) as! [ExpenseContent]
                if fetchedtype.count > 0 {
                    var expenseAmount : Double = 0.0
                    var categoryName : String = ""
                    for exp in fetchedtype {
                        expenseAmount += Double(exp.amount!)!
                        categorycolor = exp.categoryColor!
                        categoryName = exp.expenseCategory!
                    }
                    let a : Double = expenseAmount
                    let b : Double = expenseValueBlock
                    let c = (a / b ) * 100
                    let item1 =  ReportItem(color: UIColor(hexString: categorycolor), type: categoryName, percentage:c , amount: expenseAmount)
                    
                    reportItemsArray.append(item1)
                    
                    let firstItem: RKPieChartItem = RKPieChartItem(ratio: c, color: UIColor(hexString: categorycolor), title: "")
                    itemsArray.append(firstItem)
                } else {
                    
                }
                
                
                
            } catch {
                print(error)
            }
        }
        let value = String(format:"%.2f", expenseValueBlock)
        let title = "\(globalCurrencySymbol)\(value)"
        let chartView = RKPieChartView(items: itemsArray, centerTitle: title)
        if  itemsArray.count == 1 {
            chartView.circleColor =  UIColor(hexString: categorycolor)
        } else {
            chartView.circleColor = .clear
        }
        
        if itemsArray.count == 0 {
            emptyLbl.isHidden = false
            self.expenseTable.isHidden = true
            
        } else {
            emptyLbl.isHidden = true
            self.expenseTable.isHidden = false
            
        }
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 50
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = true
        self.viewsize.addSubview(chartView)
        chartView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.viewsize.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: self.viewsize.centerYAnchor).isActive = true
        
        
        
    }
    
    
}
