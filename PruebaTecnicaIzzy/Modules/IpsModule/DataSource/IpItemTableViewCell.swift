//
//  IpItemTableViewCell.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import UIKit

class IpItemTableViewCell: UITableViewCell {
    @IBOutlet weak var ipLbl: UILabel!
    @IBOutlet weak var lonLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var latLbl: UILabel!
    @IBOutlet weak var country_emojiLbl: UILabel!
    @IBOutlet weak var continent_codeLbl: UILabel!
    @IBOutlet weak var containerSV: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
