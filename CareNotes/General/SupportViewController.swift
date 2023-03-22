//
//  SupportViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 3/20/23.
//

import UIKit

class SupportViewController: UIViewController {

    @IBOutlet weak var privacyBtn: UILabel!
    @IBOutlet weak var supportBtn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Support"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action:#selector(SupportViewController.back(_:)))

        privacyBtn.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyBtnClicked(_:)))
        privacyBtn.addGestureRecognizer(guestureRecognizer)
        
        supportBtn.isUserInteractionEnabled = true
        let guestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(supportBtnClicked(_:)))
        supportBtn.addGestureRecognizer(guestureRecognizer2)
        
        self.navigationItem.scaleText();
    }

    @IBAction func privacyBtnClicked(_ sender: Any) {
        if let url = URL(string: "https://www.caregivernotes.org/PrivacyPolicy.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func supportBtnClicked(_ sender: Any) {
        if let url = URL(string: "https://www.caregivernotes.org/PrivacyPolicy.html") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }

}
