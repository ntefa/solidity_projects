pragma solidity ^0.8.0;

contract simpleStorage {

	uint256 public favNumber;
	struct People {
		uint256 favNumber;
		string name;
	}
	People[] public people;
	mapping(string => uint256) public name2favNumber;

	function store(uint256 _favNumber) public {
		favNumber=_favNumber;
	}

	function retrieve() public view returns (uint256) {
		return favNumber;
	}

	function addPerson(string memory _name, uint256 _favNumber) public {
		people.push(People({_favNumber,_name}));
		name2favNumber[_name]=_favNumber;
	}
}