//
//  IpListViewController.swift
//  PruebaTecnicaIzzy
//
//  Created by Carlos Salazar Vazquez on 23/02/26.
//

import UIKit

class IpListViewController: UIViewController {
    @IBOutlet weak var listIPTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var loader: UIActivityIndicatorView?
    var presenter : IpList_ViewToPresenter?
    var dataSource : IpsDataSource?
    let mRefreshControl = UIRefreshControl()
    var listIps : [IpListEntity] = []
    var filteredData : [IpListEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFilterButton()
        prepareTableView()
        prepareSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "IP List"
    }
    
    func prepareSearchBar(){
        searchBar.delegate = self
    }
    
    func prepareTableView(){
        mRefreshControl.addTarget(self, action: #selector(self.refreshControl(_:)), for: .valueChanged)
        dataSource = IpsDataSource(tableView: listIPTableView, mOnItemSelectedDelegate: self)
        listIPTableView.dataSource = dataSource
        listIPTableView.delegate = dataSource
        listIPTableView.addSubview(mRefreshControl)
        listIPTableView.reloadData()
    }
    
    func addFilterButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: .add, target: self, action: #selector(lookUp))
    }
    
    @objc func lookUp(){
        let alert = UIAlertController(title: "Buscar IP", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "1.1.1.1"
            textField.keyboardType = .decimalPad
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        let accept = UIAlertAction(title: "Buscar", style: .default) { _ in
            let text = alert.textFields?.first?.text ?? ""
            if self.isSameIp(text){
                self.showAlert(title: "Aviso", message: "La ip ingresada ya se encuentra registrada")
            }else{
                self.presenter?.getIps(ipSearch: text)
            }
        }
        alert.addAction(cancel)
        alert.addAction(accept)
        present(alert, animated: true)
    }
    
    @objc func refreshControl(_ sender: AnyObject){
        mRefreshControl.endRefreshing()
    }
    
    func showAlert(title: String , message : String) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.mRefreshControl.endRefreshing()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func isSameIp(_ ip : String)->Bool{
        if listIps.contains(where: { $0.ip == ip }) {
            return true
        }else {
            return false
        }
    }
}

extension IpListViewController : UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = listIps
        } else {
            filteredData = listIps.filter {
                $0.ip.lowercased().contains(searchText.lowercased()) ||  $0.location.countryName.lowercased().contains(searchText.lowercased()) ||  $0.location.city.lowercased().contains(searchText.lowercased())
            }
        }
        dataSource?.update(items: filteredData)
    }
}


extension IpListViewController: IpList_PresenterToView{
    func showLoader() {
        loader = UIActivityIndicatorView(style: .large)
        loader?.center = view.center
        loader?.startAnimating()
        loader?.hidesWhenStopped = true
        view.addSubview(loader!)
    }
    
    func dismissLoader() {
        loader?.stopAnimating()
    }
    
    func showListIps(_ responseList: IpListEntity) {
        listIps.append(responseList)
        dataSource?.update(items: listIps)
    }
    
    func displayMessageError(errorMessage: String) {
        showAlert(title: "Error", message: errorMessage)
    }
}

extension IpListViewController: OnItemSelectedDelegate{
    func deleteOption(mPosition : Int) {
        self.listIps.remove(at: mPosition)
        dataSource?.update(items: listIps)
    }
    
    func selectOption(mOption: IpListEntity) {
        presenter?.gotoMap(name: mOption.location.city, lat: mOption.location.latitude, lon: mOption.location.longitude)
    }
}
