pragma solidity ^0.8.10;

contract BlackListedContract{

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

    mapping(address => bool) blackListedAddresses;
    

    constructor(){
        owner = msg.sender;
    }

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

   
        
    /*modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }*/

    modifier isNotBlacklisted(address _address) {
        require(!blackListedAddresses[_address], "This address is blackListed ! ");
        _;
    }

    function addAddressToBlackList(address _blackListedAddresses) public onlyOwner {
        blackListedAddresses[_blackListedAddresses] = true;
    }

    function verifyAddress(address _blackListedAddresses) public view returns(bool) {
        bool addressIsBlacklisted = blackListedAddresses[_blackListedAddresses];
        return addressIsBlacklisted;
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

        owner = msg.sender;
        seller = _seller;
        price = _price;
        minPrice = _minPrice;
        propertyCode = _propertyCode;
       
        emit propertyDeployed(seller, price, propertyCode);
    }


    function signContract(address payable _buyer) payable public buyRequirement notPaused isNotBlacklisted(_buyer) {
      buyer = _buyer;
        //(bool sent, bytes memory data) = payable(seller).call{value: msg.value}("");
        payable(seller).transfer(msg.value);
        //require(sent,"not sent !");
        emit propertyBought(buyer, seller, price);
    }    
    
}