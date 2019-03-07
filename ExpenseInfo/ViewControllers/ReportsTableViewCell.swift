

import UIKit

class ReportsTableViewCell: UITableViewCell {
    @IBOutlet weak var colorImg: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
