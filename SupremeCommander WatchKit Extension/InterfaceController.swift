//
//  InterfaceController.swift
//  SupremeCommander WatchKit Extension
//
//  Created by panic on 18/11/2015.
//  Copyright © 2015 Panayiotis Andreou. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session: WCSession!
    let motionManager = CMMotionManager()
    
    @IBOutlet var mMessageLabel: WKInterfaceLabel!
    @IBOutlet var xLabel: WKInterfaceLabel!
    @IBOutlet var yLabel: WKInterfaceLabel!
    @IBOutlet var zLabel: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if(WCSession.isSupported()){
            self.session = WCSession.defaultSession()
            self.session.delegate = self
            self.session.activateSession()
            session.sendMessage(["b":"Session started"], replyHandler: nil, errorHandler: nil)
        }
        
        if (motionManager.accelerometerAvailable == true) {
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                self.xLabel.setText(String(format: "%.2f", data!.acceleration.x))
                self.yLabel.setText(String(format: "%.2f", data!.acceleration.y))
                self.zLabel.setText(String(format: "%.2f", data!.acceleration.z))
                self.session.sendMessage(["x":String(format: "%.2f", data!.acceleration.x)], replyHandler: nil, errorHandler: nil)
                self.session.sendMessage(["y":String(format: "%.2f", data!.acceleration.y)], replyHandler: nil, errorHandler: nil)
                self.session.sendMessage(["z":String(format: "%.2f", data!.acceleration.z)], replyHandler: nil, errorHandler: nil)
            }
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        }
        else {
            self.xLabel.setText("not available")
            self.yLabel.setText("not available")
            self.zLabel.setText("not available")
        }

    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        // stop updating accel values
        motionManager.stopAccelerometerUpdates()
    }
    
    @IBAction func sendMessage() {
        if(WCSession.isSupported()){
            session.sendMessage(["b":"goodBye"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBAction func sendHeartRate() {
        // create an instance of CHeart
        if(WCSession.isSupported()){
            session.sendMessage(["b":"goodBye"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        //recieving message from iphone
        self.mMessageLabel.setText(message["a"]! as? String)
    }
}
