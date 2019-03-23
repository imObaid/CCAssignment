//
//  SecondVC.swift
//  Test
//
//  Created by Ubaid ur Rahman on 23/03/2019.
//  Copyright © 2019 Ubaid ur Rahman. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var lblCountry: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblHumdity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    
    var current:VMWeather!
    var forecast:[VMWeather]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupValues()
        self.configureCV()
    }
    
    private func setupValues(){
        lblCountry.text = current!.country!
        lblCity.text = current.city!
        lblWind.text = "\(current!.wind!) Km/h"
        lblHumdity.text = "\(current!.humidity!) %"
        lblPressure.text = "\(current!.pressure!) %"
        lblTemperature.text = "\(current!.temperature!)"
        
        let date = Date()
        lblDay.text = "\(date.toString(withFormat: "EEEE")) , \(current!.text!)"
        
        
    }
}

extension SecondVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func configureCV(){
        self.collectionView.register(UINib.init(nibName: "SecondCellItem", bundle: nil), forCellWithReuseIdentifier: SecondCellItem.cellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCellItem.cellId, for: indexPath) as! SecondCellItem
        cell.bindDate(forecast[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCell:CGFloat = CGFloat(forecast.count)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        let cellWidth = CGFloat((collectionView.frame.width - max(0, numberOfCell - 1)*horizontalSpacing)/numberOfCell)
        flowLayout.itemSize = CGSize(width: cellWidth, height: collectionView.frame.height - 10)
        return flowLayout.itemSize
    }
    
}
