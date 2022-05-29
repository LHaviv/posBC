//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Customer {
    address payable public customerAddress;

    constructor(){
 
    }

    modifier checkCustomerAddress (address payable _ownerAddress, address payable _customerAddress){
        require(_customerAddress != _ownerAddress, "Owner unable to do the transaction");
         _;
    }
}
