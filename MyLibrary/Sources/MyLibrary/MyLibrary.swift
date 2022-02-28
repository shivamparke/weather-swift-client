public class MyLibrary {
    private let weatherService: WeatherService

    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init(weatherService: WeatherService? = nil) {
        self.weatherService = weatherService ?? WeatherServiceImpl()
    }

    public func printTemperature(token: String, completion: @escaping (Int?) -> Void) {
        var returnValue = 0
        weatherService.callSecureEndpointWeather(token: token) { response in
            switch response {
            case let .failure(error):
                print(error)
                print("Well well well")

            case let .success(temperature):
                print(temperature)
                returnValue = temperature
                completion(returnValue)
            }
        }
        //return returnValue
    }

    public func printGreeting(token: String, completion: @escaping (String?) -> Void) {
        var returnValue = ""
        weatherService.callSecureEndpointHello(token: token) { response in
            switch response {
            case let .failure(error):
                print(error)
                print("Well well well")

            case let .success(greeting):
                print(greeting)
                returnValue = greeting
                completion(returnValue)
            }
        }
        //return returnValue
    }

    public func printToken(completion: @escaping (String?) -> Void) {
        var returnValue = ""
        weatherService.retrieveToken { response in
            switch response {
            case let .failure(error):
                print(error)
                print("Well well well")

            case let .success(token):
                print(token)
                returnValue = token
                completion(returnValue)
            }
        }
        //return returnValue
    }

    public func isLucky(_ number: Int, completion: @escaping (Bool?) -> Void) {
        // Check the simple case first: 3, 5 and 8 are automatically lucky.
        if number == 3 || number == 5 || number == 8 {
            completion(true)
            return
        }

        // Fetch the current weather from the backend.
        // If the current temperature, in Farenheit, contains an 8, then that's lucky.
        weatherService.getTemperature { response in
            switch response {
            case let .failure(error):
                print(error)
                completion(nil)

            case let .success(temperature):
                if self.contains(temperature, "8") {
                    completion(true)
                } else {
                    let isLuckyNumber = self.contains(temperature, "8")
                    completion(isLuckyNumber)
                }
            }
        }
    }

    /// Sample usage:
    ///   `contains(558, "8")` would return `true` because 588 contains 8.
    ///   `contains(557, "8")` would return `false` because 577 does not contain 8.
    private func contains(_ lhs: Int, _ rhs: Character) -> Bool {
        return String(lhs).contains(rhs)
    }
}
 
