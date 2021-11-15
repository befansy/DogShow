//
//  BreedsViewController.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import UIKit


final class BreedsViewController: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.color = .blue
        spinner.style = .large
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Doggies"
        label.font = .systemFont(ofSize: 25, weight: .black)
        return label
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(BreedsTableViewCell.self, forCellReuseIdentifier: CellsIdentifiers.breedsTableViewCell.rawValue)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: [.font: UIFont.systemFont(ofSize: 12)])
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var breedList: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupDelegates()
        loadBreeds()
    }
    
    // MARK: - Loading Breeds
    private func loadBreeds() {
        let urlForLoading = URLStrings.breedsListURL.rawValue
        LoadDataService.shared.loadBreeds(urlString: urlForLoading) { [weak self] dogs, error in
            if error == nil {
                guard let dogs = dogs else {return}
                let breeds: [String] = dogs.message.map{String($0.key) }
                self?.breedList = breeds.sorted(by: <)
                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            } else {
                print(error!)
            }
        }
    }
    
    
    // MARK: - SetupViews
    private func setupViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(headLabel)
        backgroundView.addSubview(tableView)
        tableView.addSubview(spinner)
        spinner.startAnimating()

    }
    // MARK: - SetupDelegates
    private func setupDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    // MARK: - RefreshControl Func
    @objc private func refresh(_ sender: UIRefreshControl) {
        loadBreeds()
        sender.endRefreshing()
    }
}

// MARK: - Constraints
extension BreedsViewController {
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headLabel.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 20),
            headLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
            headLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
}

// MARK: - TableView Setups
extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellsIdentifiers.breedsTableViewCell.rawValue, for: indexPath) as? BreedsTableViewCell {
            let breed = breedList[indexPath.row]
            cell.setupCell(breed: breed)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
   }
    // MARK: - TableViewCell Select Setup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let breed = breedList[indexPath.row]
        let destinationViewController = ImagesViewController()
        destinationViewController.choosenBreed = breed
        let navigationVC = UINavigationController(rootViewController: destinationViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true, completion: nil)
    }
}
