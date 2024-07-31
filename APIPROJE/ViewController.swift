//
//  ViewController.swift
//  APIPROJE
//
//  Created by buse koca on 1.07.2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var model : [Product] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        as! ProductCellCollectionViewCell  //burada productcelldeki(olarak) gıbı ozellık alsın dedık
        let item = model[indexPath.row]
        guard let imageName = item.image, let price = item.price else { return UICollectionViewCell() }
        if let imageURL = URL(string: imageName) {
            cell.productIV.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.productIV.image = UIImage(named: "placeholder")
        }
        cell.productTitle.text = item.title
        cell.price.text = "Price: \(String(price))"
        return cell
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self //uygulama başlatıldıgında collectıonvıew ı baslatıcam mutlaka yazılmalı
        verileriGetir()
    }
    
    func verileriGetir() {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Veri mevcut değil")
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.model = products
                    self.collectionView.reloadData()
                }
            } catch {
                print("JSON parse hatası: \(error.localizedDescription)")
            }
            
        }.resume()
    }
}
