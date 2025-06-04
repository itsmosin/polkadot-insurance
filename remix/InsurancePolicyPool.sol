// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract InsurancePolicyPool {
    address public owner;
    string public policyName;
    uint256 public premiumAmount;
    uint256 public payoutAmount;

    mapping(address => bool) public hasPolicy;
    mapping(address => uint256) public lpStake;

    uint256 public totalStaked;

    event PolicyBought(address indexed user);
    event Staked(address indexed lp, uint256 amount);
    event Claimed(address indexed user);

    constructor(
        address _owner,
        string memory _name,
        uint256 _premium,
        uint256 _payout
    ) {
        owner = _owner;
        policyName = _name;
        premiumAmount = _premium;
        payoutAmount = _payout;
    }

    // Buy insurance policy by paying premium
    function buyPolicy() external payable {
        require(!hasPolicy[msg.sender], "Already bought");
        require(msg.value == premiumAmount, "Incorrect premium");
        hasPolicy[msg.sender] = true;
        emit PolicyBought(msg.sender);
    }

    // LPs stake capital into the pool
    function stake() external payable {
        require(msg.value > 0, "Nothing to stake");
        lpStake[msg.sender] += msg.value;
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value);
    }

    // Admin approves claim manually (could be oracle-triggered)
    function approveClaim(address user) external {
        require(msg.sender == owner, "Only owner");
        require(hasPolicy[user], "No policy");
        require(address(this).balance >= payoutAmount, "Insufficient funds");

        hasPolicy[user] = false;
        payable(user).transfer(payoutAmount);
        emit Claimed(user);
    }

    function getPoolBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserStake(address lp) external view returns (uint256) {
        return lpStake[lp];
    }
}
