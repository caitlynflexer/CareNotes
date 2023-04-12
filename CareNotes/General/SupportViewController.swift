//
//  SupportViewController.swift
//  CareNotes
//
//  Created by Caitlyn Flexer on 3/20/23.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var privacyBtn: UILabel!
    @IBOutlet weak var supportBtn: UILabel!
    @IBOutlet weak var exportBtn: UILabel!
    
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
        
        exportBtn.isUserInteractionEnabled = true
        let guestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(exportBtnClicked(_:)))
        exportBtn.addGestureRecognizer(guestureRecognizer3)
        
        self.navigationItem.scaleText();
    }

    @IBAction func privacyBtnClicked(_ sender: Any) {
        if let url = URL(string: "https://caregivernotes.org/Privacy%20Policy.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func supportBtnClicked(_ sender: Any) {
        if let url = URL(string: "https://caregivernotes.org/Home.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func exportBtnClicked(_ sender: Any) {
        let allData = DataMgr.instance().createCSVData()
        
        if (allData != "") {
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                composeVC.setToRecipients(nil)
                composeVC.setSubject("Caregiver Notes Data")
                composeVC.setMessageBody("Attached is a CSV file containing the data from the Caregiver Notes app.", isHTML: false)
                
                do {
                    composeVC.addAttachmentData(Data(allData.utf8), mimeType: "text/comma-separated-values" , fileName: "careNotesAllData.csv")
                    self.present(composeVC, animated: true, completion: nil)
                } catch {
                    showErrorDlg(message: "Unable to send data")
                }
                
            } else {
                showErrorDlg(message: "Email is not yet set up on device")
            }
        } else {
            showErrorDlg(message: "No journal entry data to send.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        goBack()
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func showErrorDlg(message : String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
