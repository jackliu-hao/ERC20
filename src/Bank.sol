// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title 
 * @author 11u
 * @notice 银行合约，功能如下：
 * 1. 用户向合约存钱
 * 2. 用户从合约取钱
 * 3. 合约拥有者能够将钱全部取到自己的账户 
 */
contract Bank{

    // user balance
    mapping(address => uint256) public s_balance;
    // 合约拥护者
    address public owner;
    // 构造函数，设置合约部署者
    constructor(){
        owner = msg.sender;
    }

    //存钱
    function deposit(uint256 amount) public payable{
        s_balance[msg.sender] += amount;
    }
    // 个人取钱
    function withdraw(uint256 amount) public  {
        require (s_balance[msg.sender] >= amount, "not enough balance");
        s_balance[msg.sender] -= amount;
    }
    // 管理员取钱
    function withdrawAll() public {
        require(msg.sender == owner, "not owner");
        // payable(msg.sender).transfer(address(this).balance);
        // 如果使用自己的代币钱就是一个数字，所以不能使用原始的转账方式
        s_balance[msg.sender] += address(this).balance;
    }

    // 查询用户余额
    function balanceOf(address account) public view returns(uint256){
        return s_balance[account];
    }




}