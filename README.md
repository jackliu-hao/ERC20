# 项目介绍
 
此项目只要是为了学习ERC20的知识点 。 主要有两个合约，ERC20和Bank合约，其中Bank合约主要是为了模拟银
行的角色，可以存储用户的代币。 着重理解授权的概念。


 
 # 使用说明
 ## branch :
 ### withoutApprove 
    当ERC20没有授权approval函数的时候，对于用户之间的转账没问题，但是如果某个用户向银行转账，此时银行合约并不能知道用户转了多少钱。 详见测试函数 ```testERC20TransferWithoutapproval```
    * 可以实现approval 函数 
    * 可以使用ERC777
    * 可以使用ERC-Callback ，但是此种方式要注意重入攻击
    * 使用ERC20-Permit（EIP2612） https://learnblockchain.cn/video/play/274
### erc20 
    实现了完整的erc20 合约，可以进行转账，授权，查询余额等操作。具体测试代码在```testERC20TransferWithapproval```中 
    此时转账的流程需要用户做两次操作：
        1、现授权给银行amount的金额
        2、在向银行合约存钱，银行合约中会调用erc20的transferFrom函数，实现验证转账



 
 
