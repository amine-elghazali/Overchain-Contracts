pragma solidity ^0.8.10;

contract BaseContract { 

    address public owner;   // us :D

    address public propertyOwner;
   
    string public propertyCode;

    uint256 public price;

    bool public bought = false;
    bool public paused = false;
    bool public activated = true;

    event propertyBought(address from,address to,uint256 price);

    constructor(address payable _propertyOwner,uint256 _price,string memory _propertyCode){
        owner = msg.sender;
        propertyOwner = _propertyOwner;
        price = _price;
        propertyCode = _propertyCode;
    }



    modifier  onlyPropertyOwner{
        require(
            propertyOwner == msg.sender
           );
        _;
    }
    

    modifier  buyRequirement{
        require(
            price >= msg.value,
            "not enough to buy this property"
            );
        _;
    }

    modifier  notPaused(){
        require(
            paused == false
            );
        _;
    }

    modifier isActivated() {
        require(
            activated == true
        );
        _;
    }


    function changePrice(uint256 _price) isActivated onlyPropertyOwner public{
        price = _price ;
    }
    

    function buyProperty() payable public isActivated buyRequirement notPaused {
        propertyOwner = msg.sender;
        payable(propertyOwner).transfer(msg.value);
        //require(sent,"not sent !");
        emit propertyBought(propertyOwner, propertyOwner, price);
    }


    function deActivate() public onlyPropertyOwner {
        activated = false;
    }

    function Activate() public onlyPropertyOwner {
        activated = true;
    }

}