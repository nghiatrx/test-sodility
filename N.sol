pragma solidity ^0.4.16;

contract NghiaToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    mapping (address => bool) public frozenAddress;

    uint256 public totalSupply = 1000000;

    address public owner;

    string public name = "NGHIA TOKEN";

    string public symbol = "NTK";

    uint8 public decimals = 6;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event FrozenFunds(address target, bool frozen);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function NghiaToken() public {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;              // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[msg.sender] >= _value);                // Check if the sender has enough
        require (_value > 0);
        require(!frozenAddress[msg.sender]);                     // Check if sender is frozen
        require(!frozenAddress[_to]);                       // Check if recipient is frozen
        require(msg.sender != _to); 
        balanceOf[msg.sender] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        Transfer(msg.sender, _to, _value);
    }

    function addToken(uint256 amount) onlyOwner public {
        balanceOf[owner] += amount;
        totalSupply += amount;
        Transfer(0, owner, amount);
    }

    function frozenAddress(address _address, bool frozen) onlyOwner public {
        frozenAddress[_address] = frozen;
        FrozenFunds(_address, frozen);
    }

    function destroy() onlyOwner public {
        selfdestruct(owner); 
    }

}

