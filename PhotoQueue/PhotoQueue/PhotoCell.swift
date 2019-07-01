//
//  PhotoCell.swift

import UIKit
import Foundation
class PhotoCell: UITableViewCell{
    var imgView = UIImageView()
    override func layoutSubviews() {
        imgView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imgView.contentMode = .scaleAspectFit
        addSubview(imgView)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

