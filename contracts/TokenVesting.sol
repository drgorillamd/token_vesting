pragma solidity 0.8.0;
/*
* Linerar vesting of ERC20 token until release_time (expressed in Unix epoch time)
* See https://www.unixtimestamp.com/ for conversion
* + wallet migration possibilities (without locking removal)
* Read the doc.
*
* Coded for KimJongMoon by @DrGorilla_md (DM Twitter/TG for enquiries)
*/

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "https://github.com/OpenZepellin/contracts/blob/main/contracts/token/ERC20/IERC20.sol";
//import "https://github.com/OpenZepellin/contracts/blob/main/contracts/utils/math/SafeMath.sol";

contract TokenVesting {

    using SafeMath for uint256;

    IERC20 kimj_contract;
    uint256 public release_time;
    uint256 public start_time;
    uint8 public factor = 2;  // amount linearly vested = initial_deposit / factor; rest at expiration
    uint256 public initial_deposit;
    uint256 public claimed;
    address public wallet;

    event withdrawal(address to, uint256 amount);
    
    modifier onlyOwner {
        require(msg.sender == wallet, "Only wallet owner can call me");
        _;
    }

    constructor (uint256 _release_time, address token_address) public {
        wallet = msg.sender;
        release_time = _release_time;
        start_time = block.timestamp;
        kimj_contract = IERC20(token_address);
    }

    //every token transfered after starting the vesting can be
    //withdraw at the end of the vesting period
    function start_vesting () public onlyOwner {
        initial_deposit = kimj_contract.balanceOf(address(this));
        claimed = 0;
    }

    //combined with transfer of ownership for upgradibility -> multisig, swap, etc
    //whatever those guys want to have as future governance
    function set_wallet(address new_wallet) public onlyOwner {
        wallet = new_wallet;
    }

    //number of token claimable in the contract balance
    //re-test for release_time so can be used for display purpose as well
    function pending_token() public view returns (uint256){ 
        if(release_time >= block.timestamp) {
            uint duration = release_time.sub(start_time);
            uint total_vested = initial_deposit.div(factor);
            uint pending = (total_vested.mul(block.timestamp.sub(start_time)).div(duration)).sub(claimed);
            return pending;
        }
        else {
            return kimj_contract.balanceOf(address(this));
        }
    }

    function withdraw () public onlyOwner {

        uint256 balance = kimj_contract.balanceOf(address(this));
        require(balance > 0, "Empty contract");

        if(release_time >= block.timestamp) { //before end of vesting
          uint256 claimable = pending_token();
          claimed = claimed.add(claimable);
          kimj_contract.transfer(wallet, claimable);
          emit withdrawal(wallet, claimable);
        }

        else { //end of vesting, cashout everything
          kimj_contract.transfer(wallet, balance);
          emit withdrawal(wallet, balance);
        }
    }
    

    function get_balance() public view returns (uint256) {
        return kimj_contract.balanceOf(address(this));
    }
    
    function time_left() public view returns (uint256) {
        return release_time.sub(block.timestamp);
    }

    // shhh... Don't be so generous, keep your ethers/bnb
    fallback() payable external {
        revert();
    }

}
