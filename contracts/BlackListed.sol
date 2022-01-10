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
        bought = false;

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

    modifier ownerOrPropertyOwner(){
        require(
            msg.sender == owner || msg.sender == propertyOwner
        );
        _;
    }
    

    modifier  buyRequirement{
        require(
            price <= msg.value,
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

    modifier canReSale(){
        require(
            bought == true
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

    function addAddressToBlackList(address _blackListedAddresses) public ownerOrPropertyOwner {
        blackListedAddresses[_blackListedAddresses] = true;
    }

    function removeAddressFromBlackList(address _blackListedAddresse) public ownerOrPropertyOwner{
        delete blackListedAddresses[_blackListedAddresse];
    }

    function verifyAddress(address _blackListedAddresses) public view returns(bool) {
        bool addressIsBlacklisted = blackListedAddresses[_blackListedAddresses];
        return addressIsBlacklisted;
    }



    function buyProperty() payable public isBlacklisted(msg.sender) isActivated buyRequirement notPaused {
        
        payable(propertyOwner).transfer(msg.value);
        
        emit propertyBought(propertyOwner, msg.sender, msg.value);
        
        propertyOwner = msg.sender;
        bought = true;

    }


    function deActivate() public onlyPropertyOwner {
        activated = false;
    }


    // function to resale property
    function reSale(uint256 _price,address []memory _blackAddresses) public canReSale ownerOrPropertyOwner isActivated notPaused{
        price = _price;

        for(uint i =0;i<_blackAddresses.length;i++){
            addAddressToBlackList(_blackAddresses[i]);
        }
        bought = false;
    }
    
}