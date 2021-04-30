pragma solidity ^0.8.0;

contract itemizer {
    
    enum steps{created,paid,delivered}
   
    struct itemStruct {
        itemizer.steps _step;
        string _identifier;
        uint _price;
    }
    
    mapping(uint=>itemStruct) public item;
    uint index;
    event supplyChainStep(uint _itemIndex,uint _step);
    
    function createItem(string memory _id, uint _price) public {
        item[index]._identifier=_id;
        item[index]._price=_price;
        item[index]._step=steps.created;
        index++;
        emit supplyChainStep(index, uint(item[index]._step));
    }
    
    function getPayment(uint _index) public payable {
        require(msg.value>=item[_index]._price,"Item not fully paid");
        require(item[_index]._step==steps.created,"Wrong supply chain phase");
        item[_index]._step=steps.paid;
        emit supplyChainStep(_index, uint(item[_index]._step));

    }
    
    function triggerDelivery(uint _index) public {
        require(item[_index]._step==steps.paid,"Wrong supply chain phase");
        item[_index]._step=steps.delivered;
        emit supplyChainStep(_index, uint(item[_index]._step));

    }
}