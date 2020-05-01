import Foundation
import Firebase

class Database{
    private static let db = Firestore.firestore() //firestore database
    
    class func subscribeToChallenge(challengeUID:String, challenge:String, completion: @escaping (String?)->Void){
        //check if user already subscribed
        db.collection(challenge).whereField("uid", isEqualTo: CurrentUser.currentUser.uid).getDocuments { (querySnapshot, error) in
            //check if there's error connecting to server
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error?.localizedDescription)
                }
                return
            }
            guard querySnapshot!.count == 0 else{
                //user already exists
                DispatchQueue.main.async {
                    completion("Already Subscribed")
                }
                return
            }
            //subscribe user
            db.collection(challenge).document(challengeUID).updateData([
                CurrentUser.currentUser.uid : "\(CurrentUser.currentUser.firstName) \(CurrentUser.currentUser.lastName)"
            ], completion: {(error) in
                guard error==nil else{
                    //error subscribing to challenge
                    DispatchQueue.main.async {
                        completion(error!.localizedDescription)
                    }
                    return
                }
                //subscribed successfully
                DispatchQueue.main.async {
                    completion(nil)
                }
            })
        }
    }
    
    class func deleteChallenge(challengeUID:String, challenge:String, completion: @escaping (String?)->Void){
        //check if user is subscribed
        let name = "\(CurrentUser.currentUser.firstName) \(CurrentUser.currentUser.lastName)"
        db.collection(challenge).whereField(CurrentUser.currentUser.uid, isEqualTo: name).getDocuments(completion: { (querySnapshot, error) in
            //check if there's error connecting to server
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error?.localizedDescription)
                }
                return
            }
            guard querySnapshot!.documents.count > 0 else{
                //user not subscribed
                DispatchQueue.main.async {
                    completion("Not Subscribed")
                }
                return
            }
            //delete user from challenge
            db.collection(challenge).document(challengeUID).updateData([
                CurrentUser.currentUser.uid : ""
            ], completion: {(error) in
                guard error==nil else{
                    //error subscribing to challenge
                    DispatchQueue.main.async {
                        completion(error!.localizedDescription)
                    }
                    return
                }
                //subscribed successfully
                DispatchQueue.main.async {
                    completion(nil)
                }
            })
        })
    }
    
    class func createChallenge(firstName:String, lastName:String, long:Double, lat:Double, uid:String, challenge:String, description: String, url:String, completion: @escaping (String?)->Void){
        db.collection(challenge).whereField("uid", isEqualTo: CurrentUser.currentUser.uid).getDocuments { (querySnapshot, error) in
            //check if there's error connecting to server
            guard error == nil else{
                DispatchQueue.main.async {
                    completion(error?.localizedDescription)
                }
                return
            }
            guard querySnapshot!.count == 0 else{
                //challenge already created
                DispatchQueue.main.async {
                    completion("Already Created")
                }
                return
            }
            //create challenge
            db.collection(challenge).document(CurrentUser.currentUser.uid).setData([
                "firstName":firstName,
                "lastName":lastName,
                "longitude":long,
                "latitude":lat,
                "uid": uid,
                "url": url,
                "description": description
            ]) { (error) in
                guard error==nil else{
                    //error creating challenge
                    DispatchQueue.main.async {
                        completion(error!.localizedDescription)
                    }
                    return
                }
                //created successfully
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    class func getChallenges(inChallenge: String, completion: @escaping ([Challenge]?, String?)->Void){
        var fetchedChallenges:[Challenge]? = []
        db.collection(inChallenge).getDocuments { (querySnapshot, error) in
            guard error == nil else{
                //error getting users data
                DispatchQueue.main.async {
                    completion(nil, error?.localizedDescription)
                }
                return
            }
            guard querySnapshot != nil else{
                //no challenges
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            //get subscribed users in background
            let q = DispatchQueue.global()
            q.async {
                for doc in querySnapshot!.documents{
                    //append user to users list
                    let uid = doc.data()["uid"] as! String
                    let firstName = doc.data()["firstName"] as! String
                    let lastName = doc.data()["lastName"] as! String
                    let longitude = doc.data()["longitude"] as! Double
                    let latitude = doc.data()["latitude"] as! Double
                    let description = doc.data()["description"] as! String
                    let url = doc.data()["url"] as! String
                    let challenge = Challenge(challengeType: inChallenge, firstName: firstName, lastName: lastName, uid: uid, longitude: longitude, latitude: latitude, description: description, url: url)
                    fetchedChallenges!.append(challenge)
                }
                //done appending users
                DispatchQueue.main.async {
                    completion(fetchedChallenges, nil)
                }
            }
        }
    }
}
