//
//  ViewController.swift
//  FlickrApp
//
//  Created by Jacob Ahlberg on 2018-04-18.
//  Copyright © 2018 Jacob Ahlberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var flickrCollectionView: UICollectionView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var isSearching = false
    var flickrImages: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        textField.alpha = 0
        searchBtn.alpha = 0
        flickrCollectionView.alpha = 0
        
    }

    @IBAction func searchBtnWasPressed(_ sender: Any) {
        startSpinner(start: true)
        view.endEditing(true)
        flickrImages = []
        guard let text = textField.text else {
            startSpinner(start: false)
            return
        }
        
        if text == "" {
            startSpinner(start: false)
            alert(title: "Uh uh...", message: "Something went wrong, please try to add some text in that field!")
            return
        }
        
        DataManager.shared.searchImages(searchedText: text) { (photos, error) in
            if let error = error {
                self.alert(title: "Uh uh...", message: error.localizedDescription)
                self.startSpinner(start: false)
            } else if let photos = photos {                
                DataManager.shared.downloadImages(photos, completion: { (photos, error) in
                    if let error = error {
                        self.alert(title: "Uh uh...", message: error.localizedDescription)
                        self.startSpinner(start: false)
                    } else if let photos = photos {
                        self.flickrImages = photos
                        self.flickrCollectionView.reloadData()
                        self.startSpinner(start: false)
                        UIView.animate(withDuration: 0.2, animations: {
                            self.flickrCollectionView.alpha = 1
                        })
                    }
                })
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.textField.alpha = 1
            self.searchBtn.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "informationSegue" {
            guard let destination = segue.destination as? InformationVC,
                let photo = sender as? Photo
                else {
                    return
            }
            destination.setPhoto(clickedPhoto: photo)
        }
    }
    
    
    func enableSearchBtn(enable: Bool) {
        if enable {
            searchBtn.isEnabled = true
        } else {
            searchBtn.isEnabled = false
        }
    }
    
    func startSpinner(start: Bool) {
        if start {
            spinner.startAnimating()
            spinner.isHidden = false
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    func animateCells() {
        let cells = flickrCollectionView.visibleCells
        let collectionViewHeight = flickrCollectionView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: collectionViewHeight)
        }
        
        var delay: Double = 0
        for cell in cells {
            UIView.animate(withDuration: 0.5, delay: delay * 0.05, options: .curveEaseInOut, animations: {
                cell.transform = .identity
            }, completion: nil)
            delay += 1
        }
    }
    
    func alert(title: String, message: String) {
        let alertvc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
        alertvc.addAction(action)
        present(alertvc, animated: true, completion: nil)
    }
    
}

// MARK: - CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrCell", for: indexPath) as? FlickrCell else { return UICollectionViewCell() }
        cell.imageView.image = flickrImages[indexPath.row].thumbNail
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        UIView.animate(withDuration: 0.2, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (complete) in
            UIView.animate(withDuration: 0.2, animations: {
                cell?.transform = .identity
            }, completion: nil)
            self.performSegue(withIdentifier: "informationSegue", sender: self.flickrImages[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

