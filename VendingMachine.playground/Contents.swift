//: Playground - noun: a place where people can play

import Cocoa

var str = "Vending Machine"

class Product {
    private var storedName : String
    //Properties IS PART OF  instance class which you provide accessor methods. like the get and set method in Java
    //Guided tour: protocols and extensions
    var name : String {
        get{
        return storedName
        }
        set(newValue){
        storedName = newValue
        
        }
    }
    private var storedValue :Int
    var value : Int {get {return storedValue} set(newValue){storedValue = newValue}}
    
    
   convenience init(){
        self.init(newName: "No Name", newValue: 1)
    }
    
    init(newName: String,newValue:Int){
        //designated initializer/design pattern this allows only one place to allow instance variables,the convenience used above so when you want to add something to the instance variables you only have to go back to this init to edit it. is good becuase if a error only has to come back to this to fix it
        storedName = newName
        storedValue = newValue
    }

    func isEqual(_ object: Product?) -> Bool{
    return self.name.isEqual(object!.name) && self.value == object!.value //!becuase can be nil
    }
    
}

class Coin{
    private var storedValue : Int
    var value : Int { get { return storedValue } set(newValue) { storedValue = newValue}}
    
    convenience init(){
        self.init(newValue: 1)
    
    }
    init(newValue: Int){
    storedValue = newValue
    }
    
    func isEqual(_ object: Coin?) -> Bool{
        return self.value == object?.value
}
}

class Container<T> {
    var objects : [T] = [T]()
    
    
    func add(object : T){
        objects.append(object)
    }
    
    func remove() -> T?{
        //let temp : T = objects[objects.count-1]
        //objects.remove(at: objects.count-1)
        //return temp
        //or
       return objects.popLast()!
    }
    
    func count() -> Int {
        return objects.count
    }
}



class Tray : Container<Product>{
   
    override func add(object : Product){
        if count() > 0{
            if objects[0].isEqual(object){  // if you have atleast 1 check if same product then add
                super.add(object: object)
            }
        }else{
            super.add(object: object)// adding the first object
        }
    
    }
}

class CoinTube : Container<Coin>{
    private var storedValue : Int
    var value : Int { get { return storedValue } set(newValue) { storedValue = newValue}}
    var next : CoinTube?
    
    
    convenience override init(){
        self.init(newValue: 1)
    }
    
    init(newValue: Int){
    storedValue = newValue
           }
    
    
    override func add(object : Coin){
            if value == object.value {  // if you have atleast 1 check if same product then add
                super.add(object: object)
            }else{
                if next != nil{
                next!.add(object: object)
                }
        }
        
        
    }
    

    func append(coinTube: CoinTube){
        if next == nil{
            next = coinTube
        
        }else{
            next!.append(coinTube: coinTube)
        }
    }
    
    func totalCount() -> Int{
        if next == nil{
            return count()
        }else{
            return count() + next!.totalCount()
        
        }
        
    
    
    }
    


func totalValue() -> Int{
    return value * count()
}


func grandTotalValue() -> Int{
    if next == nil{
        return totalValue()
    
    }else{
        return totalValue() + next!.grandTotalValue()
    }
}

}

func defaultCoinTube() -> CoinTube {
    var values: [Int] = [100,50,25,10,5,1]
    
    return emptyCoinTubes(values: values)
}


func emptyCoinTubes(values: [Int]) ->CoinTube{
    let tube : CoinTube = CoinTube(newValue: values[0])
    for i in 1..<values.count{
        tube.append(coinTube: CoinTube(newValue: values[i]))
        
    }
    return tube
}

func filledCoinTubes(coinValues: [Int], coinQty: [Int]) -> CoinTube{
    let tube: CoinTube = emptyCoinTubes(values: coinValues)
    for i in 0..<coinQty.count{
        for _ in 0..<coinQty[i]{
            tube.add(object: Coin(newValue: coinValues[i]))
            
        }
    }
    return tube
}

func defaultFilledCoinTubes() -> CoinTube{
    let values: [Int] = [100,50,25,10,5,1]
    let quantity: [Int] = [10,20,30,40,50]
    return filledCoinTubes(coinValues: values, coinQty: quantity)
}

class VendingMachine{
    var insertedCoins : CoinTube
    var sales : CoinTube
    var trays : [String: Tray]
    //var dispenser : Container<Product>.self
    
    init(){
        insertedCoins = defaultCoinTube()
        sales = defaultFilledCoinTubes()
        trays = [String : Tray]()
       // dispenser = Container<Product>
    }
    
    func insertCoin(coin: Coin){
        insertedCoins.add(object: coin)
    }
    
    func insertlabel(label: String){
        //check if label exist if not put out a message
        //if a label avaialble get the product price etc
        // can build a tray simialr to how we did coin tubes and insert using label function
        //dispense the product you slected
    
    }
}

var tray : Tray = Tray()
var cheetos : Product = Product(newName: "Cheetos", newValue: 35)
var another : Product = Product(newName: "Cheetos", newValue: 35)
tray.add(object: cheetos)
tray.add(object: another)
print(tray.count())
var coins : CoinTube = defaultCoinTube()
var sales : CoinTube =  defaultFilledCoinTubes()

var pennies : CoinTube = CoinTube()
var dimes : CoinTube = CoinTube(newValue: 10)
var penny1 : Coin = Coin()
var dime1 : Coin = Coin(newValue: 10)
var penny2 : Coin = Coin()
var quarter1: Coin = Coin(newValue: 25)
coins.add(object: penny1)
coins.add(object: dime1)
coins.add(object: penny2)
print("The inserted coins value is \(coins.grandTotalValue())")
print("The total sales is \(sales.grandTotalValue())")

