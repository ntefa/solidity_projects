var myToken = artifacts.require("./myToken.sol");
var myTokenSale = artifacts.require("./myTokenSale.sol");

module.exports = function(deployer) {
  let addr = await web3.eth.getAccounts();
  deployer.deploy(myToken,1000000000);
  deployer.deploy(myTokenSale,1, addr[0], myToken.address);
  let instance = await myToken.deployed();
  let myToken.transfer(myTokenSale.address, balanceOf(addr[0]));

};
