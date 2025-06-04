// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./InsurancePolicyPool.sol";

contract InsurancePolicyFactory {
    address[] public allPools;

    event PoolCreated(address indexed creator, address poolAddress);

    function createPolicyPool(
        string memory _name,
        uint256 _premium,
        uint256 _payout
    ) external returns (address) {
        InsurancePolicyPool pool = new InsurancePolicyPool(
            msg.sender,
            _name,
            _premium,
            _payout
        );
        allPools.push(address(pool));
        emit PoolCreated(msg.sender, address(pool));
        return address(pool);
    }

    function getAllPools() external view returns (address[] memory) {
        return allPools;
    }
}
