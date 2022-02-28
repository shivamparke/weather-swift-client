import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {

    func testHello() throws {
        // Given
        let myLibrary = MyLibrary()
        let expectation1 = XCTestExpectation(description: "We asked about the access token and heard back 🎄")
        let expectation2 = XCTestExpectation(description: "We asked about the greeting and heard back 🎄")
        var retrievedToken: String?
        var returnedGreeting: String?

        // When
        myLibrary.printToken { token in
            retrievedToken = token
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 5)

        myLibrary.printGreeting(token: retrievedToken ?? "") { greeting in
            returnedGreeting = greeting
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 5)

        // Then
        XCTAssertNotNil(returnedGreeting)
        XCTAssert(returnedGreeting == "Hello, from Shivam")
    }

    func testWeather() throws {
        // Given
        let myLibrary = MyLibrary()
        let expectation1 = XCTestExpectation(description: "We asked about the access token and heard back 🎄")
        let expectation2 = XCTestExpectation(description: "We asked about the greeting and heard back 🎄")
        var retrievedToken: String?
        var returnedTemperature: Int?

        // When
        myLibrary.printToken { token in
            retrievedToken = token
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 5)

        myLibrary.printTemperature(token: retrievedToken ?? "") { temp in
            returnedTemperature = temp
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 5)

        // Then
        XCTAssertNotNil(returnedTemperature)
        // Hardcoded JSON temperature is 45.14
        XCTAssert(returnedTemperature == 45)
    }


    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 8
        let expectation = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: true
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 0
        let expectation = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: true,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 and heard back 🌲")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() throws {
        // Given
        let mockWeatherService = MockWeatherService(
            shouldSucceed: false,
            shouldReturnTemperatureWithAnEight: false
        )

        let myLibrary = MyLibrary(weatherService: mockWeatherService)
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 but the service call failed 🤖💩")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

}

