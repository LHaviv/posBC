//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Owner.sol";
import "./Item.sol";

contract Transaction is Owner, Item{

    constructor(){ }
    
    function sellItem(string memory _itemName, uint _quantity) payable external checkCustomerAddress(ownerAddress, msg.sender) 
        checkItemName(_itemName) 
        checkItemStock(_itemName, _quantity) 
        checkItemPrice(_itemName, _quantity) {

        uint totalPrice = itemPrice[_itemName] * _quantity;
        ownerAddress.transfer(totalPrice);

        itemStock[_itemName] -= _quantity;

        emit recordTransaction(msg.sender, totalPrice);
    }

        function BuyItem(string memory _itemName, uint _quantity) payable external checkDealerAddress(ownerAddress, msg.sender) 
        checkItemName(_itemName) 
        checkItemPrice(_itemName, _quantity) {

        uint totalPrice = itemPrice[_itemName] * _quantity;
        ownerAddress.transfer(totalPrice);

        itemStock[_itemName] += _quantity;

        emit recordTransaction(msg.sender, totalPrice);
    }

    event recordTransaction(address _customerAddress, uint _value);
}
