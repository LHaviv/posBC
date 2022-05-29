//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Dealer {
    address payable public dealerAddress;

    constructor(){
 
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
