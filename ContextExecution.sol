pragma solidity ^0.5.0;

contract ContextExecutor {

     uint public _num=0;
     
     // 1 (also 4) deploy and send me 2 test ether
     function sendMeMoney() public payable {
     }
     
     // 2 confirm contract balance ( also after sendOneEth and after trying to kill later on)
     function getContractWei(address _add) public view returns (uint256 bal){
         bal = _add.balance;
     }
     
     // 3 call this from this contract to send it back to your self 
     // 4 do the sendMeMoney again for the next steps
     function sendOneEth(address payable _recipient) public {
       require(address(this).balance >= 1 ether);
       
       _recipient.transfer(1 ether); // this works direct when calling
     }
     
     // try call this from contract 2
     function killMeWithSendAddress(address payable _recipient) public {
       selfdestruct(_recipient);
     }
     
      // try call this from contract 2
      function killMeUsingSender() public {
       // ignoring adding a isOwner modifier for now
       selfdestruct(msg.sender);
     }
     
     function addNum() public{
         _num++;
     }
      
}

contract ContextExecutorKiller{
    
    function directSelfDesctructCall(address _addressToKillAt, address payable _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("selfdestruct(address payable)", _recipient));
    }
    
    function directSelfDesctructCallNoPayable(address _addressToKillAt, address _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("selfdestruct(address)", _recipient));
    }
    
    function directSelfDesctructCallWithoutPayable(address _addressToKillAt, address payable _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("selfdestruct(address)", _recipient));
    }
    
     function directSelfDesctructNoAddressCall(address _addressToKillAt, address payable _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("selfdestruct()", _recipient));
    }
    
    function murderWithPayableCall(address _addressToKillAt, address payable _recipient) public  {
       // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("killMeWithSendAddress(address payable)", _recipient));
    }
    
    function murderWithPayableDelegateCall(address _addressToKillAt, address payable _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.delegatecall(abi.encodeWithSignature("killMeWithSendAddress(address payable)", _recipient));
    }
    
     function murderWithoutPayableDelegateCall(address _addressToKillAt, address _recipient) public  {
      // this doesn't work - try get ContextExecutor balance after executing
       (bool status, bytes memory returnData) = _addressToKillAt.delegatecall(abi.encodeWithSignature("killMeWithSendAddress(address)", _recipient));
    }
    
    function murderWithoutPayableCall(address _addressToKillAt, address _recipient) public  {
       // THIS WORKS AND IS SUPER DANGEROUS - DO NOT LEAVE ETH ON A CONTRACT - ++
       (bool status, bytes memory returnData) = _addressToKillAt.call(abi.encodeWithSignature("killMeWithSendAddress(address)", _recipient));
    }
    
    function murderWithJustSender(address _addressToKillAt) public  {
        // this works - try get balance after executing - should be erroring
       (bool status, bytes memory returnData) = _addressToKillAt.delegatecall(abi.encodeWithSignature("killMeUsingSender(address)"));
    }
}
