pragma solidity 0.8.0;
/*
* Linerar vesting of ERC20 token until release_time (expressed in Unix epoch time)
* See https://www.unixtimestamp.com/ for conversion
* + wallet migration possibilities (without locking removal)
* Read the doc.
*
* Coded for KimJongMoon by @DrGorilla_md (DM Twitter/TG for enquiries)
*/

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "@openzeppelin/contracts/utils/math/SafeMath.sol";

pragma solidity 0.8.0;
/*
* Linerar vesting of ERC20 token until release_time (expressed in Unix epoch time)
* See https://www.unixtimestamp.com/ for conversion
* + wallet migration possibilities (without locking removal)
* Read the doc.
*
* Coded for KimJongMoon by @DrGorilla_md (DM Twitter/TG for enquiries)
*/

interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this mbnbod brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/bnbereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whbnber the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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
