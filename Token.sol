pragma solidity ^0.4.0;

contract Token {
    string internal symbol;
    string internal name;
    uint8 internal decimals;
    uint internal totalSupply = 1000;
    mapping (address => uint) internal balance;
    mapping (address => mapping (address => uint)) internal allowances;
    
    function Token(string in_symbol, string in_name, uint8 in_decimals, uint in_totalSupply) public {
        symbol = in_symbol;
        name = in_name;
        decimals = in_decimals;
        totalSupply = in_totalSupply;
    }
    
    function getName() public constant returns (string) {
        return name;
    }
    
    function getSymbol() public constant returns (string) {
        return symbol;
    }
    
    function getDecimals() public constant returns (uint8) {
        return decimals;
    }
    
    function getTotalSupply() public constant returns (uint) {
        return totalSupply;
    }
    
    function getBalance(address addr) public constant returns (uint);
    function transfer(address to, uint value) public returns (bool);
    event Transfer(address indexed _from, address indexed _to, uint _value);
}
