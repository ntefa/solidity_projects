const Token = artifacts.require("MyToken"); var chai = require("chai");
const BN = web3.utils.BN;
const chaiBN = require('chai-bn')(BN); chai.use(chaiBN);

var chaiAsPromised = require("chai-as-promised"); chai.use(chaiAsPromised);

const expect = chai.expect; 

contract("Token Test", async accounts => {

	const [ initialHolder, recipient, anotherAccount ] = accounts;

	it("All tokens should be in my account", async () => { 
		let instance = await Token.deployed();
		let totalSupply = await instance.totalSupply();
		//old style:
		//let balance = await instance.balanceOf.call(initialHolder); //assert.equal(balance.valueOf(), 0, "Account 1 has a balance");
		//condensed, easier readable style: expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); });
		expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); 
	});

	it("Should transfer tokens to other account", async () => { 
		let instance = await Token.deployed();
		let totalSupply = await instance.totalSupply();
		const sentTokens = 1;
		expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); 
		expect(instance.transfer(recipient,sentTokens)).to.eventually.be.fulfilled;
		expect(instance.balanceOf(initialHolder)).to.be.eventually.a.bignumber.equal(totalSupply.sub(new BN(sentTokens)));
		expect(instance.balanceOf(recipient)).to.be.eventually.a.bignumber.equal(new BN(sentTokens));

	})

	it('Should not allow transfers greater than the amount held in initialHolder account', async () => {
		let instance = await Token.deployed();
		let balanceofAccount = await instance.balanceOf(initialHolder);
		expect(instance.transfer(recipient,new BN (balanceofAccount+1))).to.eventually.be.rejected;
		expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(balanceofAccount); 

	})
});