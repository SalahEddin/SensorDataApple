//
//  ViewController.swift
//  Fiddle
//
//  Created by Salah Eddin Alshaal on 29/11/15.
//  Copyright © 2015 Salah Eddin Alshaal. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    //+++++++ Attributes +++++++//
    var session: WCSession!
    // accelerometer labels
    @IBOutlet weak var XAccelLabel: UILabel!
    @IBOutlet weak var YAccelLabel: UILabel!
    @IBOutlet weak var ZAccelLabel: UILabel!
    // Direction labels
    @IBOutlet weak var XDirLabel: UILabel!
    @IBOutlet weak var YDirLabel: UILabel!
    @IBOutlet weak var ZDirLabel: UILabel!
    
    @IBOutlet weak var ResultLabel: UILabel!
    //+++++++ OS Methods +++++++//
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //+++++++ user Methods +++++++//
    
    // if message from watch is recieved
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieve messages from watch
        /*self.xLabel.text = message["x"]! as? String
        self.yLabel.text = message["y"]! as? String
        self.zLabel.text = message["z"]! as? String*/
        dispatch_async(dispatch_get_main_queue(), {
            self.ResultLabel.text = message["static"]! as? String
            self.XAccelLabel.text = message[""]! as? String
        })
    }

}

