import Foundation

print("Hello, World!")

for var k in 0...10 {
    print(generateRandomBool())
}

print(Card.Class.warlock.getSymbol())
print(Card.Class.priest.getSymbol())
print(Card.Class.shaman.getSymbol())

var p1 = CLIPlayer()
var p2 = CLIPlayer()

var game = Game(playerOne: p1, playerTwo: p2)
game.start()
