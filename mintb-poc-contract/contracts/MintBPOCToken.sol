// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// testnet address
// 0xB3026fA7BDBE17e1F56053b68Bc074eFDe159cC7

contract MintBPOCToken is ERC20 {
    constructor(address minter) ERC20("MintB POC Token", "MTB") {
        _mint(minter, 100000000 * 10 ** decimals());
    }
}
