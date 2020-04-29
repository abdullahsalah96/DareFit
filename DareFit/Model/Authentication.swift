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
            db.collection(collection).addDocument(data: [
                "firstName":firstName,
                "lastName": lastName,
                "uid":authResults!.user.uid,
                "longitude": 0,
                "latitude": 0
            ]) { (error) in
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
    
    class func getUserData(completion: @escaping (String?)->Void){
        let user = Auth.auth().currentUser
        guard user != nil else{
            //make sure user is signed in
            DispatchQueue.main.async {
                completion("No user signed in")
            }
            return
        }
        let uid = user?.uid
        //get user data
        db.collection(collection).whereField("uid", isEqualTo: uid!).getDocuments { (querySnapshot, error) in
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error!.localizedDescription)
                }
                return
            }
            guard querySnapshot != nil else{
                DispatchQueue.main.async {
                    completion("Can't find user data")
                }
                return
            }
            let doc = querySnapshot!.documents[0]
            CurrentUser.currentUser.uid = doc.data()["uid"] as! String
            CurrentUser.currentUser.firstName = doc.data()["firstName"] as! String
            CurrentUser.currentUser.lastName = doc.data()["firstName"] as! String
            CurrentUser.currentUser.longitude = doc.data()["longitude"] as! Double
            CurrentUser.currentUser.latitude = doc.data()["latitude"] as! Double
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
