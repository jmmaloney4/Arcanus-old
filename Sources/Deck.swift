import Foundation

struct Deck {
    private var contents: [Card]
    
    init?(path: String) {
        let file = FileHandle(forReadingAtPath: path)
        if file == nil {
            return nil
        }
        
        let data = file?.readDataToEndOfFile()
        if data == nil {
            return nil
        }
        
        let string = String(data: (data!), encoding: String.Encoding.utf8)
        if string == nil {
            return nil
        }
        
        let scan = Scanner(string: string!)
        var charSet = CharacterSet(charactersIn:"\n")
        String s =
        for scan.scanUpToCharacters(from: <#T##CharacterSet#>, into: <#T##AutoreleasingUnsafeMutablePointer<NSString?>?#>)
        
        
        contents = []
    }
    
    
}
