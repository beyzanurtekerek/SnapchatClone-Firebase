//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Beyza Nur Tekerek on 23.09.2024.
//

import UIKit


class SnapViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap : Snap?
    var selectedTime : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let time = selectedTime {
            timeLabel.text = "Time left: \(time)"
        }
        

    }

    
    
    
}
