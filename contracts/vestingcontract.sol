// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract MyVesting is ERC20, Ownable {
    using SafeMath for uint256;

    // userInfo
    struct User{
       uint256  amount;
       uint256  tokenCanClaim;
    }

    mapping(address => User) public listUserVesting;

    // Tokens vesting stage structure with vesting date and tokens allowed to unlock.
    struct VestingStage {
        uint256 date;
        uint256 tokensUnlockedPercentage;
    }

     /**
     * Array for storing all vesting stages with structure defined above.
     */
    VestingStage[] public stages;


    IERC20 public token; // token will use
    uint256 public firstRelease; // first time release ~ 20%,  block.timestamp : khởi tạo smartcontract
    uint256 public startTime;   //  now(), thời gian bắt đầu trả dần
    uint256 public totalPeriods; // 8 periods ,khoảng thời gian còn lại sau khi nhận 20% VD: 8 tháng
    uint256 public timePeriods;  // 1 month, khoảng thời gian giữa các lần claim còn lại VD: 1 tháng
    uint256 public cliff; // 1 year, khoang thoi gian token bi khoa
    uint256 public totalToken; // total token release.

    // Contructor;
    constructor(
    //    uint256 _firstRelease
       // uint256 _startTime;
       // uint256 _totalPeriods;
       // uint256 _timePeriods;
      //  uint256 _cliff;
      //  uint256 _totalToken
    )ERC20("Dev", "TSI"){
        _mint(msg.sender, 1000000000 * 10**18);
        token = IERC20(address(this));
       // firstRelease = _firstRelease;
        startTime = block.timestamp;
        totalPeriods = 8;
        timePeriods = 1;
        cliff = 1;
        totalToken = 10000;
    }
    // add investors address and amount token user by
    function userJoinWhiteList(address userAddress, uint amount) public payable {
        require(amount < 10000, "User can only claim 10 000 token");
        require(totalToken < 0, "Sout out");
        transfer(msg.sender, (amount / 100) * 10**18);
        listUserVesting[msg.sender].amount = amount;
        listUserVesting[msg.sender].tokenCanClaim = 0;
        totalToken -= amount;
    }

    // only Admin
    // Admin will transfer token vesting for user
    function fundVesting() public onlyOwner{
        transfer(address(this), 1000000000 * 10 ** 18);
    }

    // claim 
    // Investor claim token, tranfer token from vesting to address user address.
    function claim() public {
        address _sender = msg.sender;
        uint256 time = block.timestamp;
        uint256 tokenClaimable = 0;

        User storage user = listUserVesting[_sender];
        require(listUserVesting[msg.sender].amount > 0, "User not have in whitelist");
        if(totalToken > 0) {
            require(token.balanceOf(address(this)) >= user.tokenCanClaim, "Not enough fund to claim");
        }
        uint256 tokenClaimPerPeriod = buyerInfo[msg.sender].amount * 80 / 100 / totalPeriods;
        if(time < firstRelease + cliff){
                        tokenClaimable = buyerInfo[msg.sender].amount * 20 / 100;
            transfer(msg.sender,tokenClaimable);
            buyerInfo[msg.sender].tokenClaimed = tokenClaimable;
        } else {
            tokenClaimable += tokenClaimPerPeriod*((time-startTime)/timePerPeriods);
            startTime = startTime + ((time-startTime)/timePerPeriods) * timePerPeriods;
            totalPeriods = totalPeriods - ((time-startTime)/timePerPeriods);
            transfer(msg.sender,tokenClaimable);
            buyerInfo[msg.sender].tokenClaimed += tokenClaimable;
       }
    }
}

