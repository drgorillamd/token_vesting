const Migrations = artifacts.require("Migrations");
//const TokenVesting = artifacts.require("TokenVesting");
const KimJongMoon = artifacts.require("KimJongMoon");

module.exports = function(deployer) {
  //const token_address = "0x737f0E47c4d4167a3eEcde5FA87306b6eEe3140e"; //address on BSC mainnet
  //deployer.deploy(TokenVesting, 0, token_address);
  deployer.deploy(KimJongMoon);
};
