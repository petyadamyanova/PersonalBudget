//
//  CustomCellTableViewCell.swift
//  PersonalBudget
//
//  Created by Petia Damyanova on 22.08.23.
//

import UIKit

class CustomCell: UITableViewCell {
    static var indentifier: String { "CustomCell" }
    
    var title = UILabel()
    var count = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        count.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        count.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        count.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
        count.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
