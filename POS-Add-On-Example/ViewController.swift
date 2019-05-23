//
//  ViewController.swift
//  POS-Add-On-Example
//
//  Created by Amjad on 4/30/19.
//  Copyright © 2019 Receet. All rights reserved.
//

import UIKit
import ReceetPOSAddOn

class ViewController: UIViewController {
    
    @IBOutlet weak var integrationSwitch: UISwitch!
    @IBOutlet weak var sendDigitalOrderButton: UIButton!
    @IBOutlet weak var resetAuthCodeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var posIDLabel: UILabel!
    @IBOutlet weak var beaconIDLabel: UILabel!

    
    @IBAction func integrationButtonSwitched(_ sender: UISwitch) { //toggle Receet POS integration
        sendDigitalOrderButton.isEnabled = sender.isOn
        sendDigitalOrderButton.alpha = sender.isOn ? 1.0 : 0.5
        
        resetAuthCodeButton.isEnabled = sender.isOn
        resetAuthCodeButton.alpha = sender.isOn ? 1.0 : 0.5
        
        if sender.isOn {
            ReceetPOS.shared.turnOn(authCode: <#T##String#>)
        }else {
            ReceetPOS.shared.turnOff()
        }
    }
    @IBAction func resetAuthCodeButtonSwitched(_ sender: UIButton) { //reset authorization code
        ReceetPOS.shared.resetAuthCode(authCode: <#T##String#>) // you can always reset auth code to make sure that the POS has the latest code
    }
    
    @IBAction func sendDigitalOrderButtonPressed(_ sender: Any) {
        // order details and items, the order must be a dictionary with the following format
        let orderDetails : [String:Any] = [
            "externalId" : "T004-126572",
            "subTotalProduct": 634.52,
            "totalProduct" : 634.52,
            "order_product_subtotal" : 634.52,
            "totalTax" : 0.00,
            "totalShipping" : 0.00,
            "totalTaxShipping" : 0.00,
            "totalAdjustment" : 0.00,
            "description" : "Mobile transaction",
            "currency" : "NIS",
            "createdBy" : "Omar",
            "buttomTextArea":"totalPoint:500,receiptPoint:5"
        ]
        
        let orderItems : [[String:Any]] = [
            [
                "price" : 634.52,
                "description": "Deco Wi-Fi System",
                "quantity" : 1,
                "totalProduct" : 634.52,
                "taxAmount" : 0.00,
                "shipCharg" : 0.00,
                "adjustmentDescription":"5% Discount",
                "shipTaxAmount" : 0.00,
                "totalAdjustment" : 0.00,
                "itemNumber":"17172",
            ],
        ]
        
        let order : [String:Any] = [
            "media":"digital",
            "languageId":1,
            "order":orderDetails,
            "order_items":orderItems
        ]
        ReceetPOS.shared.sendDigitalOrder(order: order)// send the digital order To Receet POS
        if let posID = ReceetPOS.shared.posID {
            posIDLabel.text = String(posID)
        }
        beaconIDLabel.text = ReceetPOS.shared.virtualBeaconID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        integrationSwitch.setOn(ReceetPOS.shared.isEnabled, animated: true)// keep track of the integration status
        sendDigitalOrderButton.isEnabled = ReceetPOS.shared.isEnabled// turn the button on only if the integration is on
        sendDigitalOrderButton.alpha = ReceetPOS.shared.isEnabled ? 1.0 : 0.5
        
        sendDigitalOrderButton.clipsToBounds = true
        sendDigitalOrderButton.layer.cornerRadius = 8
        
        resetAuthCodeButton.isEnabled = ReceetPOS.shared.isEnabled// turn the button on only if the integration is on
        resetAuthCodeButton.alpha = ReceetPOS.shared.isEnabled ? 1.0 : 0.5
        resetAuthCodeButton.clipsToBounds = true
        resetAuthCodeButton.layer.cornerRadius = 8

        if let posID = ReceetPOS.shared.posID {
            posIDLabel.text = String(posID)
        }
        beaconIDLabel.text = ReceetPOS.shared.virtualBeaconID
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = self.gradientLayer(frame: self.headerView.frame, colors: [UIColor(red: 89.0/255.0, green: 194.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor,UIColor(red: 18.0/255.0, green: 112.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor], isVertical: true)
        self.headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension ViewController {
    func gradientLayer(frame: CGRect,colors: [CGColor],isVertical:Bool) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        if isVertical{
            //vertical gradient
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }else{
            //horizontal gradient
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        return gradientLayer
    }
}
