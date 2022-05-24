//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0;

contract Owner {
    address payable public ownerAddress;

    constructor(){
        ownerAddress = msg.sender;
    }

    // function stringConcate(string memory a, string memory b) internal pure returns (string memory) {
    //     return string(abi.encodePacked(a, b));
    // }
}
