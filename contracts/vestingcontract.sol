pragma solidity >=0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Tokenvesting is Ownable{
    using SafeMath for uint256;
    
    // info each user
    struct User {
        uint amount;
        uint tokenCanClaimed;
        bool firstClaim;
        uint256 firstJoin;
    }
    // mapping user info by address
    mapping(address => User) public userInfo;
    mapping(address => bool) whiteListUsers; // this is private
   
   // even 
    
   // modifier
    modifier onlyWhiteListed() {
        require(whiteListUsers[msg.sender], "Only whitelist allowed");
        _;
    }

    function addToWhiteList(address[] users) public onlyOwner {
        for (int i = 0; i < users.length; i++) {
            whiteListUsers[users[i]] = true;
        }
    }
    function doSomething() public onlyWhiteListed() {
         // your logic
    }

}