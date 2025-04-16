struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    static let validCurrencies: [String] = ["USD", "GBP", "EUR", "CAN"]
    static let exchangeRates: [String: Double] = [
        "USD": 1.0,
        "GBP": 0.5,
        "EUR": 1.5,
        "CAN": 1.25
    ]
    
    init(amount: Int, currency: String) {
        self.amount = amount
        if currency.count == 3 && Money.validCurrencies.contains(currency) {
            self.currency = currency
        } else {
            self.currency = "USD"
        }
    }
    
    public func convert(_ newCurrency: String) -> Money {
        guard Money.validCurrencies.contains(newCurrency) else {
            return self
        }
        
        guard newCurrency != self.currency else {
            return self
        }
        
        guard let fromRate = Money.exchangeRates[self.currency],
              let toRate = Money.exchangeRates[newCurrency] else {
            return self
        }
        
        let amountInUSD: Double = Double(self.amount) / fromRate
        let amountInNewCurrency: Double = amountInUSD * toRate
        let roundedAmount: Int = Int(amountInNewCurrency.rounded())
        
        return Money(amount: roundedAmount, currency: newCurrency)
    }
    
    public func add(_ other: Money) -> Money {
        if self.currency == other.currency {
            return Money(amount: self.amount + other.amount, currency: self.currency)
        } else {
            let convertedSelf = self.convert(other.currency)
            return Money(amount: convertedSelf.amount + other.amount, currency: other.currency)
        }
    }
    
    public func subtract(_ other: Money) -> Money {
        if self.currency == other.currency {
            return Money(amount: self.amount - other.amount, currency: self.currency)
        } else {
            let convertedSelf = self.convert(other.currency)
            return Money(amount: convertedSelf.amount - other.amount, currency: other.currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title: String
    var type: JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourlyRate):
            return Int((hourlyRate * Double(hours)).rounded())
        case .Salary(let salary):
            return Int(salary)
        }
    }
    
    public func raise(byAmount: Double) -> Void {
        switch type {
        case .Hourly(var hourlyRate):
            hourlyRate += byAmount
            self.type = .Hourly(hourlyRate)
        case .Salary(var salary):
            salary += UInt(byAmount.rounded())
            self.type = .Salary(salary)
        }
    }
    
    public func raise(byPercent: Double) -> Void {
        switch type {
        case .Hourly(let hourlyRate):
            let newHourlyRate = hourlyRate * (1 + byPercent)
            self.type = .Hourly(newHourlyRate)
        case .Salary(let salary):
            let newSalary = Double(salary) * (1 + byPercent)
            self.type = .Salary(UInt(newSalary.rounded()))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    
    private var _job: Job?
    var job: Job? {
        get {
            return _job
        }
        set {
            if age >= 16 {
                _job = newValue
            }
        }
    }
    
    private var _spouse: Person?
    var spouse: Person? {
        get {
            return _spouse
        }
        set {
            if age >= 18 {
                _spouse = newValue
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job?.type)) spouse:\(String(describing: spouse?.firstName))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        guard spouse1.spouse == nil && spouse2.spouse == nil else {
            fatalError("At least one spouse is already married")
        }
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members = [spouse1, spouse2]
    }
    
    public func haveChild(_ child: Person) -> Bool {
        for member in members {
            if member.spouse != nil && member.age > 21 {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    public func householdIncome() -> Int {
        var householdIncome = 0
        for member in members {
            if let job = member.job {
                let annualIncome = job.calculateIncome(2000)
                householdIncome += annualIncome
            }
        }
        return householdIncome
    }
}
