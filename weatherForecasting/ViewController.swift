//
//  ViewController.swift
//  weatherForecasting
//
//  Created by Niranjan Kumar on 15/07/25.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var mSearchView: UISearchBar!
    @IBOutlet weak var ivWeather: UIImageView!
    @IBOutlet weak var rainValue: UILabel!
    @IBOutlet weak var windValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weatherDate: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var mScrollView: UIScrollView!
    let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mScrollView.refreshControl = UIRefreshControl()
        mScrollView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    @objc func refreshData() {
        viewModel.refreshWeatherData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    
    private func bindViewModel() {
            // Observe the @Published data
            viewModel.$weatherData.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Completed successfully")
                case .failure(let error):
                    print("Received error: \(error)")
                }
            }, receiveValue: {[weak self] value in
                print("Received value: \(value)")
                self?.updateUI(with: value!)
            }).store(in: &cancellables)
        }

    private func updateUI(with data: WeatherData) {
        
            // Update UILabels, views, etc.
            print("Updating UI with: \(data)")
        }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
    }
    
    
    
}


extension ViewController:UISearchBarDelegate{
    
}
