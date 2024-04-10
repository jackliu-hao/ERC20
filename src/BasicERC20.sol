// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "./IERC20.sol";

contract BasicERC20 is IERC20 {
    // 名称
    string public s_name;
    // 代号 USD/BTC
    string public s_symbol;
    //代币总数
    uint256 public s_totalSupply;
    // 小数位数
    uint256 public s_decimals ;
    //用户授权金额 , owner => (spender => amount)
    mapping(address => mapping(address => uint256)) public s_allowances;
    // 用户剩余代币的映射
    mapping(address=>uint256) public s_balances;
    // 合约所有者
    address public contractOwner;

    //  事件 ,这里集成了的话，在子类事件就不需要在写了
    // //from 向 to转 value
    // event Transfer(address indexed from , address indexed to , uint256 value);
    // //owner 授权给 spender value
    // event Approval(address indexed owner,address indexed spender,uint256 value);

    // 余额不足 
    error InsufficientBalance(address user,uint256 balance,uint256 amount);
    // 授权额度不足
    error InsufficientAllowance(address owner,address spender,uint256 allowance,uint256 amount);

    // 构造器
    constructor(
        string memory name_,string memory symbol_,
        uint256 totalSupply_,uint256 decimals_)
    {
        s_name = name_;
        s_symbol = symbol_;
        s_totalSupply = totalSupply_;
        s_decimals = decimals_;
        s_balances[msg.sender] = totalSupply_;
        contractOwner = msg.sender;
    }

    /**
     * @dev 返回代币总数
     */
    function totalSupply() external view  returns (uint256) {
        return s_totalSupply;
    }

    /**
     * @dev 返回用户剩余代币
     * @param account 用户地址
     */
    function balanceOf(address account) external view returns(uint256){
        return s_balances[account];
    }
    /**
     * @dev 转账 `amount` 单位代币，从调用者账户到另一账户 `to`.
     *
     * 如果成功，返回 `true` 
     * 释放 {Transfer} 事件.
     */

    function transfer (address to, uint256 amount) external returns (bool){
        // 判断用户余额释放足够
        // require(s_balances[msg.sender] >= amount,"ERC20: Insufficient balance");
        if (s_balances[msg.sender] < amount){
            revert InsufficientBalance(msg.sender, s_balances[msg.sender] ,amount);
        }

        // 将msg.sender的余额减少
        s_balances[msg.sender] -= amount;
        // 将 to 的余额增加
        s_balances[to] += amount;
        //释放事件
        emit Transfer(msg.sender,to,amount);
        return true;
    }
    /**
     * @dev 返回`owner`账户授权给`spender`账户的额度，默认为0。
     *
     * 当{approve} 或 {transferFrom} 被调用时，`allowance`会改变.
     */
    function allowance(address owner,address spender) external  view returns(uint256){
        return s_allowances[owner][spender];
    }
    /**
     * @dev 调用者账户给`spender`账户授权 `amount`数量代币。
     *
     * 如果成功，返回 `true`.
     *
     * 释放 {Approval} 事件.
     */
    function approve(address spender,uint256 amount) external returns(bool) {
        s_allowances[msg.sender][spender] += amount; // 不能使用等于，因为可以多次授权
        emit Approval(msg.sender,spender,amount);
        return true;
    }
    /**
     *  如果成功，返回 `true`.  
     * 此时转账的流程是 ，用户先将自己的钱授权给银行，
     * 银行再调用 ERC20合约的transferFrom 进行代替 用户转账
     * 释放 {Transfer} 事件.
     * @dev 通过授权机制，
     * 从`from`账户向`to`账户转账`amount`数量代币。转账的部分会从调用者的`allowance`中扣除。
     * 如：如果A向B转账：
     *      1、 A向B先授权了 100 ， 这个时候，s_allowances[A][B] = 100 ，表示B有A授权的100块钱
     *      2、 A调用B合约的存钱方法，B合约的存钱方法中调用 ERC20合约的 transferFrom(from,to,amount)
     *         from就是A的地址，to就是B的地址，
     */
    function transferFrom(address from,address to,uint256 amount) external returns(bool) {
        // 判断 allowance 是否足够
        if (s_allowances[from][to] < amount){
            revert InsufficientAllowance(
                        from, // 用户
                        to,  // 授权用户
                        s_allowances[from][to],// 剩余额度
                        amount  // 此次转账
                );
        }
        // 本质上，这个操作也是转账，需要变动 from 和 to的 余额
        s_balances[from] -= amount;
        s_balances[to] += amount;
        // 将额度减少
        s_allowances[from][to] -= amount;
        return true;
    }
    
}