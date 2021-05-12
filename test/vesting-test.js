
const TokenVesting = artifacts.require("TokenVesting");
const KIMJ = artifacts.require("KimJongMoon");
const KIMJ_addr = "0x737f0E47c4d4167a3eEcde5FA87306b6eEe3140e";

let creator;
let owner;
let kimj_deployed;

contract('TokenVesting', (accounts) => {

    before(async () => {
        creator = accounts[0];
        other = accounts[1];
        kimj_deployed = await KIMJ.at(KIMJ_addr);
    });

    it("Owner can withdraw token after the unlock date", async () => {
        //set unlock date in unix epoch to now
        let now = Math.floor((new Date).getTime() / 1000);
        //check contract initiated well and has the init balance
        assert(1000000000 * 10**6 * 10**9 == await kimj_deployed.balanceOf(creator));

        //create the wallet contract
        let vesting_deployed = await TokenVesting.new(now, KIMJ_addr);

        //load the wallet with some Toptal tokens
        let amountOfTokens = 1000000000;
        await kimj_deployed.transfer(vesting_deployed.address, amountOfTokens, {from: creator});

        //check that timeLockedWallet has ToptalTokens
        assert(amountOfTokens == await kimj_deployed.balanceOf(timeLockedWallet.address));

        //now withdraw tokens
        await vesting_deployed.withdraw({from: owner});

        //check the balance is correct
        let balance = await kimj_deployed.balanceOf(owner);
        assert(balance.toNumber() == amountOfTokens);
    });

    it("test", async () => {
      assert(true);

    });

});
