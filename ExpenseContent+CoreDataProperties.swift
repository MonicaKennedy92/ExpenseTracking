

import Foundation
import CoreData


extension ExpenseContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseContent> {
        return NSFetchRequest<ExpenseContent>(entityName: "ExpenseContent")
    }

    @NSManaged public var amount: String?
    @NSManaged public var billImage: NSData?
    @NSManaged public var dateString: String?
    @NSManaged public var expenseCategory: String?
    @NSManaged public var expenseCategoryImg: NSData?
    @NSManaged public var expenseorIncome: String?
    @NSManaged public var id: String?
    @NSManaged public var merchantName: String?
    @NSManaged public var notes: String?
    @NSManaged public var expenseMode: String?
    @NSManaged public var isClaimed: String?
    @NSManaged public var reimbursable: Bool
    @NSManaged public var tags: NSObject?
    @NSManaged public var timeString: String?
    @NSManaged public var categoryColor: String?
    @NSManaged public var categoryId: String?

}
