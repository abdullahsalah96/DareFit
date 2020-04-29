import Foundation
import Firebase

class Authentication{
    
    private static let db = Firestore.firestore() //firestore database
    private static let collection = "Users" //users collection
    
    // A function that validates passwords and returns true if it's valid and false if it's not valid
    class func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordCheck.evaluate(with: password)
    }
    
    class func signUp(firstName: String, lastName: String, email:String, password:String, completion: @escaping (String?)->Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (authResults, errorResponse) in
            guard errorResponse == nil else{
                DispatchQueue.main.async {
                    completion(errorResponse?.localizedDescription)
                }
                return
            }
            //user created succesfully, add user to database and login successfully
            db.collection(collection).addDocument(data: ["firstName":firstName, "lastName": lastName, "uid":authResults!.user.uid]) { (error) in
                if error != nil{
                    //show error message
                    DispatchQueue.main.async {
                        completion("Error! Try again later")
                    }
                }else{
                    //signed up successfully
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        })
    }
    
    class func signIn(email:String, password:String, completion: @escaping (String?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResults, errorResponse) in
            guard errorResponse == nil else{
                DispatchQueue.main.async {
                    completion(errorResponse?.localizedDescription)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
    
    class func signOut(completion: @escaping (String?)->Void){
        do{
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                completion(nil)
            }
        }catch{
            DispatchQueue.main.async {
                completion(error.localizedDescription)
            }
        }
    }
}
