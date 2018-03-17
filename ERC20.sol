pragma solidity ^0.4.0;

interface ERC20 {
    function transferFrom(address from, address to, uint value) public returns (bool);
    function approve(address spender, uint value) public returns (bool);
    function allowance(address owner, address spender) public constant returns (uint);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
