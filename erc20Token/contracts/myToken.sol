// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//
import "./crowdsale.sol";


contract myToken is ERC20 {
    
    using SafeMath for uint256;

    constructor(uint256 initialSupply) ERC20("FanToken", "FNT") {
        _mint(msg.sender, initialSupply);
    }

    uint _minimumSupply=totalSupply().div(2);

	function transfer(address recipient, uint256 amount) public override returns (bool) {
        return super.transfer(recipient, partialBurn(amount));
    }

	function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        return super.transferFrom(sender ,recipient, partialBurn(amount));
    }

	function partialBurn(uint256 amount) internal returns (uint256) {
        uint256 burnAmount = _calculateBurnAmount(amount);

        if (burnAmount > 0) {
            _burn(msg.sender, burnAmount); // note that burn function dedrements tokens from total supply by its own
        }

        return amount.sub(burnAmount);
    }

	function _calculateBurnAmount(uint256 amount) public view returns (uint256) {
        
        uint256 burnAmount = 0;

        // burn amount calculations
        if (totalSupply() > _minimumSupply) {
            burnAmount = amount.div(20); //burn 5 % ... note that in transfers of volume as low as 20 tokens won't be burnt any
            uint256 availableBurn = totalSupply().sub(_minimumSupply);
        if (burnAmount > availableBurn) {
                burnAmount = availableBurn;
            }
        }

        return burnAmount;
    }


 }