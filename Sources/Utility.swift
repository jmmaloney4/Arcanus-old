import Foundation

#if os(Linux)
import Glibc
#else
import Darwin
#endif

func generateRandomNumber(from min: Int = 0, upTo max: Int = Int.max) -> Int {
    var range = max - min
    #if os(Linux)
        return Int(random() % (range + 1)) + min
    #else
        return Int(arc4random_uniform(UInt32(range))) + min
    #endif
}
