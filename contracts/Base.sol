pragma solidity ^0.8.10;

contract BaseContract { 

    address public owner;   // us :D

    address public seller;
    address public buyer;
    string public propertyCode;

    uint256 public minPrice ; 
    uint256 public price;

    bool public paused = false;
    bool public activated = true;

    event propertyBought(address from,address to,uint256 price);

    constructor(address payable _seller,uint256 _price,uint256 _minPrice ,string memory _propertyCode){
        require( _price >= _minPrice );
        owner = msg.sender;
        seller = _seller;
        price = _price;
        minPrice = _minPrice;
        propertyCode = _propertyCode;
    }



    modifier  onlySeller{
        require(
            seller == msg.sender
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


    function changePrice(uint256 _price) isActivated onlySeller public{
        require( _price >= minPrice );
        price = _price ;
    }
    

    function changeMinPrice(uint256 _minPrice) isActivated onlySeller public{
        require( price >= _minPrice );
        minPrice = _minPrice ;
    }

    function buyProperty() payable public isActivated buyRequirement notPaused {
        buyer = msg.sender;
        payable(seller).transfer(msg.value);
        //require(sent,"not sent !");
        emit propertyBought(buyer, seller, price);
    }


    function deActivate() public onlySeller {
        activated = false;
    }

    function Activate() public onlySeller {
        activated = true;
    }

}