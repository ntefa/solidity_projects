//Note: truffle test first calls 2_deploy_conf, so its starting point is where deploy finishes.

const Token = artifacts.require("MyToken"); 
var chai = require("./setupChai.js");
const BN = web3.utils.BN;
const expect = chai.expect; 

contract("Token Test", async accounts => {

	const [ initialHolder, recipient, anotherAccount ] = accounts;

	beforeEach (async () => {
		this.myToken = await Token.new(1000000000);
	});

	it("All tokens should be in my account", async () => { 
		let instance = this.myToken;  //Token.deployed would have gotten the instance from the deployed contract,instead of creating new one like in this case.
		let totalSupply = await instance.totalSupply(); 
		//old style:
		//let balance = await instance.balanceOf.call(initialHolder); //assert.equal(balance.valueOf(), 0, "Account 1 has a balance");
		//condensed, easier readable style: expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); });
		return expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); 
	});

	it("Should transfer tokens to other account", async () => { 
		let instance = this.myToken;
		let totalSupply = await instance.totalSupply();
		const sentTokens = 1;
		expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(totalSupply); 
		expect(instance.transfer(recipient,sentTokens)).to.eventually.be.fulfilled;
		expect(instance.balanceOf(initialHolder)).to.be.eventually.a.bignumber.equal(totalSupply.sub(new BN(sentTokens)));
		return expect(instance.balanceOf(recipient)).to.be.eventually.a.bignumber.equal(new BN(sentTokens));

	})

	it('Should not allow transfers greater than the amount held in initialHolder account', async () => {
		let instance = this.myToken;
		let balanceofAccount = await instance.balanceOf(initialHolder);
		expect(instance.transfer(recipient, new BN (balanceofAccount+1))).to.eventually.be.rejected;
		return expect(instance.balanceOf(initialHolder)).to.eventually.be.a.bignumber.equal(balanceofAccount); 

	})
});