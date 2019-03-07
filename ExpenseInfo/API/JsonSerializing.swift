

import Foundation


protocol JSONSerializable  {
    var JSONRepresentation : Any { get }
}

extension JSONSerializable {
    
    
    var JSONRepresentation : Any {
        
        var representation = [String:Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
            case let value as Dictionary<String,Any>:
                
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                
                if let val = value as? [JSONSerializable]{
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject}) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value as JSONSerializable:
                
                representation[label] = value.JSONRepresentation
                
            case let value as AnyObject :
                
                representation[label] = value
                
            default: break
            }
        }
        return representation
    }
    
    
    
    func toData()->Data?{  // Convert struct directly into json request
        
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            return nil
        }
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: representation, options: .prettyPrinted)
            
            print("-- REQUEST : \n",try JSONSerialization.jsonObject(with: data, options: .allowFragments))
            
            return data
            
        } catch let error {
            
            print(error)
            
            return nil
        }
        
        
    }
    
}





