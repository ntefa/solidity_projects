// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./crowdsale.sol";


contract myToken is ERC20, ERC20Burnable {

    constructor(uint256 initialSupply) ERC20("FanToken", "FNT") {
        _mint(msg.sender, initialSupply);
    }
    uint _minimumSupply=0;
	function transfer(address recipient, uint256 amount) public returns (bool) {
        return super.transfer(_msgSender(),recipient, partialBurn(amount));
    }

	function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        return super.transferFrom(sender ,recipient, partialBurn(amount));
    }

	function partialBurn(uint256 amount) internal returns (uint256) {
        uint256 burnAmount = _calculateBurnAmount(amount);

        if (burnAmount > 0) {
            _burn(msg.sender, burnAmount);
        }

        return amount.sub(burnAmount);
    }

	function _calculateBurnAmount(uint256 amount) internal view returns (uint256) {
        uint256 burnAmount = 0;

        // burn amount calculations
        if (totalSupply() > _minimumSupply) {
            burnAmount = amount.div(100);
            uint256 availableBurn = totalSupply().sub(_minimumSupply);
        if (burnAmount > availableBurn) {
                burnAmount = availableBurn;
            }
        }

        return burnAmount;
    }

 }