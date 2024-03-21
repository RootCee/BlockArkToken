// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BlockArkToken is ERC20, Ownable {
    uint256 public constant TOTAL_SUPPLY = 999 * (10**18); // Total supply of 999 tokens

    address[] private members;
    mapping(address => bool) private isManager;
    mapping(address => uint256) private votes; // Votes per member

    uint256 public constant MIN_MEMBER_HOLDING = 300 * (10**18); // Minimum holding for a Member

    constructor(address[] memory initialMembers) ERC20("BlockArk Studios Token", "ARK") Ownable(msg.sender) {
    require(initialMembers.length > 0, "At least one member is required");

    uint256 memberCount = initialMembers.length;
    uint256 tokensPerMember = TOTAL_SUPPLY / memberCount;

    for (uint256 i = 0; i < memberCount; i++) {
        address member = initialMembers[i];
        _mint(member, tokensPerMember);
        members.push(member);
        isManager[member] = true;
    }
}

    modifier onlyMember() {
        require(balanceOf(msg.sender) >= MIN_MEMBER_HOLDING, "Only members can call this function");
        _;
    }

    modifier onlyManager() {
        require(isManager[msg.sender], "Only managers can call this function");
        _;
    }

    function vote(address _recipient) external onlyMember {
        require(balanceOf(_recipient) >= MIN_MEMBER_HOLDING, "Recipient is not a member");

        votes[_recipient] += balanceOf(msg.sender);
    }

    function getVotes(address _member) external view returns (uint256) {
        return votes[_member];
    }

    function addManager(address _manager) external onlyMember {
        require(balanceOf(_manager) >= MIN_MEMBER_HOLDING, "Address is not a member");
        require(!isManager[_manager], "Address is already a manager");
        isManager[_manager] = true;
    }

    function removeManager(address _manager) external onlyOwner {
        require(isManager[_manager], "Address is not a manager");
        isManager[_manager] = false;
    }

    function isMember(address _address) external view returns (bool) {
        return balanceOf(_address) >= MIN_MEMBER_HOLDING;
    }

    // Additional functions and features can be added as needed
}