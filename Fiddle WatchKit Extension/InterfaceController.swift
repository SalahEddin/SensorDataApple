//
//  InterfaceController.swift
//  Fiddle WatchKit Extension
//
//  Created by Salah Eddin Alshaal on 29/11/15.
//  Copyright © 2015 Salah Eddin Alshaal. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    //+++++++ Attributes +++++++//
    let dirThreshold = 0.1
    var session: WCSession!
    let motionManager = CMMotionManager()
    // accelerometer labels
    @IBOutlet var XAccelLabel: WKInterfaceLabel!
    @IBOutlet var YAccelLabel: WKInterfaceLabel!
    @IBOutlet var ZAccelLabel: WKInterfaceLabel!
    
    // Direction labels
    @IBOutlet var XDirLabel: WKInterfaceLabel!
    @IBOutlet var YDirLabel: WKInterfaceLabel!
    @IBOutlet var ZDirLabel: WKInterfaceLabel!
    
    // stores previous accelerometer data value
    var accelHistory: [Double] = [0.0,0.0,0.0]
    
    //+++++++ OS Methods +++++++//
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //start a session for communication with iPhone
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
        }
        //initialise accelerometer history values
        accelHistory[0] = 0
        accelHistory[1] = 0
        accelHistory[2] = 0
        
        if (motionManager.accelerometerAvailable == true) {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                // ipdate the label with newest values
                self.XAccelLabel.setText(String(format: "%.2f", data!.acceleration.x))
                self.YAccelLabel.setText(String(format: "%.2f", data!.acceleration.y))
                self.ZAccelLabel.setText(String(format: "%.2f", data!.acceleration.z))
                // infer direction on each axis
                self.getAccelDirection(data!.acceleration.x,yAccVal: data!.acceleration.y,zAccVal: data!.acceleration.z)
            }
            //updates accelerometer every half a second
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        }
        else {
            self.XAccelLabel.setText("not available")
            self.YAccelLabel.setText("not available")
            self.ZAccelLabel.setText("not available")
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //+++++++ user Methods +++++++//
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieving message from iphone
        // self.mMessageLabel.setText(message["a"]! as? String)
    }
    
    @IBAction func sendStaticToiPhone() {
        if(WCSession.isSupported()){
            session.sendMessage(["static":"static message sent here"], replyHandler: nil, errorHandler: nil)
        }
    }
    @IBAction func sendDynamicToiPhone() {
        
    }
    // infers the direction by comparing the difference of accelerometer in half a second
    func getAccelDirection(xAccVal: Double,yAccVal: Double,zAccVal: Double){
        let xChange = xAccVal - accelHistory[0]
        let yChange = yAccVal - accelHistory[1]
        let zChange = zAccVal - accelHistory[2]
        // update history of accelerometer values
        accelHistory[0] = xAccVal
        accelHistory[1] = yAccVal
        accelHistory[2] = zAccVal
        
        var accelMsg: [String] = ["","",""]
        var dirMsg: [String] = ["","",""]
        
        if(xChange > dirThreshold){
            accelMsg[0] = "left"
        }
        else if(xChange < -dirThreshold){
            accelMsg[0] = "right"
        }
        else{
            accelMsg[0] = "NaN"
        }
        
        if(yChange > dirThreshold){
            accelMsg[1] = "down"
        }
        else if(yChange < -dirThreshold){
            accelMsg[1] = "up"
        }
        else{
            accelMsg[1] = "NaN"
        }
        
        if(zChange > dirThreshold){
            accelMsg[2] = "back"
        }
        else if(zChange < -dirThreshold){
            accelMsg[2] = "frwd"
        }
        else{
            accelMsg[2] = "NaN"
        }
        
        XDirLabel.setText( dirMsg[0] )
        YDirLabel.setText( dirMsg[1] )
        ZDirLabel.setText( dirMsg[2] )
        
        if(WCSession.isSupported()){
            session.sendMessage(["accelX":xAccVal], replyHandler: nil, errorHandler: nil)
            session.sendMessage(["accelY":yAccVal], replyHandler: nil, errorHandler: nil)
            session.sendMessage(["accelZ":zAccVal], replyHandler: nil, errorHandler: nil)
            session.sendMessage(["dirX":accelMsg[0]], replyHandler: nil, errorHandler: nil)
            session.sendMessage(["dirY":accelMsg[1]], replyHandler: nil, errorHandler: nil)
            session.sendMessage(["dirZ":accelMsg[2]], replyHandler: nil, errorHandler: nil)
        }
    }
}
