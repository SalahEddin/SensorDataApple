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
    // static message label
    @IBOutlet weak var ResultLabel: UILabel!
    // messages dictionay
    var wmessage: [String: String] = [
        "static"    : "not set"     ,
        "accelX"    : "not set"     ,
        "accelY"    : "not set"     ,
        "accelZ"    : "not set"     ,
        "dirX"      : "not set"     ,
        "dirY"      : "not set"     ,
        "dirZ"      : "not set"
    ]
    
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
        /*
        1- check if the message of this "port" dictionary key is recieved, the set the local dictionary key to it, else
        2- set it from UI text
        TODO include better handling if empty
        */
        if let msg = message["static"] {
            self.wmessage["static"] = (msg as! String)
        } else {
            self.wmessage["static"] = self.ResultLabel.text
        }
        ////// acceleration
        if let msg = message["accelX"] {
            self.wmessage["accelX"] = (msg as! String)
        } else {
            self.wmessage["accelX"] = self.XAccelLabel.text
        }
        if let msg = message["accelY"] {
            self.wmessage["accelY"] = (msg as! String)
        } else {
            self.wmessage["accelY"] = self.YAccelLabel.text
        }
        if let msg = message["accelZ"] {
            self.wmessage["accelZ"] = (msg as! String)
        } else {
            self.wmessage["accelZ"] = self.ZAccelLabel.text
        }
        ////// direction
        if let msg = message["dirX"] {
            self.wmessage["dirX"] = (msg as! String)
        } else {
            self.wmessage["dirX"] = self.XDirLabel.text
        }
        if let msg = message["dirY"] {
            self.wmessage["dirY"] = (msg as! String)
        } else {
            self.wmessage["dirY"] = self.YDirLabel.text
        }
        if let msg = message["dirZ"] {
            self.wmessage["dirZ"] = (msg as! String)
        } else {
            self.wmessage["dirZ"] = self.ZDirLabel.text
        }
        
        
        dispatch_async(dispatch_get_main_queue(), {
            self.ResultLabel.text = self.wmessage["static"]!
            self.XAccelLabel.text = self.wmessage["accelX"]!
            self.YAccelLabel.text = self.wmessage["accelY"]!
            self.ZAccelLabel.text = self.wmessage["accelZ"]!
            
            self.XDirLabel.text = self.wmessage["dirX"]!
            self.YDirLabel.text = self.wmessage["dirY"]!
            self.ZDirLabel.text = self.wmessage["dirZ"]!
        })
    }
}

