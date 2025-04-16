import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
//    static var allTests = [
//        ("testCreateSalaryJob", testCreateSalaryJob),
//        ("testCreateHourlyJob", testCreateHourlyJob),
//        ("testSalariedRaise", testSalariedRaise),
//        ("testHourlyRaise", testHourlyRaise),
//    ]
    
    // extra credit tests
    
    func testJobTitleChange() {
        let job = Job(title: "Engineer", type: Job.JobType.Salary(10000))
        XCTAssert(job.title == "Engineer")
        job.title = "Manager"
        XCTAssert(job.title == "Manager")
    }
    
    func testZeroHoursIncome() {
        let hourlyJob = Job(title: "Cashier", type: Job.JobType.Hourly(12.0))
        XCTAssert(hourlyJob.calculateIncome(0) == 0)
        
        let salaryJob = Job(title: "Manager", type: Job.JobType.Salary(60000))
        XCTAssert(salaryJob.calculateIncome(0) == 60000)
    }
    
    func testNegativeHoursIncome() {
        let hourlyJob = Job(title: "Barista", type: Job.JobType.Hourly(20.0))
        XCTAssert(hourlyJob.calculateIncome(-5) == -100)
    }
    
    func testNegativeRaiseAmount() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        
        job.raise(byAmount: -10.0)
        XCTAssert(job.calculateIncome(10) == 50)
    }
    
    func testZeroJobIncome() {
        let job = Job(title: "Volunteer", type: Job.JobType.Salary(0))
        XCTAssert(job.calculateIncome(40) == 0)
        
        job.raise(byAmount: 100.0)
        XCTAssert(job.calculateIncome(40) == 100)
    }
    
    func testZeroSalaryRaise() {
        let job1 = Job(title: "Chef", type: Job.JobType.Salary(50000))
        XCTAssert(job1.calculateIncome(40) == 50000)
        
        job1.raise(byAmount: 0.0)
        XCTAssert(job1.calculateIncome(40) == 50000)
    }
    
    func testZeroHourlyRaise() {
        let job2 = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job2.calculateIncome(10) == 150)
        
        job2.raise(byAmount: 0.0)
        XCTAssert(job2.calculateIncome(10) == 150)
    }
    
    func testMultipleRaises() {
        let job = Job(title: "Chef", type: Job.JobType.Hourly(30.0))
        
        job.raise(byAmount: 5.0)
        job.raise(byAmount: 0.1)
        job.raise(byAmount: -2.0)
        job.raise(byAmount: 10.0)
        
        XCTAssert(job.calculateIncome(10) == 431)
    }
        
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        ("testJobTitleChange", testJobTitleChange),
        ("testZeroHoursIncome", testZeroHoursIncome),
        ("testNegativeHoursIncome", testNegativeHoursIncome),
        ("testNegativeRaiseAmount", testNegativeRaiseAmount),
        ("testZeroJobIncome", testZeroJobIncome),
        ("testZeroSalaryRaise", testZeroSalaryRaise),
        ("testZeroHourlyRaise", testZeroHourlyRaise),
        ("testMultipleRaises", testMultipleRaises)
    ]
}
