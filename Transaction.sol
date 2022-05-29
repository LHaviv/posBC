//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "./Owner.sol";
import "./Customer.sol";
import "./Dealer.sol";
import "./Utilities.sol";

contract Transaction is Owner, Customer, Dealer, Utilities{

    struct Item {
        string name;
        uint stock;
        uint price;
    }

    Item[] public items;

    constructor(){
        items.push(Item({ name: "Tea",stock: 5, price : 1 ether }));
        items.push(Item({ name: "Coffee",stock: 10, price : 2 ether }));
     }

    function addItem(string memory _name, uint _stock, uint _price ) external isOwner returns(string memory) {
        if(canAddNew(_name)){
            Item memory newItem = Item({
                name : _name,
                stock: _stock,
                price : _price
            });
            items.push(newItem);
            return string(abi.encodePacked(_name, 'success.'));
        }
        return string(abi.encodePacked(_name, 'already exist.'));
    }

    function canAddNew(string memory _name) private view returns (bool) {
        for(uint i = 0; i < items.length; i++){          
            if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                return false;
            }
        }
        return true;
    }

    function checkAllItem() public view isOwner returns(Item[] memory){
        return items;
    }


    function checkItem(string memory _name) public view returns(string memory){
        string memory result = "Item not available.";
        for(uint i = 0; i < items.length; i++){
                if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                    result = string(abi.encodePacked('Name: ', items[i].name, ',Stock:  ', uint2str(items[i].stock),' Price: ', uint2str(items[i].price)));
                }
            }
        return result;
    }
    
    function sellCustomerItem(string memory _name, uint _quantity) payable external checkCustomerAddress(owner, msg.sender)   
        returns (string memory) {
        string memory result = "Name cannot be found.";
        for(uint i = 0; i < items.length; i++){
                if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                    uint totalPrice = items[i].price * _quantity; 
                    owner.transfer(totalPrice);
                    items[i].stock -= _quantity;
                    emit recordCustomerTransaction(msg.sender, totalPrice);
                    result = "Success";
                }
            }
        return result;
    }

    function sellDealerItem(string memory _name, uint _quantity) payable external checkDealerAddress(owner, msg.sender) 
        checkItemDealerQuantity(_quantity) 
        returns (string memory) {
        string memory result = "Name cannot be found";
        for(uint i = 0; i < items.length; i++){
                if(keccak256(bytes(items[i].name)) == keccak256(bytes(_name))) {
                    uint totalPrice = items[i].price * _quantity; 
                    owner.transfer(totalPrice);
                    items[i].stock -= _quantity;
                    emit recordCustomerTransaction(msg.sender, totalPrice);
                    result = "Success";
                }
                
            }
        return result;
    }

    event recordCustomerTransaction(address _customerAddress, uint _value);
    event recordDealerTransaction(address _dealerAddress, uint _value);
}
