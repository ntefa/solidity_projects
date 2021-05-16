pragma solidity ^0.8.0;
import "./crowdsale.sol";
import "./kycContract.sol";

contract myTokenSale is Crowdsale {

	kycContract kyc;

    constructor(
        uint256 rate,    // rate in TKNbits
        address payable wallet,
        IERC20 token,
        kycContract _kyc
    )
        Crowdsale(rate, wallet, token)
        public
    {
    	kyc=_kyc;

    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view override {
    	super._preValidatePurchase(beneficiary,weiAmount);
		require(kyc.kycCompleted(beneficiary), "KYC not completed yet, aborting");    
	}
}