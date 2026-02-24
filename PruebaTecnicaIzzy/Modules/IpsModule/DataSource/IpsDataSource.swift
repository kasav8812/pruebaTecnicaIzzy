//
//  IpsDataSource.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//
import UIKit

protocol OnItemSelectedDelegate : NSObjectProtocol{
    func selectOption(mOption: IpListEntity)
    func deleteOption(mPosition: Int)
}

class IpsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var mSectionsArray : [IpListEntity] = []
    var tableView : UITableView?
    var mReferenceItem : String = "IpItemTableViewCell"
    var mOnItemSelectedDelegate : OnItemSelectedDelegate!
    var mPositionTag : Int?
    
    init(tableView: UITableView, mOnItemSelectedDelegate : OnItemSelectedDelegate) {
        super.init()
        self.tableView = tableView
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 10.0
        let nib = UINib(nibName: mReferenceItem, bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: mReferenceItem)
        self.mOnItemSelectedDelegate = mOnItemSelectedDelegate
    }
    
    func update(items: [IpListEntity]) {
        self.mSectionsArray = items
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sección \(section)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: mReferenceItem) as! IpItemTableViewCell
        cell.ipLbl.text = "IP"
        cell.latLbl.text = "Lat"
        cell.lonLbl.text = "Long"
        cell.countryLbl.text = "País"
        cell.cityLbl.text = "Ciudad"
        cell.continent_codeLbl.text = "CP"
        cell.country_emojiLbl.text = "Emoji"
        cell.contentView.backgroundColor = UIColor.lightGray
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mSectionsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mItem = self.mSectionsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: mReferenceItem, for: indexPath) as! IpItemTableViewCell
        cell.ipLbl.text = mItem.ip
        cell.latLbl.text = mItem.location.latitude
        cell.lonLbl.text = mItem.location.longitude
        cell.countryLbl.text = mItem.location.countryName
        cell.cityLbl.text = mItem.location.city
        cell.continent_codeLbl.text = mItem.location.continentCode
        cell.country_emojiLbl.text = mItem.location.countryEmoji
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return }
            self.mOnItemSelectedDelegate.deleteOption(mPosition: indexPath.row)
            completion(true)
        }
        delete.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @objc func optionSelect(_ sender: UIButton){
        mPositionTag = sender.tag
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mOnItemSelectedDelegate.selectOption(mOption: mSectionsArray[indexPath.row])
    }
}
