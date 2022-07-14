//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
import "./Utilities.sol";

contract Transaction is Ownable, Utilities{

    event SmartContractSet(address indexed oldOwner, address indexed newOwner);
    event payItem(address customer, uint amount);

    uint totalAmount;

    struct Item {
        string name;
        uint stock;
        uint price;
        address customer; 
    }

    Item[] public items;

    constructor(){
        items.push(Item({ name: "Tea",stock: 5, price : 1 ether, customer: address(0)}));
        items.push(Item({ name: "Coffee",stock: 10, price : 2 ether, customer: address(0) }));
     }

    function addItem(string memory _name, uint _stock, uint _price ) external isOwner returns(string memory) {
        if(!itemExist(_name)){
            Item memory newItem = Item({
                name : _name,
                stock: _stock,
                price : _price,
                customer: address(0)
            });
            items.push(newItem);
            return string(abi.encodePacked(_name, 'success.'));
        }
        return string(abi.encodePacked(_name, 'already exist.'));
    }

    function updateItem(string memory _name, uint _stock, uint _price ) external isOwner returns(string memory) {
        bool success = false;
        if(itemExist(_name)) {
            for(uint i = 0; i < items.length; i++){
                if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))&& items[i].customer == address(0)){
                    items[i].price = _price;
                    items[i].stock = _stock;
                    success = true;
                }
            }
            if(success){
                return string(abi.encodePacked(_name, ' already updated.'));
            }
        }
        return string(abi.encodePacked(_name, ' does not exist.'));
    }

    function getBalance() public view isOwner returns(uint256){
        return totalAmount;
    }

    function withdraw() public payable isOwner{
        owner.transfer(totalAmount);
        totalAmount= 0;
    }

    function itemExist(string memory _name) private view returns (bool) {
        for(uint i = 0; i < items.length; i++){
            if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                return true;
            }
        }
        return false;
    }

    function checkAllItem() public view isOwner returns(Item[] memory){
        return items;
    }


    function checkAnItem(string memory _name) public view returns(string memory, uint, uint){
        string memory name = "No Name";
        uint price = 0;
	uint stock = 0;

        for(uint i = 0; i < items.length; i++){
            if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                name= "_name";
                price= items[i].price;
                stock= items[i].stock;
            }
        }
        return (name, price, stock);
    }

    function checkPayment(string memory _name, uint _quantity) private view returns (bool) {
        uint payment = msg.value;
        for(uint i = 0; i < items.length; i++){
            if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name)) && (items[i].price * _quantity) > payment) {
                return false;
            }
        }
        return true;
    }

    function sellItem(string memory _name, uint _quantity)payable external isNotOwner returns(string memory){
        string memory result = "Failed to process.";
        if(checkPayment(_name, _quantity)){
            for(uint i = 0; i < items.length; i++){
                if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name)) && items[i].stock > _quantity && items[i].customer == address(0)) {
                    uint amount= items[i].price * _quantity;
                    emit payItem(msg.sender, amount);
                    items[i].customer = msg.sender;
                    totalAmount += amount;

                    items[i].stock -= _quantity;

                    result = string(abi.encodePacked('You bought an item. Name: ', items[i].name, ', Price: ', uint2str(items[i].price)));
                }
            }
        }
        return result;
    }

}
