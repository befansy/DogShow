//
//  ImagesViewController.swift
//  DogShow2
//
//  Created by Surgeont on 08.11.2021.
//

import UIKit

final class ImagesViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let bigImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.backgroundColor = .black
        return image
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(DogImagesCollectionViewCell.self, forCellWithReuseIdentifier: CellsIdentifiers.dogImagesCollectionViewCell.rawValue)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let imageLoader = LoadAndCashImages.shared
    var choosenBreed: String!
    private var imagesList: [String] = []
    var urlForImageForShare: String?
    var imageForShare: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        setConstraints()
        setNavigationBar()
        loadImageList(breed: choosenBreed)
        viewShare()
    }
    // MARK: - SetupViewa
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.addSubview(spinner)
        spinner.startAnimating()
    }
    // MARK: - Loading Images URLs
    private func loadImageList(breed: String) {
        let baseURL = URLStrings.dogImagesURL.rawValue
        let urlForLoading = addBreedToURL(url: baseURL, breed: choosenBreed)
        LoadDataService.shared.loadImages(urlString: urlForLoading) { [weak self] images, error in
            if error == nil {
                guard let images = images else {return}
                let imagesStrings: [String] = images.message
                self?.imagesList = imagesStrings
                self?.collectionView.reloadData()
                self?.spinner.stopAnimating()
            } else {
                print(error!)
            }
        }
    }
    // MARK: - Addition to URL
    private func addBreedToURL(url: String, breed: String) -> String {
        let path = "\(breed)/images"
        let newURL = url + path
        return newURL
    }
    // MARK: - SetupDelegates
    private func setupDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    // MARK: - Navigatoin Bar Setup
    private func setNavigationBar() {
        navigationItem.title = choosenBreed
        let backButton = createCustomButton(selector: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    // MARK: - Back Button
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Collection View Setup
extension ImagesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifiers.dogImagesCollectionViewCell.rawValue, for: indexPath) as? DogImagesCollectionViewCell {

            let urlString = imagesList[indexPath.row]
            cell.setupCell(url: urlString)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2-1, height: UIScreen.main.bounds.width/2)
    }
    // MARK: - Full Screen Image Setup
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewShare()
        let urlString = imagesList[indexPath.row]
        guard let urlForImage = URL(string: urlString) else { return }
        imageLoader.downloadImage(url: urlForImage) { image in
            self.bigImageView.image = image
        }
        bigImageViewAppears()
        bigImageDisappears()
    }
    
    private func bigImageViewAppears() {
        bigImageView.frame = view.bounds
        view.center = view.center
        view.addSubview(bigImageView)
    }
    
    private func bigImageDisappears() {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(closeBigImage))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        bigImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func closeBigImage() {
        bigImageView.removeFromSuperview()
    }
    // MARK: - Sharing Images Setups
    private func viewShare() {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(self.shareImage))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
        longPressGesture.delegate = self
        self.collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func shareImage(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
                let touchPoint = gestureRecognizer.location(in: self.collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                let url = imagesList[indexPath.row]
                imageLoader.downloadImage(url: URL(string: url)!) { image in
                    self.imageForShare = image
                }
                }
            }
        guard let imageForShare = imageForShare else {return}
        let shareCont = UIActivityViewController(activityItems: [imageForShare], applicationActivities: nil)
        present(shareCont, animated: true, completion: nil)
    }
}

// MARK: - Constraints
extension ImagesViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
