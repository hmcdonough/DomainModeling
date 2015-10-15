//
//  main.swift
//  domainModeling
//
//  Created by Harry McDonough on 10/14/15.
//  Copyright © 2015 Harrison McDonough. All rights reserved.
//

import Foundation

enum Currency {
    case USD
    case GBP
    case EUR
    case CAN
}

struct Money {
    var amount : Double
    var currency : Currency
    
    init(a: Double, c: Currency) {
        amount = a
        currency = c
    }
    
    init(c: Currency) {
        amount = 0
        currency = c
    }
    
    func convertToUSD(m : Money) -> Double {
        switch m.currency {
        case Currency.GBP:
            return m.amount * 2
        case Currency.EUR:
            return m.amount * 2 / 3
        case Currency.CAN:
            return m.amount * 4 / 5
        default:
            return m.amount
        }
    }
    
    func convertBack(c : Currency, am : Double) -> Double {
        switch c {
        case Currency.GBP:
            return am / 2
        case Currency.EUR:
            return am / 2 * 3
        case Currency.CAN:
            return am / 4 * 5
        default:
            return am
        }
    }

    func add(m : Money) -> Double {
        if m.currency == currency {
            return amount + m.amount
        } else {
            return convertBack(currency, am: convertToUSD(self) + convertToUSD(m))

        }
    }
    
    func sub(m : Money) -> Double {
        if m.currency == currency {
            return amount - m.amount
        } else {
            return convertBack(currency, am: convertToUSD(self) - convertToUSD(m))
        }
    }
}

var m1 = Money(a: 5.0, c: Currency.USD)
var m2 = Money(a: 10.0, c: Currency.USD)
var m3 = Money(a: 10.0, c: Currency.GBP)
print(m1.add(m2))
print(m1.add(m3)) //should give 25 usd.
var m4 = Money(a: m1.add(m3), c: m1.currency)
print(m4)

class Person {
    let firstName : String
    let lastName : String
    let age : Int
    var job : Job?
    var spouse : Person?
    
    init(first: String, last: String, howOld: Int) {
        firstName = first
        lastName = last
        age = howOld
    }
    
    func toString() -> String {
        var str = "Name: " + firstName + " " + lastName + " | age: " + String(age)
        if job != nil {
            str += " | job: " + job!.name
        }
        if spouse != nil {
            str += " | spouse: " + spouse!.firstName + " " + spouse!.lastName
        }
        return str
    }
}

class Job {
    let name : String
    
    init(jobName: String) {
        name = jobName
    }
}
