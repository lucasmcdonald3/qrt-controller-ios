//
//  DataViewController.swift
//  QRT
//
//  Class that controls the control menu view controller.
//
//  Created by Lucas McDonald on 7/22/16.
//  Copyright © 2016 Lucas McDonald. All rights reserved.
//

import UIKit
import Foundation

class DataViewController: UIViewController {
    
    // variables to have entire scope of class
    var session = SSHConnection.init()
    var username = ""
    var ip = ""
    var password = ""

    // called when login is successful
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // recreates ssh session from login screen
        session = SSHConnection.init(username: username, ip: ip, password: password, connect: true)
        print(session.checkConnection())
        print(session.checkAuthorization())
        
        // keyboard dismisser
        let keyboardHide: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DataViewController.keyboardHide))
        view.addGestureRecognizer(keyboardHide)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // called from shutdown button
    @IBAction func shutDown(sender: UIButton) {
        session.sendCommand("sudo shutdown now")
    }
    
    // called from reboot button
    @IBAction func restart(sender: UIButton) {
        session.sendCommand("sudo reboot now")
    }
    
    // called from command field info button
    @IBAction func sendCommandInfo(sender: UIButton) {
        let alert = UIAlertController(title: "Command Line", message: "Enter a command to send to the Pi via command line. Multiple separate commands must be separated by a semicolon.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // command field text field
    @IBOutlet weak var sendCommandField: UITextField!
    
    // send command from keyboard
    @IBAction func sendCommandBox(sender: UITextField) {
        session.sendCommand(sendCommandField.text!)
    }
    
    // send command from send button
    @IBAction func sendCommandButton(sender: UIButton) {
        session.sendCommand(sendCommandField.text!)
        print(session.returnSSHOutput())
    }
    
    func sendMotorLength() {
        if Int(motorOneText.text!) == nil || Int(motorTwoText.text!) == nil {
            let alert = UIAlertController(title: "Enter a Number", message: "Please enter a number in integer or decimal form in each field.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        if Int(motorOneText.text!)! >= 0 && Int(motorOneText.text!)! <= 14 && Int(motorTwoText.text!)! >= 0 && Int(motorTwoText.text!)! <= 7 {
            session.sendCommand("python setMotorLengthSSH.py " + motorOneText.text! + " " + motorTwoText.text!)
        } else if !(Int(motorOneText.text!)! >= 0 && Int(motorOneText.text!)! <= 14) {
            let alert = UIAlertController(title: "Motor 1 Error", message: "Motor 1 must be set to a length between 0 and 14 inches.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if !(Int(motorTwoText.text!)! >= 0 && Int(motorTwoText.text!)! <= 7) {
            let alert = UIAlertController(title: "Motor 2 Error", message: "Motor 2 must be set to a length between 0 and 7 inches.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var motorOneText: UITextField!
    
    @IBAction func motorOneDisappear(sender: UITextField) {
        motorOneText.resignFirstResponder()
        
    }
    @IBOutlet weak var motorTwoText: UITextField!
    
    @IBAction func motorTwoDisappear(sender: AnyObject) {
        motorTwoText.resignFirstResponder()
    }
    
    @IBAction func motorOneNext(sender: UITextField) {
        motorOneText.resignFirstResponder()
        motorTwoText.becomeFirstResponder()
    }
    
    @IBAction func motorTwoGo(sender: UITextField) {
        
    }
    
    // function called when keyboard is dismissed
    func keyboardHide() {
        view.endEditing(true)
    }
    
}

