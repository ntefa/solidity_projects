const Token = artifacts.require("MyToken.sol");
//const TokenSale = artifacts.require("MyTokenSale.sol");  since test starts when deploy conf is over, here we need just the first instance (so far)
var chai = require("./setupChai.js");
const BN = web3.utils.BN;
const expect = chai.expect; 

contract("Token Sale", async function(accounts) {
	const [ initialHolder, recipient, anotherAccount ] = accounts;
	it("there shouldnt be any coin in my account", async () => {
		let instance = await Token.deployed(); 
		return expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(new BN(0)); 
	});
});