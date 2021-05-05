var myToken = artifacts.require("./myToken.sol");

module.exports = function(deployer) {
  deployer.deploy(myToken,1000000000);
};
