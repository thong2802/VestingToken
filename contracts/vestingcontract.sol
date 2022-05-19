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
    }

    // mapping user info by address
    mapping(address => User) public userInfo;
    mapping(address => bool) whiteListUsers; // this is private

    ERC20 public token;
    uint256 public firstRelease;
    uint256 public startTime;
    uint256 public totalPeriods;
    uint256 public timePerPeriods;
    uint256 public cliff;
    uint256 public totalTokens;

    constructor(address _token,
                uint256 _firstRelease,
                uint256 _startTime,
                uint256 _totalPeriods,
                uint256 _timePerPeriods,
                uint256 _cliff,
                uint256 _totalTokens 
    ) {
        token = ERC20(_token);
        firstRelease = _firstRelease;
        startTime = _startTime;
        totalPeriods = _totalPeriods;
        timePerPeriods = _timePerPeriods;
        cliff = _cliff;
        totalTokens = _totalTokens;
    }
   // even 
    
   // modifier
    modifier onlyWhiteListed() {
        require(whiteListUsers[msg.sender], "Only whitelist allowed");
        _;
    }

    function addToWhiteList(address[] memory user) public onlyOwner {
        for (int i = 0; i < user.length; i++) {
            whiteListUsers[user[i]] = true;
        }
    }
    function doSomething() public onlyWhiteListed() {
         // your logic
    }

}