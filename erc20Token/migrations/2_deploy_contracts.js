var myToken = artifacts.require("./myToken.sol");
var myTokenSale = artifacts.require("./myTokenSale.sol");

module.exports = async function(deployer) {
  let addr = await web3.eth.getAccounts();
  await deployer.deploy(myToken,1000000000);
  await deployer.deploy(myTokenSale,1, addr[0], myToken.address);
  let instance = await myToken.deployed();
  await instance.transfer(myTokenSale.address, 1000000000);

};
