pragma solidity ^0.4.4;


contract Delivery {
    // Declaring State of the Order
    enum State { Cooking, Delivering, Delivered }
    State public orderState;
    
    // Declaring User Address, Restaurant Address, cost of order and name of order
    address useraddress;
    address restaurantaddress;
    uint cost;
    string order;
    
    // Notify event in order to send event to UI to notify the user
    event notify(string message);
    
    // Cancellation event in order to cancel pending cooking orderState
    event cancelOrder(bool status);
    
    // An event to end orders
    event endOrder(bool endOrder);
    
    // Constructor by default sets useraddress to transaction sender
    constructor() public {
        useraddress = msg.sender;
    }
    
    // A modifier to allow withdrawal from smart contract
    modifier onlyRestaurant() {
        require(msg.sender == restaurantaddress);
        _;
    }
    
    // Customer places order via this function
    function placeOrder(string _order, uint _cost) public {
        order = _order;
        cost = _cost;
        orderState = State.Cooking;
    }
    
    // Emit a notification to alert user that the food has been prepared
    function notifyUser() public {
        emit notify("Food has been prepared. Delivery has started!");
    }
    
    // Emit an endOrder function in order to end the contract, once paid the corret amount
    function confirmOrder() public payable{
        require(msg.value == cost);
        emit endOrder(true);
    }
    
    // Cancel Order
    function cancel() public {
        msg.sender.transfer(cost);
        if (orderState == State.Cooking) {
            emit cancelOrder(true);
        } else {
            emit cancelOrder(false);
        }
    }
    
    // Withdraw funds from the smart contract to the restuarant's ethereum address
    function withdraw() external onlyRestaurant {
        uint256 balance = address(this).balance;
        require (balance > 1 ether);
        msg.sender.transfer(balance - 1 ether);
    }
}
