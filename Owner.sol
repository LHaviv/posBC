//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Owner {
    address payable public ownerAddress;

    constructor(){
        ownerAddress = msg.sender;
    }
}
