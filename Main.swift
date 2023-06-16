import Foundation
import FoundationNetworking

class WeatherData {
    // set the api key and the base url
    internal var apiKey: String
    internal var baseUrl: String

    // initializer self. is like this.
    init(apiKey: String, baseUrl: String) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
    }

    // gets the weather data from the base url using the access key
    internal func getWeatherData(city: String) throws -> String? {
        let urlString = baseUrl + "?access_key=" + apiKey + "&query=" + city
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let responseData = String(data: data, encoding: .utf8)
                return responseData
            }
        }
        return nil
    }

}

// currentWeatherData class child class to WeatherData
class CurrentWeatherData: WeatherData {
    // overrides the init from the parent class
    override init(apiKey: String, baseUrl: String) {
        super.init(apiKey: apiKey, baseUrl: baseUrl)
    }

    // get the temperature
    func getTemperature(jsonResponse: String) -> Double {
        // set the startIndex to the upperBound of temperature
        if let startIndex = jsonResponse.range(of: "\"temperature\":")?.upperBound {
            // set the end Index
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            // get the string 
            let temperatureString = String(jsonResponse[startIndex..<commaIndex])
            // return the string
            return Double(temperatureString) ?? Double.nan
        }
        // return nan if it doesn't work
        return Double.nan
    }

    // similar to above but with windSpeed
    func getWindSpeed(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"wind_speed\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let windSpeed = String(jsonResponse[startIndex..<commaIndex])
            return Double(windSpeed) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with precipitation
    func getPrecipitation(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"precip\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let precipitation = String(jsonResponse[startIndex..<commaIndex])
            return Double(precipitation) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with humidity
    func getHumidity(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"humidity\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let humidity = String(jsonResponse[startIndex..<commaIndex])
            return Double(humidity) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with pressure
    func getPressure(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"pressure\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let pressure = String(jsonResponse[startIndex..<commaIndex])
            return Double(pressure) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with cloudCover
    func getCloudCover(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"cloudcover\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let cloudCover = String(jsonResponse[startIndex..<commaIndex])
            return Double(cloudCover) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with uvLevel just adds an if statement as well
    func getUvLevel(jsonResponse: String) -> String {
        if let startIndex = jsonResponse.range(of: "\"uv_index\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let uvLevelStr = String(jsonResponse[startIndex..<commaIndex])
            if let uvLevel = Int(uvLevelStr) {
                if uvLevel > 5 {
                    return "high! Put on sunscreen!"
                } else if uvLevel > 2 {
                    return "moderate: Sunscreen is recommended"
                } else {
                    return "low: Sunscreen is uneeded"
                }
            }
        }
        return ""
    }

    // similar to above but with visibility
    func getVisibility(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"visibility\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let visibility = String(jsonResponse[startIndex..<commaIndex])
            return Double(visibility) ?? Double.nan
        }
        return Double.nan
    }

    // similar to above but with windDir
    func getWindDir(jsonResponse: String) -> String {
        if let startIndex = jsonResponse.range(of: "\"wind_degree\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let windDir = String(jsonResponse[startIndex..<commaIndex])
            if let degrees = Double(windDir) {
                // finds the actual direction not just degrees
                if degrees >= 337.5 || degrees < 22.5 {
                    return "Northern"
                } else if degrees >= 22.5 && degrees < 67.5 {
                    return "Northeastern"
                } else if degrees >= 67.5 && degrees < 112.5 {
                    return "Eastern"
                } else if degrees >= 112.5 && degrees < 157.5 {
                    return "Southeastern"
                } else if degrees >= 157.5 && degrees < 202.5 {
                    return "Southern"
                } else if degrees >= 202.5 && degrees < 247.5 {
                    return "Southwestern"
                } else if degrees >= 247.5 && degrees < 292.5 {
                    return "Western"
                } else {
                    return "Northwestern"
                }
            }
        }
        return ""
    }

    // similar to above but with location
    func getLocation(jsonResponse: String) -> String {
        var city = ""
        var country = ""
        var region = ""
        
        if let startIndex = jsonResponse.range(of: "\"name\":")?.lowerBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let adjustedStartIndex = jsonResponse.index(startIndex, offsetBy: 8)
            let adjustedEndIndex = jsonResponse.index(commaIndex, offsetBy: -1)
            city = String(jsonResponse[adjustedStartIndex..<adjustedEndIndex])
        }

        if let startIndex = jsonResponse.range(of: "\"country\":")?.lowerBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let adjustedStartIndex = jsonResponse.index(startIndex, offsetBy: 11)
            let adjustedEndIndex = jsonResponse.index(commaIndex, offsetBy: -1)
            country = String(jsonResponse[adjustedStartIndex..<adjustedEndIndex])
        }

        if let startIndex = jsonResponse.range(of: "\"region\":")?.lowerBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let adjustedStartIndex = jsonResponse.index(startIndex, offsetBy: 10)
            let adjustedEndIndex = jsonResponse.index(commaIndex, offsetBy: -1)
            region = String(jsonResponse[adjustedStartIndex..<adjustedEndIndex])
        }

        return "\(city), \(region), \(country)"
    }

    // similar to above but with time
    func getTime(jsonResponse: String) -> String {
        if let startIndex = jsonResponse.range(of: "\"localtime\":")?.lowerBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let adjustedStartIndex = jsonResponse.index(startIndex, offsetBy: 13)
            let adjustedEndIndex = jsonResponse.index(commaIndex, offsetBy: -1)
            let time = String(jsonResponse[adjustedStartIndex..<adjustedEndIndex])
            return time
        }
        return ""
    }

    // similar to above but with weather Description
    func getDescription(jsonResponse: String) -> String {
        if let startIndex = jsonResponse.range(of: "\"weather_descriptions\":")?.lowerBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let adjustedStartIndex = jsonResponse.index(startIndex, offsetBy: 25)
            let adjustedEndIndex = jsonResponse.index(commaIndex, offsetBy: -2)
            let description = String(jsonResponse[adjustedStartIndex..<adjustedEndIndex])
            return description
        }
        return ""
    }

    // similar to above but with feelsLikeTemperature
    func getFeelsLikeTemperature(jsonResponse: String) -> Double {
        if let startIndex = jsonResponse.range(of: "\"feelslike\":")?.upperBound {
            let commaIndex = jsonResponse[startIndex...].firstIndex(of: ",") ?? jsonResponse.endIndex
            let feelsLikeString = String(jsonResponse[startIndex..<commaIndex])
            return Double(feelsLikeString) ?? Double.nan
        }
        return Double.nan
    }
}

class User {
    // fields
    private var username: String
    private var password: String
    private var email: String?

    // constructor
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // multiple methods to get the different data types
    func getUsername() -> String {
        return username
    }

    func getPassword() -> String {
        return password
    }

    func getEmail() -> String? {
        return email
    }

    func setEmail(email: String) {
        self.email = email
    }
}


class UserSystem {
    // create the users list
    private var users: [String: User]
    // set the data set file name
    private let userDataFile = "users.txt"

    // load the file data
    private func loadUserData() {
        do {
            let fileURL = try getFileURL()
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = fileContent.components(separatedBy: .newlines)

            for line in lines {

                let parts = line.components(separatedBy: ",")
                if parts.count == 3 {
                    let username = parts[0]
                    let password = parts[1]
                    let user = User(username: username, password: password)
                    users[username] = user
                }
            }
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
        }
    }

    // method to save the user data 
    private func saveUserData() {
        let fileURL = try! getFileURL()
        var fileContent = ""
        
        // see's all the usernames in users list
        for (username, user) in users {
            // gets ready to append to the fileContent
            let password = user.getPassword()
            let email = user.getEmail() ?? ""
            let line = "\(username),\(password),\(email)\n"
            fileContent.append(line)
        }
        
        do {
            // writes to the file
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }

    // get the file's URL
    private func getFileURL() throws -> URL {
        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectory.appendingPathComponent(userDataFile)
    }

    // initializer
    init() {
        users = [String: User]()
        loadUserData()
    }

    // add the user method
    func addUser(username: String, password: String) {
        let user = users[username]
        if user == nil {
            let newUser = User(username: username, password: password)
            users[username] = newUser
        }
        saveUserData()
    }

    // password check method
    func authenticateUser(username: String, password: String) -> Bool {
        if let user = users[username] {
            return user.getPassword() == password
        }
        return false
    }
}


// struct acts as the main class
struct WeatherExample {
    // api keys to access the server
    private static let WEATHER_API_KEY = "403850bf40ca68508d00db1ba3507123"
    private static let EMAIL_API_KEY = "45B55A71ECD2C835E3A7CFFD1B122A17ABFC8902E1576DFF0E6F9C9B173A1031590AB51C19D471768F4C74EC596AB0BE"
    // base URL for weatherstack
    private static let BASE_URL = "http://api.weatherstack.com/"

    // read the input file and separate it into different values
    private static func readCustomInfoFromFile(filePath: String) -> [String]? {
        do {
            let file = try String(contentsOfFile: filePath)
            let customInfo = file.components(separatedBy: .newlines)
            return customInfo
        } catch {
            print("Error reading custom information file: \(error)")
        }
        return nil
    }

    static func main() {
        // Read custom information from file
        if let customInfo = readCustomInfoFromFile(filePath: "input.txt") {
            // if there is an incorrect amount it displays invalid
            if customInfo.count < 4 {
                print("Invalid custom information file.")
                return
            }

            // set all the answers
            let username = customInfo[0]
            let password = customInfo[1]
            let city = customInfo[2]

            let userSystem = UserSystem()
            // add the user and authenticate to see if the password is correct
            userSystem.addUser(username: username, password: password)
            if userSystem.authenticateUser(username: username, password: password) {
                print("Authentication successful for user: \(username)")
                print("Welcome, \(username)!")
                print()

                // set the current weather data object.
                let currentWeatherData = CurrentWeatherData(apiKey: WEATHER_API_KEY, baseUrl: BASE_URL + "current")
                // try to get all the info needed
                do {
                    if let currentJsonResponse = try currentWeatherData.getWeatherData(city: city) {
                        let currentTemperature = currentWeatherData.getTemperature(jsonResponse: currentJsonResponse)
                        let currentFeelsLikeTemperature = currentWeatherData.getFeelsLikeTemperature(jsonResponse: currentJsonResponse)
                        let location = currentWeatherData.getLocation(jsonResponse: currentJsonResponse)
                        let time = currentWeatherData.getTime(jsonResponse: currentJsonResponse)
                        let weather = currentWeatherData.getDescription(jsonResponse: currentJsonResponse)
                        let windSpeed = currentWeatherData.getWindSpeed(jsonResponse: currentJsonResponse)
                        let windDir = currentWeatherData.getWindDir(jsonResponse: currentJsonResponse)
                        let precip = currentWeatherData.getPrecipitation(jsonResponse: currentJsonResponse)
                        let humidity = currentWeatherData.getHumidity(jsonResponse: currentJsonResponse)
                        let pressure = currentWeatherData.getPressure(jsonResponse: currentJsonResponse)
                        let visibility = currentWeatherData.getVisibility(jsonResponse: currentJsonResponse)
                        let cloudCover = currentWeatherData.getCloudCover(jsonResponse: currentJsonResponse)
                        let uvLevel = currentWeatherData.getUvLevel(jsonResponse: currentJsonResponse)

                        // print it out
                        print("The weather in \(location) at \(time) is currently:")
                        print("\(weather) with a temperature of \(currentTemperature)°C and a feels like temperature of \(currentFeelsLikeTemperature)°C.")
                        print("There is a \(windDir) wind going through at \(windSpeed)km/h")
                        print("The amount of precipitation predicted is \(precip)mm with a humidity of \(humidity)g.m^-3")
                        print("The pressure in the area is \(pressure) pascals. The visibility around you is \(visibility)km")
                        print("With \(cloudCover)% of the sky under cloud.")
                        print("The UV radiation level right now is \(uvLevel)")
                        print()
                    }
                } catch {
                    print("An error occurred while retrieving weather data: \(error)")
                }
            } else {
                print("Authentication failed for user: \(username)")
            }
        }
    }
}

func main() {
    // Call the main method of WeatherExample class
    WeatherExample.main();
}

main()