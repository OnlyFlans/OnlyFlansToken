// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

/*
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


contract OnlyFlans
{
    using SafeMath for uint256;
    
    string public constant TokenName = "OnlyFlans";
    string public constant TokenSymbol = "FLANS";
    uint256 public constant Decimals = 9;
    uint256 public TokenMaxSupply = 1000000000000 * (10 ** uint256(Decimals));
    
    IUniswapV2Router02 public immutable UniswapV2Router;
    address public immutable UniswapV2Pair;
    
    uint256 private constant liquidityFee = 5;
    uint256 private constant holdersShareFee = 5;
    
    uint256 public holdersCirculatingSupply;
    uint256 private totalHolderShareFees;
    
    uint256 private constant maxAllowedTokenPerAddress = 10000000000 * (10 ** uint256(Decimals));
    
    address private constant projectFundAddress = 0x3174E3CC3C005a0F9B539D54D2a4943D5fDEd7d6;
    address private constant blackHoleAddress = 0x35F1D1D9f55da9fFf3Ba468B7CB91ff63adeAfCA;
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
    
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;
    mapping (address => uint256) private addressLastDividends;
    
    constructor()
    {
        balances[msg.sender] = TokenMaxSupply;
        
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        UniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        UniswapV2Router = uniswapV2Router;
    }
    
    /**
    * @dev Returns the total supply of this token
    */
    function TotalSupply() public view returns (uint256)
    {
        return TokenMaxSupply;
    }
    
    /**
    * @dev Check the number of tokens owned by an address including holder reflections
    */
    function CheckAddressBalance(address addressToCheck) public returns (uint256)
    {
        return GetAddressBalanceWithReflection(addressToCheck);
    }
    
    /**
    * @dev Check the allowance between addresses
    */
    function CheckAllowance(address from, address to) public view returns (uint256)
    {
        return allowances[from][to];
    }
    
    /**
    * @dev Transfers tokens from one address to another. This includes receiving or sending to pancakeswap
    */
    function TransferTokens(address sendingAddress, address addressToSend, uint256 amount) public returns (bool)
    {
        require(addressToSend != address(0), 'Invalid Address.');
        require(sendingAddress != address(0), 'Invalid sending Address.');
        require(balances[sendingAddress] >= amount, 'Not enough tokens to transfer.');
        require(allowances[sendingAddress][addressToSend] >= amount, 'Allowance is not enough');
        
        if(addressToSend != UniswapV2Pair)
        {
            require(balances[addressToSend] + amount <= maxAllowedTokenPerAddress, 'Cannot transfer tokens to this address. Max tokens in address is 1% of total supply');
        }
        
        ApproveTransaction(sendingAddress, addressToSend, amount);
        
        //Calculate fees (holders + liquidity)
        uint256 holdersFee = amount.mul(holdersShareFee).div(100);
        uint256 liqFee = amount.mul(liquidityFee).div(100);
        
        //Add holders fees to be shared later
        totalHolderShareFees = totalHolderShareFees.add(holdersFee);
        
        //Exclude transaction address from receiving holder fees
        if(sendingAddress == UniswapV2Pair)
        {
            //Buying
            holdersCirculatingSupply = holdersCirculatingSupply.add(amount.sub(liqFee));
            addressLastDividends[addressToSend] =  addressLastDividends[addressToSend].add(holdersFee);
        }
        else if(addressToSend == UniswapV2Pair)
        {
            //Selling
            holdersCirculatingSupply = holdersCirculatingSupply.sub(amount);
            addressLastDividends[sendingAddress] =  addressLastDividends[sendingAddress].add(holdersFee);
        }
        else
        {
            //Transfer between address
            addressLastDividends[addressToSend] = addressLastDividends[addressToSend].add(holdersFee);
            addressLastDividends[sendingAddress] = addressLastDividends[sendingAddress].add(holdersFee);
        }
        
        //Decrease sender balance
        balances[sendingAddress] = balances[sendingAddress].sub(amount);
        
        //Calculate the amount that other address will receive 
        uint256 newAmount = amount - (holdersFee + liqFee);
        
        //Add the new amount to receiver address
        balances[addressToSend] = balances[addressToSend].add(newAmount);
        
        allowances[sendingAddress][sendingAddress] = allowances[sendingAddress][sendingAddress].sub(amount);
        emit Transfer(sendingAddress, addressToSend, amount);
        return true;
    }
    
    /**
    * @dev Destroys tokens and decreases the max amount of tokens that exist
    */
    function BurnTokens(uint256 amount) public
    {
        require(msg.sender != address(0), 'Invalid Address.');
        require(balances[msg.sender] >= amount, 'Not enough tokens to burn');
        
        //Decrease the amount of token to be burned from address
        balances[msg.sender] = balances[msg.sender].sub(amount);
        //Decrease the max supply of tokens
        TokenMaxSupply = TokenMaxSupply.sub(amount);
        
        emit Transfer(msg.sender, address(0), amount);
    }
    
    /**
    * @dev Increase the allowance between addresses
    */
    function IncreaseAddressAllowance(address addressToIncreae, uint256 amount) public returns (bool)
    {
        require(addressToIncreae != address(0), 'Invalid Address.');
        
        allowances[msg.sender][addressToIncreae] = (allowances[msg.sender][addressToIncreae].add(amount));
        
        emit Approval(msg.sender, addressToIncreae, allowances[msg.sender][addressToIncreae]);
        return true;
    }
    
    /**
    * @dev Decreases the allowance between addresses
    */
    function DecreaseAddressAllowance(address addressToDecrease, uint256 amount) public returns (bool)
    {
        uint256 oldValue = allowances[msg.sender][addressToDecrease];
        
        if (amount > oldValue) 
        {
            allowances[msg.sender][addressToDecrease] = 0;
        } 
        else 
        {
            allowances[msg.sender][addressToDecrease] = oldValue.sub(amount);
        }
        
        emit Approval(msg.sender, addressToDecrease, allowances[msg.sender][addressToDecrease]);
        return true;
    }
    
    /**
    * @dev Check that transaction is valid
    */
    function ApproveTransaction(address senderAddress, address receiverAddress, uint256 amount) private returns (bool)
    {
        require(senderAddress != address(0), "Sender address is invalid");
        require(receiverAddress != address(0), "Receiver address is invalid");
        
        allowances[senderAddress][receiverAddress] = amount;
        
        emit Approval(senderAddress, receiverAddress, amount);
        return true;
    }
    
    function ApproveTransaction(address receiverAddress, uint256 amount) private returns (bool) 
    {
        return ApproveTransaction(msg.sender, receiverAddress, amount);
    }
    
    /**
    * @dev Calculate the amount of tokens this account will receive from total holder fees
    */
    function GetAddressDividends(address addressToCheck) private view returns(uint256) 
    {
        uint256 newDividendPoints = totalHolderShareFees - addressLastDividends[addressToCheck];
        return (balances[addressToCheck].mul(newDividendPoints)).div(holdersCirculatingSupply);
    }
    
    function GetAddressBalanceWithReflection(address addressToUpdate) private returns (uint256)
    {
        uint256 owing = GetAddressDividends(addressToUpdate);
        
        if(owing > 0) 
        {
            balances[addressToUpdate] = balances[addressToUpdate].add(owing);
            addressLastDividends[addressToUpdate] = totalHolderShareFees;
        }
        
        return balances[addressToUpdate];
    }
    
    /**
    * @dev Adds liquidity to liquidity pool and burns the LP tokens received
    */
    function AddLiquidity(uint256 amount) private
    {
        uint256 half = amount.div(2);
        uint256 otherHalf = amount.sub(half);

        uint256 initialBalance = address(this).balance;

        ChangeTokensToETH(half);

        uint256 newBalance = address(this).balance.sub(initialBalance);

        ApproveTransaction(address(this), address(UniswapV2Router), otherHalf);

        UniswapV2Router.addLiquidityETH{value: newBalance}(address(this), otherHalf, 0, 0, address(0), block.timestamp);
        
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
    
    /**
    * @dev Tokens are changed to ETH. Necessary to add liquidity
    */
    function ChangeTokensToETH(uint256 amount) private
    {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = UniswapV2Router.WETH();

        ApproveTransaction(address(this), address(UniswapV2Router), amount);

        UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, address(this), block.timestamp);
    }
    
    /**
    * @dev To recieve ETH from uniswapV2Router when swapping
    */
    receive() external payable {}
}
