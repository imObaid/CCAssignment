//
//  FirstVC.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[VMRestaurant] = [VMRestaurant]()
    
    var userLocation:Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //get user location
        LocationHelper.shared.getCurrentLocation { [weak self] (location, error) in
            if let e = error{
                print(e.localizedDescription)
            }else{
                self?.userLocation = location
                print("location found : \(location!.latitude),\(location!.longitude)")
                self?.setWeatherButton()
                self?.getData(location!.latitude, lng: location!.longitude)
            }
        }
    }
    
    private func setWeatherButton(){
        let button = UIButton()
        button.setTitle("Weather", for: .normal)
        button.titleLabel?.font = UIFont.init(name: "Gill-Sans-SemiBold", size: 16)
        button.setTitleColor(.red, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(FirstVC.barButtonAction), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func barButtonAction(){
        self.getWeatherData()
    }
    
    private func getData(_ lat:Double , lng:Double){
        self.showLoading()
        VMRestaurant.shared.getData(forLat: lat, andLong: lng, withRadius: 5000, successHandler: { [weak self] (dataArr) in
            self?.hideLoading()
            self?.dataArray = dataArr
            self?.configureTableView()
        }, failHandler: { (error) in
            print(error)
        })
    }
    
    private func getWeatherData(){
        guard let location = self.userLocation else{return}
        self.showLoading()
        VMWeather.shared.getData(forLat: location.latitude, andLong: location.longitude, forDays: 6, successHandler: { [weak self] (current, forcast) in
            
            self?.hideLoading()
            
            print(current.country)
            let vc = SecondVC.init(nibName: "SecondVC", bundle: nil)
            vc.current = current
            vc.forecast = forcast
            self?.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in
            print(error)
        }
    }
}

extension FirstVC : UITableViewDelegate, UITableViewDataSource{
    
    func configureTableView(){
        tableView.register(UINib.init(nibName: "FirstItemCell", bundle: nil), forCellReuseIdentifier: FirstItemCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:FirstItemCell.cellId, for: indexPath) as! FirstItemCell
        cell.bindData(dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
