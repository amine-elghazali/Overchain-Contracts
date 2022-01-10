pragma solidity ^0.8.10;

contract BlackListeContract { 

    address public owner;   // us :D

    address public propertyOwner;

    string public propertyCode;

    uint256 public price;
    
    bool public bought = false;
    bool public paused = false;
    bool public activated = true;

    mapping(address => bool) blackListedAddresses;

    event propertyBought(address from,address to,uint256 price);

    constructor(address payable _propertyOwner,uint256 _price,string memory _propertyCode,address []memory _blackAddresses){
        owner = msg.sender;
        propertyOwner = _propertyOwner;
        price = _price;
        propertyCode = _propertyCode;
        for(uint i =0;i<_blackAddresses.length;i++){
            addAddressToBlackList(_blackAddresses[i]);
        }
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

    modifier onlyOwner(){
        require(
            owner == msg.sender
        );
        _;
    }


    function changePrice(uint256 _price) isActivated onlyPropertyOwner public{
        price = _price ;
    }
    

     modifier isBlacklisted(address _address) {
        require(!blackListedAddresses[_address], "You are blacklisted !");
        _;
    }

    function addAddressToBlackList(address _blackListedAddresses) public onlyOwner {
        blackListedAddresses[_blackListedAddresses] = true;
    }

    function removeAddressFromBlackList(address _blackListedAddresse) public onlyOwner{
        delete blackListedAddresses[_blackListedAddresse];
    }

    function verifyAddress(address _blackListedAddresses) public view returns(bool) {
        bool addressIsBlacklisted = blackListedAddresses[_blackListedAddresses];
        return addressIsBlacklisted;
    }



    function buyProperty() payable public isBlacklisted(msg.sender) isActivated buyRequirement notPaused {
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

    // function to resale property

    
}