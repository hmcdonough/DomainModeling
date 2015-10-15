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
var m4 = Money(a: m1.add(m3), c: m1.currency) //identical test - 25 USD
print(m4)

class Job {
    var title : String
    var salary: Money
    var isPerHour : Bool
    
    init(t: String, m: Money, b: Bool) {
        title = t
        salary = m
        isPerHour = b
    }
//    •calculateIncome, which should accept a number of
//    hours worked this year
//    if this is a per-year salary, then ignore the hours
//    •raise, which will bump up the salary by the passed percentage
    func calculateIncome(numHours: Int?) -> Double{
        if !isPerHour {
            return salary.amount
        } else if numHours != nil {
            return salary.amount * Double(numHours!)
        } else {
            return -1.0
        }
    }
}

class Person {
    let firstName : String
    let lastName : String
    let age : Int
    var job : Job?
    var spouse : Person?
    
    init(first: String, last: String, howOld: Int, work: Job?, sp: Person?) {
        firstName = first
        lastName = last
        age = howOld
        job = nil
        spouse = nil
        
        if howOld > 17 && sp != nil {
            spouse = sp!
        }
        if howOld > 15 && work != nil {
            job = work!
        }
    }
    
    func toString() -> String {
        var str = "Name: " + firstName + " " + lastName + " | age: " + String(age)
        if job != nil {
            str += " | job: " + job!.title
        } else {
            str += " | job: None"
        }
        if spouse != nil {
            str += " | spouse: " + spouse!.firstName + " " + spouse!.lastName
        } else {
            str += " | spouse: None"
        }
        return str
    }
}

var p1 = Person(first: "Paul", last: "Blart", howOld: 40, work: Job(t: "Mall Cop", m: Money(a: 20000, c: Currency.USD ), b: false), sp: nil)
print(p1.toString())
