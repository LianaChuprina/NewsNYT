//
//  ArticlTableViewCell.swift
//  test
//
//  Created by Лиана Чуприна on 30.08.2021.
//

import UIKit
import Kingfisher

class ArticlTableViewCell: UITableViewCell {
    
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var imageViewXib: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        label.font = UIFont(name: "Cochin-Bold", size: 20)
        subTitle.font = UIFont(name: "Cochin", size: 16)
    }
    
    func render(with model: ArticlModel) {
        label.text = model.title
        subTitle.text = model.time
       
      

        guard let imageURL = model.imageURL,
              let url = URL(string: imageURL) else {return}
        
        imageViewXib.kf.setImage(with: url)
       
    }
}
    


