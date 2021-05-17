const Token = artifacts.require("MyToken.sol");
const TokenSale = artifacts.require("MyTokenSale.sol");  //since test starts when deploy conf is over, here we need just the first instance (so far)
const kyc = artifacts.require("kycContract.sol");
var chai = require("./setupChai.js");
const BN = web3.utils.BN;
const expect = chai.expect; 

contract("Token Sale", async function(accounts) {
	const [ initialHolder, recipient, anotherAccount ] = accounts;

	it("there shouldnt be any coin in my account", async () => {
		let instance = await Token.deployed(); 
		return expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(new BN(0)); 
	});
/*
	it("all coins should be in smart contract account", async () => {
		let instance = await Token.deployed(); 
		let balance = await instance.balanceOf.call(TokenSale.address);
		let totalSupply = await instance.totalSupply.call()
		return expect(balance).to.be.a.bignumber.equal(totalSupply);
	});
*/
	it("it should be possible to buy tokens", async () => {
		let tokenInstance = await Token.deployed(); 
		let tokenSaleInstance = await TokenSale.deployed();
		let balanceBeforeAccount = await tokenInstance.balanceOf.call(recipient);
		expect(tokenSaleInstance.sendTransaction({from: recipient, value: web3.utils.toWei("1", "wei")})).to.be.rejected; 
		expect(tokenInstance.balanceOf(recipient)).to.eventually.be.a.bignumber.equal(balanceBeforeAccount);
		let kycInstance = await kyc.deployed();
		await kycInstance.whitelist(recipient);
		expect(tokenSaleInstance.sendTransaction({from: recipient, value: web3.utils.toWei("1", "wei")})).to.be.fulfilled; 
		return expect(tokenInstance.balanceOf.call(recipient)).to.eventually.be.equal(balanceBeforeAccount + 1); //if call no big number needed
		//return expect(tokenInstance.balanceOf(recipient)).to.eventually.be.bignumber.equal(balanceBeforeAccount.add(new BN(1)));
	});
});