//
//  ViewController.swift
//  SupremeCommander
//
//  Created by panic on 18/11/2015.
//  Copyright © 2015 Panayiotis Andreou. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    ///////////////////////////////////////
    ////////    Attributes and Properties
    //
    var session: WCSession!
    @IBOutlet weak var mResultLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    //
    ///////////////////////////////////////
    
    //////////////////////////////////////
    ////////    Methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        }
    }
    // mapped to static button
    @IBAction func sendMessageToWatch(sender: AnyObject) {
        //send message to watch
        session.sendMessage(["a":"hello"], replyHandler: nil, errorHandler: nil)
    }
    // if message from watch is recieved
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieve messages from watch
        self.mResultLabel.text = message["b"]! as? String
        /*self.xLabel.text = message["x"]! as? String
        self.yLabel.text = message["y"]! as? String
        self.zLabel.text = message["z"]! as? String*/
        dispatch_async(dispatch_get_main_queue(), {
            self.mResultLabel.text = message["b"]! as? String
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    //////////////////////////////////////
}

