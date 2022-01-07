pragma solidity ^0.8.10;

contract WhiteListedContract{

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

    mapping(address => bool) whiteListedAddresses;
    
    constructor(){

       owner = msg.sender;

    }
       

    modifier  onlyOwner{
        require(
            msg.sender == owner
            );
        _;
    }

    modifier  onlySeller{
        require(
            msg.sender == seller
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



    modifier isWhitelisted(address _address) {
        require(whiteListedAddresses[_address], "You need to be whitelisted");
        _;
    }

    function addAddressToWhiteList(address _whiteListedAddresses) public onlyOwner {
        whiteListedAddresses[_whiteListedAddresses] = true;
    }

    function verifyAddress(address _whiteListedAddresses) public view returns(bool) {
        bool addressIsWhitelisted = whiteListedAddresses[_whiteListedAddresses];
        return addressIsWhitelisted;
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


    function signContract(address payable _buyer) payable public buyRequirement notPaused isWhitelisted(_buyer) {
        buyer = _buyer;
        //(bool sent, bytes memory data) = payable(seller).call{value: msg.value}("");
        payable(seller).transfer(msg.value);
        //require(sent,"not sent !");
        emit propertyBought(buyer, seller, price);
    }    

    
}