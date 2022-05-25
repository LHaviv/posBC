//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

import "./Owner.sol";
import "./ItemCustomer.sol";
import "./ItemDealer.sol";

contract Transaction is Owner, ItemCustomer, ItemDealer{

    constructor(){ }
    
    function sellCustomerItem(string memory _itemName, uint _quantity) payable external checkCustomerAddress(ownerAddress, msg.sender) 
        checkItemCustomerName(_itemName) 
        checkItemCustomerStock(_itemName, _quantity) 
        checkItemCustomerPrice(_itemName, _quantity) {

        uint totalPrice = itemCustomerPrice[_itemName] * _quantity;
        ownerAddress.transfer(totalPrice);

        itemCustomerStock[_itemName] -= _quantity;

        emit recordCustomerTransaction(msg.sender, totalPrice);
    }

    function sellDealerItem(string memory _itemName, uint _quantity) payable external checkDealerAddress(ownerAddress, msg.sender) 
        checkItemDealerName(_itemName)
        checkItemDealerStock(_itemName, _quantity)  
        checkItemDealerPrice(_itemName, _quantity)
        checkItemDealerQuantity(_quantity) {

        uint totalPrice = itemDealerPrice[_itemName] * _quantity;
        ownerAddress.transfer(totalPrice);

        itemDealerStock[_itemName] -= _quantity;

        emit recordDealerTransaction(msg.sender, totalPrice);
    }

    event recordCustomerTransaction(address _customerAddress, uint _value);
    event recordDealerTransaction(address _dealerAddress, uint _value);
}
