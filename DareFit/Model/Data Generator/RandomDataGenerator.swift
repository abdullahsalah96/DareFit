import Foundation

class RandomDataGenerator{
    
    var UIDs:[String]!
    
    class func getRandomLatitude()->Double{
        return Double.random(in: -90...90)
    }
    class func getRandomLongitude()->Double{
        return Double.random(in: -180...180)
    }
    class func getRandomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    class func getRandomEmailString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<length).map{ _ in letters.randomElement()! })
        return "\(name)@gmail.com"
    }
    class func getRandomWebsite(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let name = String((0..<length).map{ _ in letters.randomElement()! })
        return "https://www.\(name).com"
    }
    class func generateRandomUsers(challenge:String){
        //sign up user
        Authentication.signUp(firstName: getRandomString(length: 5), lastName: getRandomString(length: 3), email: getRandomEmailString(length: 8), password: getRandomString(length: 10), url: getRandomWebsite(length: 5), long: getRandomLatitude(), lat: getRandomLatitude(), completion: {
            (error) in
            guard error == nil else{
                print(error!)
                return
            }
            //update user data
            Authentication.getUserData { (error) in
                guard error == nil else{
                    print(error!)
                    return
                }
                print("Created random user")
                //create random challenge for user
                Database.createChallenge(firstName: CurrentUser.currentUser.firstName, lastName: CurrentUser.currentUser.lastName, long: CurrentUser.currentUser.longitude, lat: CurrentUser.currentUser.latitude, uid: CurrentUser.currentUser.uid, challenge: challenge, description: self.getRandomString(length: 30), url: CurrentUser.currentUser.url) { (error) in
                    guard error == nil else{
                        print(error!)
                        return
                    }
                    print("Created random challenge")
                }
            }
        })
    }
}
