

import UIKit
import WSTagsField
class ShareCell: UICollectionViewCell {
    
   
    @IBOutlet weak var merchantDetails: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tagsView: UIView?
    fileprivate let tagsField = WSTagsField()
    @IBOutlet weak var tagScroll: UIScrollView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var claimedLbl: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var modeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
        layer.shadowRadius = 2
        tagsField.readOnly = true

        tagsField.layoutMargins = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
 tagsField.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 5)
        

        tagsField.spaceBetweenTags = 10
        tagsField.backgroundColor = .clear
        tagsField.font = UIFont(name: "WorkSans-Regular", size: 14.0)
        tagsField.textColor = UIColor(hexString: "84996A")//UIColor(hexString: "426891")
        tagsField.fieldTextColor = UIColor(hexString: "84996A")
        tagsField.selectedColor = UIColor(hexString: "DADEEB")
        tagsField.selectedTextColor = UIColor(hexString: "84996A")
        tagsField.tintColor = UIColor(hexString: "E6F3D6")
        tagsField.acceptTagOption = .space
    }
    func clearCell () {
        self.tagsField.removeTags()
        //self.tagsView?.isHidden = true
    }
    func configureTags(value : [String])  {
        for val in value {
            self.tagsField.addTag(val)
        }
    }

    
    private func twoDigitsFormatted(_ val: Double) -> String {
        return String(format: "%.0.2f", val)
    }
}
