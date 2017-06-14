//
//  MenuViewController.swift
//  IndoorNavigation
//
//  Created by jeff on 13/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    fileprivate let cellId = String(describing: MenuCell.self)
    fileprivate let menuOptions:[[String:String]] = [["title":"History"],["title":"Setting"],["title":"Sign Out"]]
    var homeViewControllerDelegate: HomeViewControllerDelegate?
    
    private let tableView:UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        return view
    }()
    
    private let btnCloseMenu: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(MenuCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        btnCloseMenu.addTarget(self, action: #selector(handleCloseMenu), for: .touchUpInside)
        view.addSubview(btnCloseMenu)
        btnCloseMenu.translatesAutoresizingMaskIntoConstraints = false
        btnCloseMenu.leadingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        btnCloseMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        btnCloseMenu.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        btnCloseMenu.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
    }
    
    func showMenu() {
        btnCloseMenu.isHidden = true
        tableView.frame.origin.x = -view.frame.width
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.frame.origin.x = 0
        }) { (complete) in
            self.btnCloseMenu.isHidden = false
        }
    }
    
    func hideMenu() {
        btnCloseMenu.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.frame.origin.x = -self.view.frame.width
        }) { (complete) in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    @objc
    private func handleCloseMenu() {
        hideMenu()
    }
    
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MenuCell
        cell.selectionStyle = .none
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = .clear
        cell.textLabel?.text = menuOptions[indexPath.row]["title"]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            hideMenu()
            homeViewControllerDelegate?.showHistory()
        } else if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            homeViewControllerDelegate?.signOut()
        }
    }
}

class MenuCell: UITableViewCell {
    
}
