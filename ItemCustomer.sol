//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract ItemCustomer {
    address payable public customerAddress;

    mapping(string => string) public itemCustomerName;
    mapping(string => uint) public itemCustomerPrice;
    mapping(string => uint) public itemCustomerStock;

    constructor(){
        itemCustomerName['T01'] = "Coffee";
        itemCustomerName['T02'] = "Tea";

        itemCustomerPrice['T01'] = 500000 wei;
        itemCustomerPrice['T02'] = 300000 wei;

        itemCustomerStock['T01'] = 10;
        itemCustomerStock['T02'] = 20;
 
    }

    modifier checkItemCustomerName (string memory _name){
        require(itemCustomerPrice[_name] != 0, 
        string(abi.encodePacked("Invalid name")));
         _;
    }

    modifier checkItemCustomerStock (string memory _name, uint _quantity) {
        require(itemCustomerStock[_name] != 0 && itemCustomerStock[_name] >= _quantity, 
        string(abi.encodePacked("Insufficient stock")));
        _;
    }

    modifier checkItemCustomerPrice (string memory _name, uint _quantity) {
        require(msg.value >= (itemCustomerPrice[_name] * _quantity), 
            string(abi.encodePacked("Insufficient money")));
        _;
    }

    modifier checkCustomerAddress (address payable _ownerAddress, address payable _customerAddress){
        require(_customerAddress != _ownerAddress, "Owner unable to do the transaction");
         _;
    }
}
