import Alamofire

public protocol WeatherService {
    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void)
    func retrieveToken(completion: @escaping (_ response: Result<String /* Token */, Error>) -> Void)
    func callSecureEndpointHello(token: String, completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void)
    func callSecureEndpointWeather(token: String, completion: @escaping (_ response: Result<Int /* Greeting */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let credentials = Login(username: "shivam", password: "abcd1234")
    let url_auth = "http://localhost:3000/v1/auth"
    let url_hello = "http://localhost:3000/v1/hello"
    let url_weather = "http://localhost:3000/v1/weather"
    let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=<INSERT YOUR API KEY HERE>"

    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: WeatherFirst.self) { response in
            switch response.result {
            case let .success(weather):
                let temperature = weather.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func retrieveToken(completion: @escaping (_ response: Result<String /* Token */, Error>) -> Void) {
        AF.request(url_auth, method: .post, parameters: credentials).validate(statusCode: 200..<300).responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case let .success(authResponse):
                let retrieved_token = authResponse.access_token
                completion(.success(retrieved_token))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func callSecureEndpointHello(token: String, completion: @escaping (_ response: Result<String /* Greeting */, Error>) -> Void) {
        let headerString = "Bearer " + token

        let myHeaders: HTTPHeaders = [
            "Authorization": headerString
        ]

        AF.request(url_hello, method: .get, headers: myHeaders).validate(statusCode: 200..<300).responseDecodable(of: Hello.self) { response in
            switch response.result {
            case let .success(helloResponse):
                let returnedGreeting = helloResponse.greeting
                completion(.success(returnedGreeting))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func callSecureEndpointWeather(token: String, completion: @escaping (_ response: Result<Int /* Greeting */, Error>) -> Void) {
        let headerString = "Bearer " + token

        let myHeaders: HTTPHeaders = [
            "Authorization": headerString
        ]

        AF.request(url_weather, method: .get, headers: myHeaders).validate(statusCode: 200..<300).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case let .success(weatherResponse):
                let temperature = weatherResponse.main.temp
                let temperatureAsInteger = Int(temperature)
                completion(.success(temperatureAsInteger))

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

}

private struct WeatherFirst: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}

struct Login: Encodable {
    let username: String
    let password: String
}

private struct AuthResponse: Decodable {
    let access_token: String
    let expires: String

    enum CodingKeys: String, CodingKey {
        case access_token = "access-token"
        case expires = "expires"
    }
}

private struct Hello: Decodable {
    let greeting: String
}





// MARK: - Welcome
struct Welcome: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int
}

// MARK: - Coord
struct Coord: Decodable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
