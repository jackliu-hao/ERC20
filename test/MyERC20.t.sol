// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from  "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";
import {BasicERC20} from  "../src/BasicERC20.sol";
import {DeployedBasicERC20,DeployedBank} from "script/DeployedBank.s.sol";

contract BankTest is Test{
    Bank bank;
    BasicERC20 basicERC20;
    // 创建一个新用户
    address USER = makeAddr("USER");
    address erc20Owner ;


    function setUp() external {
        DeployedBank deployedBank =  new DeployedBank();
        bank = deployedBank.run();
        DeployedBasicERC20 deployedBasicERC20 = new DeployedBasicERC20();
        basicERC20 = deployedBasicERC20.run();
        erc20Owner = basicERC20.contractOwner();
    }

    //测试ERC20代币转账
    function testERC20Transfer() public {
        vm.startPrank(erc20Owner);
        basicERC20.transfer(USER, 100);
        // 接收者应该存在 100 代币
        assertEq(basicERC20.balanceOf(USER), 100);
        // 发送者应该剩余 999999900 代币
        assertEq(basicERC20.balanceOf(erc20Owner), 999999900);
        // 接收者的余额 加上 发送者的余额应该登录总余额
        assertEq(basicERC20.totalSupply(), basicERC20.balanceOf(erc20Owner) + basicERC20.balanceOf(USER));
    }
    // 测试转账失败
    function testERC20TransferFail() public {
        vm.startPrank(USER);
        vm.expectRevert(
            abi.encodeWithSelector(BasicERC20.InsufficientBalance.selector, USER, basicERC20.balanceOf(USER),1000)
        );
        basicERC20.transfer(USER, 1000);
        vm.stopPrank();
    }

    //在没有实现approval的时候，进行用户向银行存钱
    function testERC20TransferWithoutapproval() public {
        vm.prank(basicERC20.contractOwner());
         //向USER转一些钱
        basicERC20.transfer(USER, 1000);
        vm.startPrank(USER);    
        basicERC20.transfer(address(bank), 1000);
        vm.stopPrank();
        // 按道理来说，此时用户的余额应该为0 
        assertEq(basicERC20.balanceOf(USER), 0);
        //此时 USER在银行的合约应该是 1000
        // assertEq(bank.balanceOf(USER), 1000); // failed
        // 但是实际为0
        assertEq(bank.balanceOf(USER), 0 ); //pass 
    }
    //测试实现了approve后向银行转账
    
}