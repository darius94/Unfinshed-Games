//: Vending Machine

import Cocoa

var str = "Hello, playground"

class Product {
    private var storedName : String
    var name : String {
        get{
            return storedName
        }
        set(newValue) {
            storedName = newValue
        }
    }
    private var storedValue : Int
    var value : Int {get { return storedValue} set(newValue) { storedValue = newValue}}
    
    convenience init() {
        self.init(newName: "No Name", newValue: 1)
    }
    
    init(newName: String, newValue: Int) {
        storedName = newName
        storedValue = newValue
    }
    
    func isEqual(_ object: Product?) -> Bool {
        return self.name.isEqual(object!.name) && self.value == object!.value
    }
}

class Coin {
    private var storedValue : Int
    var value : Int {get { return storedValue } set(newValue) {storedValue = newValue}}
    
    convenience init() {
        self.init(newValue: 1)
    }
    
    init(newValue: Int) {
        storedValue = newValue
    }
    
    func isEqual(_ object: Coin?) -> Bool {
        return self.value == object?.value
    }
}

class Container<T>  {
    var objects : [T] = [T]()
    
    func add(object : T) {
        objects.append(object)
    }
    
    func remove() -> T? {
        return objects.popLast()!
    }
    
    func count() -> Int {
        return objects.count
    }
}



class Tray : Container<Product> {
    
    override func add(object : Product) {
        if count() > 0 {
            if objects[0].isEqual(object) {
                super.add(object: object)
            }
        }
        else {
            super.add(object: object)
        }
    }
}

class CoinTube : Container<Coin> {
    private var storedValue : Int
    var value : Int {get { return storedValue } set(newValue) {storedValue = newValue}}
    var next : CoinTube?

    convenience override init() {
        self.init(newValue: 1)
    }
    
    init(newValue: Int) {
        storedValue = newValue
    }

    override func add(object : Coin) {
        if value == object.value {
            super.add(object: object)
        } else {
            if next != nil {
                next!.add(object: object)
            }
        }
    }
    
    func append(coinTube: CoinTube) {
        if next == nil {
            next = coinTube
        } else {
            next!.append(coinTube: coinTube)
        }
    }
    
    func totalCount() -> Int {
        if next == nil {
            return count()
        } else {
            return count() + next!.totalCount()
        }
    }
    
    func totalValue() -> Int {
        return value * count()
    }
    
    func grandTotalValue() -> Int {
        if next == nil {
            return totalValue()
        } else {
            return totalValue() + next!.grandTotalValue()
        }
    }
}

func defaultCoinTubes() -> CoinTube {
    let values : [Int] = [100, 50, 25, 10, 5, 1]
    
    return emptyCoinTubes(values: values)
}

func emptyCoinTubes(values: [Int]) -> CoinTube {
    let tube : CoinTube = CoinTube(newValue: values[0])
    
    for i in 1..<values.count {
        tube.append(coinTube: CoinTube(newValue: values[i]))
    }
    
    return tube
}

func defaultFilledCoinTubes() -> CoinTube {
    let values: [Int] = [100, 50, 25, 10, 5, 1]
    let quantity: [Int]  = [10, 20, 30, 40, 50, 100]
    
    return filledCoinTubes(coinValues: values, coinQty: quantity)
}

func filledCoinTubes(coinValues: [Int], coinQty: [Int]) -> CoinTube {
    let tube: CoinTube = emptyCoinTubes(values: coinValues)
    
    for i in 0..<coinQty.count {
        for _ in 0..<coinQty[i] {
            tube.add(object: Coin(newValue: coinValues[i]))
        }
    }
    return tube
}

class VendingMachine {
    var insertedCoins : CoinTube
    var sales : CoinTube
    var trays : [String : Tray]
    var dispenser : Container<Product>
    
    init() {
        insertedCoins = defaultCoinTubes()
        sales = defaultFilledCoinTubes()
        trays = [String : Tray]()
        dispenser = Container<Product>()
        let cheetos : Tray = Tray()
        for _ in 1...10 {
            cheetos.add(object: Product(newName: "Cheetos", newValue: 35))
        }
        let fritos : Tray = Tray()
        for _ in 1...15 {
            fritos.add(object: Product(newName: "Fritos", newValue: 45))
        }
        trays["A1"] = cheetos
        trays["C3"] = fritos
    }
    
    func insertCoin(coin: Coin) {
        insertedCoins.add(object: coin)
    }
    
    func insertLabel(label: String) {
       
       
        
       if(sales.grandTotalValue() <= insertedCoins.grandTotalValue()){
        dispenser.add(object: Product(newName:label, newValue:insertedCoins.grandTotalValue()))
        if ("A1" == label || "C3" == label){
             print("Your Product: is \(label)")
        }else{
        print("Product Unavailable")
            }
        }
    }
}

/*:
 **Assignment 8**
 
 Implement the method insertLabel.
 It should take a label string, we only setup two in the Vending Machine, namely, "A1" and "C3."
 You should check that you have enough money inserted to deliver the product requested. The product should be
 delivered into the dispenser.
 */
// The following lines of code should work once you write the code
let vm : VendingMachine = VendingMachine()
vm.insertCoin(coin: Coin(newValue: 25))
vm.insertCoin(coin: Coin(newValue: 10))
vm.insertLabel(label: "C3")  // This should not deliver any product since Fritos is 45
vm.insertLabel(label: "A1")  // This should deliver a pack of Cheetos into the dispenser
// Once you write the code you may uncomment the next line
//let myStuff : Product = vm.dispenser.remove()! as Product

print(vm.dispenser)
 

// the statements below was just the test we ran in class
var tray : Tray = Tray()
var cheetos : Product = Product(newName: "Cheetos", newValue: 35)
tray.add(object: cheetos)
var another : Product = Product(newName: "Cheetos", newValue: 35)
tray.add(object: another)
print(tray.count())
var coins : CoinTube = defaultCoinTubes()
var sales : CoinTube = defaultFilledCoinTubes()
var penny1 : Coin = Coin()
var dime1 : Coin = Coin(newValue: 10)
var penny2 : Coin = Coin()
var quarter1 : Coin = Coin(newValue: 25)

coins.add(object: penny1)
coins.add(object: dime1)
coins.add(object: penny2)
coins.add(object: quarter1)

print("The inserted coins value is \(coins.grandTotalValue())")
print("The total sales is \(sales.grandTotalValue())")
