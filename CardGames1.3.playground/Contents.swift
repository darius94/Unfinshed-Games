//: Card Games Playground

import Cocoa

/**:
 - author: Your name
 */

/*:
 This code was extracted from stack overflow.
 
 It implements functionality that existed in version 1.0 but was removed
 */

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafePointer(to: &i) {
            $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}

protocol CardP {
    func simpleDescription() -> String
}

protocol HandP : CardP {
    func append(card: Card)
    func count() -> Int
    func longDescription() -> String
    func split(at: Int) -> HandP
    func cut() -> HandP
    func cut(at: Int) -> HandP
    func shuffle() -> HandP
    func shuffle(other: HandP) -> HandP
}

enum Rank: Int {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    func simpleDescription() -> String {
        switch self {
        case .ace:
            return "ace"
        case .jack:
            return "jack"
        case .queen:
            return "queen"
        case .king:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

enum Suit {
    case spades, hearts, diamonds, clubs
    func simpleDescription() -> String {
        switch self {
        case .spades:
            return "spades"
        case .hearts:
            return "hearts"
        case .diamonds:
            return "diamonds"
        case .clubs:
            return "clubs"
        }
    }
}

class Card : HandP {
    let rank : Rank
    let suit : Suit
    var next : Card?
    
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    /**
     recursively appends a card at the end of the list
     
     - parameters:
     The card to append
     
    */
    func append(card : Card) {
        if next == nil {
            next = card
        } else {
            next!.append(card: card)
        }
    }
    
    /**
     recursively counts the number of cards in the list
     
     - returns:
     The number of cards in the list, starting with the current card
     
    */
    func count() -> Int {
        if next == nil {
            return 1
        } else {
            return 1 + next!.count()
        }
    }
    
    
    /**
     returns a string with the simple description of the card
     
     - returns:
     A string with the description of the card
     
    */
    func simpleDescription() -> String {
        return rank.simpleDescription() + " of " + suit.simpleDescription()
    }
    
    /**
     returns a string with the description of the hand.
     does it recursively by concatenating the individual card descriptions
     
     - returns:
     A string with the description of the hand
     
    */
    
    func longDescription() -> String {
        if next == nil {
            return simpleDescription()
        } else {
            return simpleDescription() + "\n" + next!.longDescription()
        }
    }
    
    /**
     takes the hand/pile/stack of cards and splits it at a given card
     
     - parameters:
     The card index at which to split the hand
     
     - returns:
     The newly cut hand
     
     */
    func split(at: Int) -> HandP {
        if at == 1 {
            let ending = next
            next = nil
            return ending!
        }
        else {
            return next!.split(at: at - 1)
        }
    }
    
    /**
     takes the hand/pile/stack of cards and cuts it at random place
     
     - returns:
     The newly cut hand
     
     */
    func cut() -> HandP {
        let nCards = self.count()
        let index = Int(arc4random_uniform(UInt32(nCards)))
        return self.cut(at: index)
    }
 
    /**
     takes the hand/pile/stack of cards and cuts it at the card indicated
     
     - parameters:
     The card index at which to cut the hand
     
     - returns:
     The newly cut hand
     
     */
    func cut(at: Int) -> HandP {
        let ending : Card = self.split(at: at) as! Card
        ending.append(card: self)
        return ending as HandP
    }
    
    /**
     takes the hand/pile/stack of cards and shuffles it
     
     - returns:
     The newly suffled hand
     
     */
    /*
    func shuffle() -> HandP {
        let nCards = self.count()
        let index = nCards/2
        let ending = self.split(at: index)
        return shuffle(other: ending)
    }
 */
    func shuffle() -> HandP {
        let nCards = self.count()
        if nCards == 1 {
            return self
        }
        if nCards == 2 {
            return self.cut(at: 1)
        }
        //let index = nCards/2
        let index = Int(arc4random_uniform(UInt32((nCards - 1)/2)) + 1) + nCards/4
        print(index)
        var ending : Card = self.split(at: index) as! Card
        ending = ending.shuffle() as! Card
        let me = self.shuffle() as! Card
        ending.append(card: me)
        return ending
    }
    
    /**
     takes the hand/pile/stack of cards and shuffles with the supplied hand
     
     - parameters:
     another hand of cards
     
     - returns:
     The newly suffled hand
     
     */
    func shuffle(other: HandP) -> HandP {
        self.append(card: other as! Card)
        return shuffle()
    }
}

/**
 creates a new deck of cards.
 
 Note that this is a function and not a method of any class
 
 - returns:
 a new deck of cards
 
 */

func cardDeck() -> HandP {
    var deck : Card?
    // The following two for loops generate all the cards for a deck
    for suit in iterateEnum(Suit.self) {
        for rank in iterateEnum(Rank.self) {
            if(deck == nil) {
                deck = Card(rank: rank, suit: suit)
            } else {
                deck!.append(card: Card(rank: rank, suit: suit))
            }
        }
    }
    return deck!
}

/**
 takes a HandP and deals nHand number of hands with nCards cards in each
 
 Note that this is a function and not a method of any class
 
 - returns:
 an array of hHand number of HandP each with nCards number of cards
 /function for homework do Tuesday. will return a array of hands with the deck, youneed to implement a way to remove a card from the decka s you deal . also cetain hands with certain amount of cards, deal from top to bottom 1 to bottom,deal like  1card to each hand and continue
 */
func deal(deck: HandP, nHands: Int, nCards: Int) -> [HandP] {
//first 4 lines will remove the top card
    var cards : HandP? = deck   //? was added to be able to have nil cards
    var card :  Card?    //card that will be split .
    
    card = cards as! Card  //downcast it as a card, assigning the Hand and deck to card // card and cards are the same
    cards = cards?.split(at: 1)  //will return 2-52 cards storing those cads in cards
    
    var hands : [HandP] = [HandP]()
    
    if nHands * nCards <= deck.count(){
        
        for _ in 1...nHands{ //add the 1st card for each one of the hands
            card = cards as! Card
            cards = cards?.split(at: 1)
            hands.append(card!)
            
        }
        for _ in 1..<nCards{
            for hand in hands{      //loop adding cards to hand
                card = cards as! Card
                cards = cards?.split(at: 1)
                hand.append(card : card!)
            }

        }
        
    }
   hands.append(cards!)
    return hands
}

var deck = cardDeck()
//var card : Card = deck as! Card
//deck = card.next!

print("There are " + deck.count().description + " cards in the deck.\n")
print(deck.longDescription())
print("+++++++")
deck = deck.shuffle()
print(deck.longDescription())

/*:
 **Assignment 7**
 
 Implement the deal function shown above */
