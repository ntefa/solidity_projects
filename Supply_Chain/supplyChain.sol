pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Item {
    
    uint public price;
    uint public index;
    uint public paidWei;
    Itemizer parentContract;
    
    constructor (Itemizer _parentContract,uint _price,uint _index) {
        parentContract=_parentContract;
        index=_index;
        price=_price;
    
    }
    receive () external payable {
        require(msg.value==price, "Not fully paid");
        require(paidWei==0,"Item already paid");
        paidWei+=msg.value;
        (bool success,)=address(parentContract).call{value:msg.value} (abi.encodeWithSignature("getPayment(uint256)",index));
        require(success,'Transaction did not go through');
    }
    
    //fallback() external {}
}

contract Itemizer is Ownable {
    
    enum steps{created,paid,delivered}
   
    struct itemStruct {
        Itemizer.steps _step;
        string _identifier;
        Item _item;
    }
    
    mapping(uint=>itemStruct) public items;
    uint index;
    event supplyChainStep(uint _itemIndex,uint _step,address itemAddress);
    
    function createItem(string memory _id, uint _price) public onlyOwner{
        Item item = new Item(this,_price,index);
        items[index]._identifier=_id;
        items[index]._item=item;
        items[index]._step=steps.created;
        index++;
        emit supplyChainStep(index, uint(items[index]._step),address(item));
    }
    
    function getPayment(uint _index) public payable {
        Item item= items[_index]._item;
        require(msg.sender==address(item),"Step upgradable only by Item contract");
        require(item.price()==msg.value,"Not fully paid");
        items[_index]._step=steps.paid;
        emit supplyChainStep(_index, uint(items[_index]._step),address(item));

    }
    
    function triggerDelivery(uint _index) public onlyOwner{
        require(items[_index]._step==steps.paid,"Wrong supply chain phase");
        items[_index]._step=steps.delivered;
        emit supplyChainStep(_index, uint(items[_index]._step),address(items[_index]._item));

    }
}