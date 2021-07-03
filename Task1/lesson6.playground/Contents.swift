import UIKit

protocol Coffee {
    var cost: Int { get }
}

class SimpleCoffee: Coffee {
    var cost: Int {
        return 10
    }
}

protocol CoffeeDecorator: Coffee {
    var base: Coffee { get }
    init(base: Coffee)
}

class Milk: CoffeeDecorator {
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + 5
    }
}

class Whip: CoffeeDecorator {
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + 10
    }
}

class Sugar: CoffeeDecorator {
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + 3
    }
}


let coffee = SimpleCoffee()
let milkCoffee = Milk(base: coffee)
let whipCoffee = Whip(base: coffee)
let sugarCoffee = Sugar(base: coffee)

print(coffee.cost)
print(milkCoffee.cost)
print(whipCoffee.cost)
print(sugarCoffee.cost)

