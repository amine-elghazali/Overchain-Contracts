pragma solidity ^0.8.10;

contract BaseContract { 

    address public owner;   // us :D

    address public seller;
    address public buyer;
    string public propertyCode;

    uint256 public minPrice ; 
    uint256 public price;

    bool public paused = false;
    bool public cancel = false;

    event propertyBought(address from,address to,uint256 price);

    event propertyDeployed(address ,uint256, string );

    constructor() {
        owner = msg.sender;
    }

    /*constructor(address payable _seller,uint256 _price,uint256 _minPrice ,string memory _propertyCode){

        require( _price >= _minPrice );

        owner = msg.sender;
        seller = _seller;
        price = _price;
        minPrice = _minPrice;
        propertyCode = _propertyCode;
    
        emit propertyDeployed(seller, price, propertyCode);
    }
*/

    modifier  onlyOwner{
        require(
            owner == msg.sender
            );
        _;
    }

    modifier  onlySeller{
        require(
            seller == msg.sender
           );
        _;
    }
    

    modifier  buyRequirement{
        require(
            price == msg.value,
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


    function changePrice(uint256 _price) onlySeller public{
        require( _price >= minPrice );
        price = _price ;
    }
    

    function changeMinPrice(uint256 _minPrice) onlySeller public{
        require( price >= _minPrice );
        minPrice = _minPrice ;
    }


     function addProperty(address _seller,uint256 _price,uint256 _minPrice ,string memory _propertyCode) public onlyOwner{

        require( _price >= _minPrice );

        seller = _seller;
        price = _price;
        minPrice = _minPrice;
        propertyCode = _propertyCode;
       
        emit propertyDeployed(seller, price, propertyCode);
    }



    function signContract(address _buyer) payable public buyRequirement notPaused {
        buyer = _buyer;
        //(bool sent, bytes memory data) = payable(seller).call{value: msg.value}("");
        payable(seller).transfer(msg.value);
        //require(sent,"not sent !");
        emit propertyBought(buyer, seller, price);
    }
}