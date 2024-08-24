// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleBank {
    struct User {
        address userAddress;
        bool accountCreated;
        uint256 balance;
    }

    mapping(address => User) private users;
    event AccountCreated(address indexed account);
    event Deposit(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    modifier accountExists(address _account) {
        require(users[_account].accountCreated, "Account does not exist");
        _;
    }
    modifier hasSufficientBalance(address _account, uint256 _amount) {
        require(users[_account].balance >= _amount, "Insufficient balance");
        _;
    }

    function createAccount() public payable {
        require(!users[msg.sender].accountCreated, "Account already exists");

        users[msg.sender] = User({
            userAddress: msg.sender,
            balance: 0,
            accountCreated: true
        });

        emit AccountCreated(msg.sender);
    }

    function deposit() public payable accountExists(msg.sender) {
        users[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance()
        public
        view
        accountExists(msg.sender)
        returns (uint256)
    {
        return users[msg.sender].balance;
    }

    function withdraw(
        uint256 _amount
    )
        public
        accountExists(msg.sender)
        hasSufficientBalance(msg.sender, _amount)
    {
        users[msg.sender].balance -= _amount;

        payable(msg.sender).transfer(_amount);

        emit Withdrawal(msg.sender, _amount);
    }

    function transfer(
        address _to,
        uint256 _amount
    )
        public
        accountExists(msg.sender)
        hasSufficientBalance(msg.sender, _amount)
    {
        require(
            _to != address(0),
            "Transfer to the zero address is not allowed"
        );
        users[msg.sender].balance -= _amount;

        users[_to].balance += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }
}


