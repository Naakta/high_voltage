//
//  HVCalculator.swift
//  High_Voltage
//
//  Created by Doug Wagner on 3/27/18.
//  Copyright © 2018 Doug Wagner. All rights reserved.
//

import Foundation

class HVCalculator {
    var myWatts = 0.0
    var myVolts = 0.0
    var myAmps = 0.0
    var myOhms = 0.0
    var wattCheck = false
    var voltCheck = false
    var ampCheck = false
    var ohmCheck = false
    var numberDictionary = [String: Double]()
    
    
    func updateThisVariable(string: String, with number: Double) {
        if string == "Watts" {
            myWatts = number
            wattCheck = true
        } else if string == "Volts" {
            myVolts = number
            voltCheck = true
        } else if string == "Amps" {
            myAmps = number
            ampCheck = true
        } else if string == "Ohms" {
            myOhms = number
            ohmCheck = true
        }
    }
    
    func fillNumberDictionary() {
        numberDictionary["WattsCell"] = myWatts
        numberDictionary["VoltsCell"] = myVolts
        numberDictionary["AmpsCell"] = myAmps
        numberDictionary["OhmsCell"] = myOhms
    }
    
    func fillPopArray() -> [String] {
        var returnArray = [String]()
        if !wattCheck {
            returnArray.append("Watts")
        }
        if !voltCheck {
            returnArray.append("Volts")
        }
        if !ampCheck {
            returnArray.append("Amps")
        }
        if !ohmCheck {
            returnArray.append("Ohms")
        }
        
        return returnArray
    }
    
    func fillTableArray(array: [String]) -> [String] {
        var returnArray = array
        if !wattCheck {
            returnArray.append("WattsCell")
        }
        if !voltCheck {
            returnArray.append("VoltsCell")
        }
        if !ampCheck {
            returnArray.append("AmpsCell")
        }
        if !ohmCheck {
            returnArray.append("OhmsCell")
        }
        
        return returnArray
    }
    
    func readyToEquate() -> Bool {
        if wattCheck && voltCheck {
            findMyAmps(watts: myWatts, volts: myVolts)
            findMyOhms(watts: myWatts, volts: myVolts)
            return true
        } else if wattCheck && ampCheck {
            findMyVolts(watts: myWatts, amps: myAmps)
            findMyOhms(watts: myWatts, amps: myAmps)
            return true
        } else if wattCheck && ohmCheck {
            findMyVolts(watts: myWatts, ohms: myOhms)
            findMyAmps(watts: myWatts, ohms: myOhms)
            return true
        } else if voltCheck && ampCheck {
            findMyWatts(volts: myVolts, amps: myAmps)
            findMyOhms(volts: myVolts, amps: myAmps)
            return true
        } else if voltCheck && ohmCheck {
            findMyAmps(volts: myVolts, ohms: myOhms)
            findMyWatts(volts: myVolts, ohms: myOhms)
            return true
        } else if ampCheck && ohmCheck {
            findMyWatts(amps: myAmps, ohms: myOhms)
            findMyVolts(amps: myAmps, ohms: myOhms)
            return true
        }
        return false
    }
    
    func findMyWatts(volts: Double? = nil, amps: Double? = nil, ohms: Double? = nil) {
        if volts == nil {
            myWatts = pow(amps!, 2) * ohms!
        } else if amps == nil {
            myWatts = pow(volts!, 2) / ohms!
        } else {
            myWatts = volts! * amps!
        }
    }
    
    func findMyVolts(watts: Double? = nil, amps: Double? = nil, ohms: Double? = nil) {
        if watts == nil {
            myVolts = amps! * ohms!
        } else if amps == nil {
            myVolts = sqrt(watts! * ohms!)
        } else {
            myVolts = watts! / amps!
        }
    }
    
    func findMyAmps(watts: Double? = nil, volts: Double? = nil, ohms: Double? = nil) {
        if watts == nil {
            myAmps = volts! / ohms!
        } else if volts == nil {
            myAmps = sqrt(watts! / ohms!)
        } else {
            myAmps = watts! / volts!
        }
    }
    
    func findMyOhms(watts: Double? = nil, volts: Double? = nil, amps: Double? = nil) {
        if watts == nil {
            myOhms = volts! / amps!
        } else if volts == nil {
            myOhms = watts! / pow(amps!, 2)
        } else {
            myOhms = pow(volts!, 2) / watts!
        }
    }
}
