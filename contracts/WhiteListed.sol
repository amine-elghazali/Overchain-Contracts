pragma solidity ^0.8.10;

contract WhiteListeContract { 

    address public owner;   // us :D

    address public propertyOwner;

    string public propertyCode;

    uint256 public price;

    bool public bought = false;
    bool public paused = false;
    bool public activated = true;

    mapping(address => bool) whiteListedAddresses;

    event propertyBought(address from,address to,uint256 price);

    constructor(address payable _propertyOwner,uint256 _price,string memory _propertyCode,address []memory _whiteAddresses){
        owner = msg.sender;
        propertyOwner = _propertyOwner;
        price = _price;
        propertyCode = _propertyCode;
        bought = false;
        for(uint i =0;i<_whiteAddresses.length;i++){
            addAddressToWhiteList(_whiteAddresses[i]);
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

    modifier ownerOrPropertyOwner(){
        require(
            msg.sender == owner || msg.sender == propertyOwner
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

     modifier isWhitelisted(address _address) {
        require(whiteListedAddresses[_address], "You need to be whitelisted");
        _;
    }

    function addAddressToWhiteList(address _whiteListedAddresses) public ownerOrPropertyOwner {
        require(whiteListedAddresses[_whiteListedAddresses] == false , "this address is already white listed");
        whiteListedAddresses[_whiteListedAddresses] = true;
    }

    function removeAddressFromWhiteList(address _whiteListedAddresse) public ownerOrPropertyOwner{
        delete whiteListedAddresses[_whiteListedAddresse];
    }

    function verifyAddress(address _whiteListedAddresses) public view returns(bool) {
        bool addressIsWhitelisted = whiteListedAddresses[_whiteListedAddresses];
        return addressIsWhitelisted;
    }



    function buyProperty() payable public isWhitelisted(msg.sender) isActivated buyRequirement notPaused {
        payable(propertyOwner).transfer(msg.value);
        
        emit propertyBought(propertyOwner, msg.sender, msg.value);
        
        propertyOwner = msg.sender;
        bought = true;
    }


    function deActivate() public onlyPropertyOwner {
        activated = false;
    }

    // function to resale property
    function reSale(uint256 _price,address []memory _whiteAddresses) public canReSale ownerOrPropertyOwner isActivated notPaused{
        
        price = _price;
        for(uint i =0;i<_whiteAddresses.length;i++){
            addAddressToWhiteList(_whiteAddresses[i]);
        }
        bought = false;
    }
    
}