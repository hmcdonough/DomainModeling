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

class Job {
    var title : String
    var salary: Money
    var isPerHour : Bool
    
    init(t: String, m: Money, b: Bool) {
        title = t
        salary = m
        isPerHour = b
    }

    func calculateIncome(numHours: Int?) -> Double{
        if !isPerHour {
            return salary.amount
        } else if numHours != nil {
            return salary.amount * Double(numHours!)
        } else {
            return -1.0
        }
    }
    
    func raise(percent: Double) {
        salary.amount += percent / 100 * salary.amount
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

class Family {
    var members : [Person]
    
    init(people: [Person]?) {
        if people != nil {
            var isValid : Bool = false
            for peep in people! {
                if peep.age > 21 {
                    isValid = true
                }
            }
            if isValid {
                members = people!
            } else {
                members = []
            }
        } else {
            members = []
        }
    }
    
    func householdIncome() -> Double {
        var totalSalary : Double = 0.0
        for peep in members {
            if peep.job != nil {
                if peep.job!.isPerHour {
                    totalSalary += peep.job!.calculateIncome(2000)
                } else {
                    totalSalary += peep.job!.calculateIncome(nil)
                }
            }
        }
        return totalSalary
    }
    
    func haveChild(firstName: String, lastName: String) {
        if members.count > 0 {
            members.append(Person(first: firstName, last: lastName, howOld: 0, work: nil, sp: nil))
        }
    }
}

var m1 = Money(a: 5.0, c: Currency.USD)
var m2 = Money(a: 10.0, c: Currency.USD)
var m3 = Money(a: 10.0, c: Currency.GBP)
var m4 = Money(a: m1.add(m3), c: m1.currency)
var m5 = Money(a: 10.0, c: Currency.EUR)
var m6 = Money(a: 10.0, c: Currency.CAN)
print("MONEY TESTS")
print("add USD to USD: " + String(m1.add(m2)))
print("add GBP to USD: " + String(m1.add(m3)))
print("add GBP to USD, create new object" + String(m4))
print("add USD to GBP: " + String(m3.add(m1)))
print("add EUR to CAN: " + String(m6.add(m5)))
print("add CAN to EUR: " + String(m5.add(m6)))
print("sub EUR from USD: " + String(m2.sub(m5)))
print("sub USD from EUR: " + String(m5.sub(m2)))
print("sub GBP from USD: " + String(m1.sub(m3)))
print("sub USD from GBP: " + String(m3.sub(m1)))
print("sub EUR from CAN: " + String(m6.sub(m5)))
print("sub CAN from EUR: " + String(m5.sub(m6)))

print("---------------------------")
var j1 = Job(t: "Mall Cop", m: Money(a: 20000, c: Currency.USD ), b: false)
var j2 = Job(t: "Sales assistant", m:m1, b: true)
var j3 = Job(t: "Mall Owner", m: Money(a: 400000, c: Currency.USD ), b: false)
var j4 = Job(t: "Software Dev", m: Money(a: 60000, c: Currency.USD ), b: false)
var j5 = Job(t: "Tech Intern", m: Money(a: 25, c: Currency.USD ), b: true)

print("JOB TESTS")
print("calculate income for annual salary job w/ parameter: " + String(j1.calculateIncome(100)))
print("calculate income for annual salary job w/o parameter: " + String(j1.calculateIncome(nil))) //should be same as with
print("calculate income for hourly salary job w/o parameter: " + String(j2.calculateIncome(nil))) //should fail (i.e. return -1)
print("calculate income for hourly salary job w/ parameter: " + String(j2.calculateIncome(2000)))
j4.raise(5)
print("give 5% raise to annual: " + String(j4.salary.amount))
j5.raise(10)
print("give 10% raise to hourly: " + String(j5.salary.amount))

print("---------------------------")
var p1 = Person(first: "Paul", last: "Blart", howOld: 40, work: j1, sp: nil)
var p2 = Person(first: "John", last: "Doe", howOld: 30, work: j2, sp: nil)
var p3 = Person(first: "Jane", last: "Doe", howOld: 35, work: j3, sp: p2)
p2.spouse = p3
var p4 = Person(first: "Jack", last: "Blart", howOld: 40, work: nil, sp: nil)
var p5 = Person(first: "Jill", last: "Blart", howOld: 40, work: j5, sp: p4)
p4.spouse = p5
var p6 = Person(first: "Lil Jimmy", last: "Blart", howOld: 15, work: j2, sp: p3)
var p7 = Person(first: "Lil Jenna", last: "Blart", howOld: 17, work: j2, sp: p2)
var p8 = Person(first: "Lil Jovanovich", last: "Blart", howOld: 18, work: nil, sp: nil)

print("Person Tests")
print(p1.toString())
print(p2.toString())
print(p3.toString())
print(p4.toString())
print(p5.toString())

print(p6.toString())
print("Note, 15 year old Jimmy has no job or spouse, even though passed one")

print(p7.toString())
print("Note, 17 year old Jenna has a job but no spouse, even though passed one")

print(p8.toString())
print("Note, Jovanovich was not passed a spouse or job and the case was handled")

print("---------------------------")

var f1 = Family(people: [p1, p4, p5, p6, p7, p8])
var f2 = Family(people: [p2, p3])
var f3 = Family(people: nil)
var f4 = Family(people: [p6, p7, p8])


print("Family Tests")
print("F1 family size before having child: " + String(f1.members.count))
f1.haveChild("Paully", lastName: "Blart")
print("F1 family size after having child: " + String(f1.members.count))

print("John Doe + Jane Doe annual salary: " + String(p2.job!.calculateIncome(2000) + p3.job!.calculateIncome(2000)))
print("F2 (John + Jane) annual salary: " + String(f2.householdIncome()))

print("When given family with members equal to nil, family should be empty: " + String(f3.members.count))
print("When given family with members all under 21, family should be empty: " + String(f4.members.count))