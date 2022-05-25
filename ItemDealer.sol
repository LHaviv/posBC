//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract ItemDealer {
    address payable public dealerAddress;

    mapping(string => string) public itemDealerName;
    mapping(string => uint) public itemDealerPrice;
    mapping(string => uint) public itemDealerStock;

    constructor(){
        itemDealerName['T01'] = "Coffee";
        itemDealerName['T02'] = "Tea";

        itemDealerPrice['T01'] = 400000 wei;
        itemDealerPrice['T02'] = 200000 wei;

        itemDealerStock['T01'] = 100;
        itemDealerStock['T02'] = 100;
 
    }

    modifier checkItemDealerName (string memory _name){
        require(itemDealerPrice[_name] != 0, 
        string(abi.encodePacked("Invalid name")));
         _;
    }

    modifier checkItemDealerStock (string memory _name, uint _quantity) {
        require(itemDealerStock[_name] != 0 && itemDealerStock[_name] >= _quantity, 
        string(abi.encodePacked("Insufficient stock")));
        _;
    }

    modifier checkItemDealerPrice (string memory _name, uint _quantity) {
        require(msg.value >= (itemDealerPrice[_name] * _quantity), 
            string(abi.encodePacked("Insufficient money")));
        _;
    }

    modifier checkItemDealerQuantity (uint _quantity) {
        require( _quantity >= 10, 
            string(abi.encodePacked("Buy minimum of 10 units")));
        _;
    }

    modifier checkDealerAddress (address payable _ownerAddress, address payable _dealerAddress){
        require(_dealerAddress != _ownerAddress, "Owner unable to do the transaction");
         _;
    }
}
