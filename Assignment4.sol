
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ข้อ 1 ระบบสมาชิกรายเดือน
contract SubscriptionSystem {
    address public owner;
    uint256 public monthlyFee;
    mapping(address => uint256) public expiryDate;

    constructor() {
        owner = msg.sender;
        monthlyFee = 0.0001 ether;
    }

    function setMonthlyFee(uint256 fee) public {
        require(msg.sender == owner, "Owner only");
        monthlyFee = fee;
    }

    function userPayment() public payable {
        require(msg.value == monthlyFee, "Wrong fee");

        uint256 start = block.timestamp;
        if (expiryDate[msg.sender] > start) {
            start = expiryDate[msg.sender];
        }

        expiryDate[msg.sender] = start + 30 days;
    }

    function checkActiveStatus(address user)
        public view returns (bool)
    {
        return expiryDate[user] > block.timestamp;
    }
}

// ข้อ 2 ระบบเช่าทรัพย์สิน
contract RentalSystem {
    address public owner;
    uint256 public rentalFee;
    mapping(address => bool) public paidRenters;

    constructor() {
        owner = msg.sender;
        rentalFee = 0.0001 ether;
    }

    function setRentalFee(uint256 fee) public {
        require(msg.sender == owner, "Owner only");
        rentalFee = fee;
    }

    function payRentalFee() public payable {
        require(msg.value == rentalFee, "Wrong fee");
        paidRenters[msg.sender] = true;
    }

    function checkPaidRenters(address user)
        public view returns (bool)
    {
        return paidRenters[user];
    }
}

// ข้อ 3 ระบบจองสินค้า
contract ProductPreOrder {
    address public owner;
    uint256 public totalOrders;

    mapping(address => uint256) private orders;
    mapping(address => uint256) public totalPaid;

    constructor() {
        owner = msg.sender;
    }

    function purchaseViaETH() public payable {
        require(msg.value > 0, "Send ETH");

        orders[msg.sender] += 1;
        totalPaid[msg.sender] += msg.value;
        totalOrders += 1;
    }

    function myOrders() public view returns (uint256) {
        return orders[msg.sender];
    }

    function ownerCheckOrders(address buyer)
        public view returns (uint256)
    {
        require(msg.sender == owner, "Owner only");
        return orders[buyer];
    }

    function ownerTotalOrders()
        public view returns (uint256)
    {
        require(msg.sender == owner, "Owner only");
        return totalOrders;
    }
}
