pragma solidity ^0.4.0;

import "browser/Token.sol";
import "browser/ERC20.sol";
import "browser/ERC223.sol";
import "browser/ERC223ReceivingContract.sol";


contract centareumToken is Token("CTM", "Centareum Token", 18, 1000), ERC20, ERC223 {
    
    mapping(address => uint) public expiryOf; //Maps address to its expiry
    uint private leaseTime = 1; //LeaseTime can be changed
    
    //ERC223's functions
    function centareumToken() public {
        balance[msg.sender] = totalSupply;
    }
    
    function getTotalSupply() public constant returns (uint) {
        return totalSupply;
    }
    
    function getBalance(address addr) public constant returns (uint) {
        return balance[addr];
    }

    function transfer(address to, uint value) public returns (bool) {
        if (value > 0 && value <= balance[msg.sender] && !isContract(to)){
            balance[msg.sender] -= value;
            balance[to] += value;
            Transfer(msg.sender, to, value);
            return true;
        }
        
        return false;
    }

    function transfer(address to, uint value, bytes data) public returns (bool) {
        //Check validity before transfer
        if (value > 0 && value <= balance[msg.sender] && isContract(to) && to != msg.sender){
            balance[msg.sender] -= value;
            balance[to] += value;
            ERC223ReceivingContract temp_contract = ERC223ReceivingContract(to);
            temp_contract.tokenFallback(msg.sender, value, data);
            Transfer(msg.sender, to, value, data);
            return true;
        }
        
        return false;
    }

    function isContract(address addr) returns (bool) {
        uint codeSize;
        assembly{
            codeSize := extcodesize(addr)
        }
        return codeSize > 0;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        if (allowances[from][msg.sender] > 0 && value > 0 && allowances[from][msg.sender] >= value && balance[from] >= value){
            balance[from] -= value;
            balance[to] += value;
            allowances[from][msg.sender] -= value;
            Transfer(from, to, value);
            return true;
        }
        return false;
    }
    
    function approve(address spender, uint value) public returns (bool) {
        allowances[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }
    
    function allowance(address owner, address spender) public constant returns (uint) {
        return allowances[owner][spender];
    }
    
    
    
    
    //Time-based contract components below this line
    modifier expire(address addr) {
        if (expiryOf[addr] < block.timestamp) {
            expiryOf[addr] = 0;
            balance[addr] = 0;
        }
        _;
    }
    
    function lease() public payable expire(msg.sender) returns (bool) {
        require(msg.value == 1 ether);
        require(balance[msg.sender] == 0);
        balance[msg.sender] = 1;
        expiryOf[msg.sender] = block.timestamp + leaseTime;
        return true;
    }
     function getExpiryOf() public returns (uint) {
        return getExpiryOf(msg.sender);        
    }
    
    function getExpiryOf(address addr) public expire(addr) returns (uint) {
        return expiryOf[addr];
    }
}
