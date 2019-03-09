//
//  HomeViewController.swift
//  Vertex
//
//  Created by Khrongpop Phonngam on 12/31/2560 BE.
//  Copyright © 2560 Khrongpop Phonngam. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    fileprivate var categories = [Category]()
    @IBOutlet weak var collectionView: UICollectionView!
    
   
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToProduct"
        {
            let seguevc = segue.destination as! SectionViewController
            let cate = sender as! Category
            
            seguevc.initProduct(category: cate)
        }
        
    }

   

}
extension HomeViewController: UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.numberOfCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        
        let c = DataService.instance.getCategory(atIndex: indexPath.row)
        
        cell.updateUI(category: c)
        
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //print(indexPath)
        let cell = DataService.instance.getCategory(atIndex: indexPath.row)
        performSegue(withIdentifier: "GoToProduct", sender: cell)
    }
    
}
