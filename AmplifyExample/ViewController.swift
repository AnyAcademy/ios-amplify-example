//
//  ViewController.swift
//  AmplifyExample
//
//  Created by Ersin Yildirim on 8.02.2022.
//

import UIKit
import Amplify

class ViewController: UIViewController {
  @IBOutlet weak var authenticationStatusLabel: UILabel!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var getStatusButton: UIButton!
  
  var loading: Bool = false {
    didSet {
      DispatchQueue.main.async {
        if self.loading {
          self.activityIndicatorView.startAnimating()
        } else {
          self.activityIndicatorView.stopAnimating()
        }
        
        self.getStatusButton.isEnabled = !self.loading
      }
    }
  }
  
  var isSignedIn: Bool? = nil {
    didSet {
      guard let isSignedIn = isSignedIn else {
        return
      }
      
      DispatchQueue.main.async {
        self.authenticationStatusLabel.text =
          isSignedIn ? "Authenticated" : "Not authenticated"
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func checkAuthenticationStatus(_ sender: UIButton) {
    loading = true
    
    Amplify.Auth.fetchAuthSession { result in
      switch result {
      case .success(let session):
        print("Authentication status: \(session.isSignedIn)")
        
        self.isSignedIn = session.isSignedIn
        
      case .failure(let error):
        print("Encountered an error while fetching authentication session: \(error.localizedDescription)")
      }
      
      self.loading = false
    }
  }
}

