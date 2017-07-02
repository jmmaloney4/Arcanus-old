import Foundation

print("Hello, World!")

struct CardConstants {
    struct BloodfenRaptor {
        static let name = "Bloodfen Raptor"
        static let cost = 2
        
    }
}

class Card {
    public enum Class {
        case neutral
        case druid
        case hunter
        case mage
        case paladin
        case priest
        case rouge
        case shaman
        case warlock
        case warrior
        
        public func getName() -> String {
            switch self {
            case .neutral: return "Neutral"
            case .druid: return "Druid"
            case .hunter: return "Hunter"
            case .mage: return "Mage"
            case .paladin: return "Paladin"
            case .priest: return "Priest"
            case .rouge: return "Rouge"
            case .shaman: return "Shaman"
            case .warlock: return "Warlock"
            case .warrior: return "Warrior"
            }
        }
        
        public func getSymbol() -> Character {
            switch self {
            case .neutral: return "¤"
            case .druid: return "🌿"
            case .hunter: return "🏹"
            case .mage: return "🔥"
            case .paladin: return "🔨"
            case .priest: return "✜"
            case .rouge: return "⚔️"
            case .shaman: return "🌋"
            case .warlock: return "🖐️"
            case .warrior: return "🗡"
            }
        }
    }
    
    var name: String;
    var cost: Int;
    
    init(withName name: String) {
        self.name = name
        self.cost = 0
    }
}

print(Card.Class.warlock.getSymbol())
print(Card.Class.priest.getSymbol())
print(Card.Class.shaman.getSymbol())


class Minion: Card {
    
}

class BloodfenRaptor: Minion {
    
}

class Spell: Card {
    
}

class Weapon: Card {
    
}

class HeroPower: Card {
    
}

class Hero: Card {
    
}
