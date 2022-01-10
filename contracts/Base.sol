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
            price <= msg.value,
            "not enough to buy this property"
            );
        _;

        require( 
            bought == false
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

    modifier canReSale(){
        require(
            bought == true
        );
        _;
    }


    function changePrice(uint256 _price) isActivated onlyPropertyOwner public{
        price = _price ;
    }


    function buyProperty() payable public isActivated buyRequirement notPaused {

        payable(propertyOwner).transfer(msg.value);
        
        emit propertyBought(propertyOwner, msg.sender, msg.value);
        
        propertyOwner = msg.sender;
        bought = true;
    }


    function deActivate() public onlyPropertyOwner {
        activated = false;
    }

    // function to resale property
    function reSale(uint256 _price) public canReSale onlyPropertyOwner isActivated notPaused{
        price = _price;
        bought = false;
    }

}