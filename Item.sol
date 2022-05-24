//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Item {
    address payable public customerAddress;
    address payable public dealerAddress;

    mapping(string => string) public itemName;
    mapping(string => uint) public itemPrice;
    mapping(string => uint) public itemStock;

    constructor(){
        itemName['T01'] = "Coffee";
        itemName['T02'] = "Tea";

        itemPrice['T01'] = 500000 wei;
        itemPrice['T02'] = 300000 wei;

        itemStock['T01'] = 10;
        itemStock['T02'] = 20;
 
    }

    modifier checkItemName (string memory _name){
        require(itemPrice[_name] != 0, 
        string(abi.encodePacked("Invalid name")));
         _;
    }

    modifier checkItemStock (string memory _name, uint _quantity) {
        require(itemStock[_name] != 0 && itemStock[_name] >= _quantity, 
        string(abi.encodePacked("Insufficient stock")));
        _;
    }

    modifier checkItemPrice (string memory _name, uint _quantity) {
        require(msg.value >= (itemPrice[_name] * _quantity), 
            string(abi.encodePacked("Insufficient money")));
        _;
    }

    modifier checkCustomerAddress (address payable _ownerAddress, address payable _customerAddress){
        require(_customerAddress != _ownerAddress, "Owner unable to do the transaction");
         _;
    }

    modifier checkDealerAddress (address payable _ownerAddress, address payable _dealerAddress){
        require(_dealerAddress != _ownerAddress, "Owner unable to do the transaction");
         _;
    }
}
