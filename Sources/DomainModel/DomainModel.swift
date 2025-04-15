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
        "GBP": 0.8,
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
            let convertedOther = other.convert(newCurrency: self.currency)
            return Money(amount: self.amount + convertedOther.amount, currency: self.currency)
        }
    }
    
    public func subtract(_ other: Money) -> Money {
        if self.currency == other.currency {
            return Money(amount: self.amount - other.amount, currency: self.currency)
        } else {
            let convertedOther = other.convert(newCurrency: self.currency)
            return Money(amount: self.amount - convertedOther.amount, currency: self.currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
