// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract QKCToken is ERC20, Ownable {
    event Claim(address owner, address indexed user, uint amount);

    constructor(uint totalSuply) ERC20("EvonDev", "EVD") {
        _mint(msg.sender, totalSuply * 10**18); //1000000000000000000
    }

    function claimToken(uint amount) public {
        address user = _msgSender();
        address owner = owner();
        _approve(owner, user, amount * 10**18);
        transferFrom(owner, user, amount * 10**18);
        emit Claim(owner, user, amount);
    }
}
