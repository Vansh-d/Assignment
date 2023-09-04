//
//  TableViewCell.swift
//  Assignment
//
//  Created by Vansh Dubey on 30/08/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var outerView: UIView!
    
    var cellTapped: ((Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerView.backgroundColor = .orange
        self.bottomView.backgroundColor = .green
        self.outerView.layer.cornerRadius = 25
        self.bottomView.layer.cornerRadius = 20
        self.imageIcon.image = UIImage(systemName: "gamecontroller")
        self.imageIcon.backgroundColor = .yellow
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextScreen))
        self.outerView.addGestureRecognizer(tapRecognizer)
    }

    
    @objc private func nextScreen(_ sender:Any){
        self.cellTapped?(true)
    }
    
}
