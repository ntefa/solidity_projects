pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract kycContract is Ownable{
	mapping(address => bool) public isAllowed;

	function whitelist (address _who) public onlyOwner{
		isAllowed[_who]=true;
	}

	function blacklist (address _who) public onlyOwner{
		isAllowed[_who]=false;
	}

	function isWhitelisted (address _who) public return(bool){
		return isAllowed(_who);
	}
}