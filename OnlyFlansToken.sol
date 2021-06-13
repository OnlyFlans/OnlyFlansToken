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
    
    uint256 private constant pointMultiplier = 10 ** 18;
    uint256 private totalHolderShareFees;
    
    uint256 private constant maxAllowedTokenPerAddress = 10000000000 * (10 ** uint256(Decimals));
    
    //this address is excluded from fees 
    address private projectFundAddress;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;
    mapping (address => uint256) private addressLastDividends;
    
    constructor()
    {
        balances[msg.sender] = TokenMaxSupply;
        projectFundAddress = msg.sender;
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        UniswapV2Router = _uniswapV2Router;
    }
    
    function TotalSupply() public view returns (uint256)
    {
        return TokenMaxSupply;
    }
    
    function CheckAddressBalance(address addressToCheck) public returns (uint256)
    {
        return GetAddressBalanceWithReflection(addressToCheck);
    }
    
    function CheckAllowance(address from, address to) public view returns (uint256)
    {
        return allowances[from][to];
    }
    
    function TransferTo(address addressToSend, uint256 amount) public returns (bool)
    {
        return TransferTokensTo(addressToSend, amount);
    }
    
    function TransferFrom(address sendingAddress, address addressToSend, uint256 amount) public returns (bool)
    {
        return TransferTokensFrom(sendingAddress, addressToSend, amount);
    }
    
    function Burn(uint256 amount) public
    {
        BurnTokens(amount);
    }
    
    function IncreaseAllowance(address addressToIncreae, uint256 amount) public returns (bool)
    {
        return IncreaseAddressAllowance(addressToIncreae, amount);
    }
    
    function DecreaseAllowance(address addressToDecrease, uint256 amount) public returns (bool)
    {
        return DecreaseAddressAllowance(addressToDecrease, amount);
    }
    
    function Approve(address spender, uint256 value) public returns (bool)
    {
        return ApproveTransaction(spender, value);
    }
    
    function TransferTokensTo(address addressToSend, uint256 amount) private returns (bool)
    {
        require(addressToSend != address(0), 'Invalid Address.');
        require(balances[msg.sender] > amount, 'Not enough tokens to transfer.');
        require(balances[addressToSend] + amount <= maxAllowedTokenPerAddress, 'Cannot transfer tokens to this address. Max tokens in address is 1% of total supply');
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        
        uint256 holdersFee = amount.mul(holdersShareFee).div(100);
        uint256 liqFee = amount.mul(liquidityFee).div(100);
        
        totalHolderShareFees = totalHolderShareFees.add(amount);
        
        amount -= holdersFee + liqFee;
                
        balances[addressToSend] = balances[addressToSend].add(amount);
        
        emit Transfer(msg.sender, addressToSend, amount);
        return true;
    }
    
    function TransferTokensFrom(address sendingAddress, address addressToSend, uint256 amount) private returns (bool)
    {
        require(addressToSend != address(0), 'Invalid Address.');
        require(sendingAddress != address(0), 'Invalid sending Address.');
        require(balances[sendingAddress] >= amount, 'Not enough tokens to transfer.');
        require(allowances[sendingAddress][msg.sender] >= amount, 'Allowance is not enough');
        require(balances[addressToSend] + amount <= maxAllowedTokenPerAddress, 'Cannot transfer tokens to this address. Max tokens in address is 1% of total supply');

        balances[sendingAddress] = balances[sendingAddress].sub(amount);
        
        uint256 holdersFee = amount.mul(holdersShareFee).div(100);
        uint256 liqFee = amount.mul(liquidityFee).div(100);
        
        totalHolderShareFees = totalHolderShareFees.add(amount);
        
        amount -= holdersFee + liqFee;
        
        balances[addressToSend] = balances[addressToSend].add(amount);
        allowances[sendingAddress][msg.sender] = allowances[sendingAddress][msg.sender].sub(amount);
        emit Transfer(sendingAddress, addressToSend, amount);
        return true;
    }
    
    function BurnTokens(uint256 amount) private
    {
        require(msg.sender != address(0), 'Invalid Address.');
        require(balances[msg.sender] >= amount, 'Not enough tokens to burn');
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        TokenMaxSupply = TokenMaxSupply.sub(amount);
        
        emit Transfer(msg.sender, address(0), amount);
    }
    
    function IncreaseAddressAllowance(address addressToIncreae, uint256 amount) private returns (bool)
    {
        require(addressToIncreae != address(0), 'Invalid Address.');
        allowances[msg.sender][addressToIncreae] = (allowances[msg.sender][addressToIncreae].add(amount));
        emit Approval(msg.sender, addressToIncreae, allowances[msg.sender][addressToIncreae]);
        return true;
    }
    
    function DecreaseAddressAllowance(address addressToDecrease, uint256 amount) private returns (bool)
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
    
    function ApproveTransaction(address otherAddress, uint256 value) private returns (bool) 
    {
        allowances[msg.sender][otherAddress] = value;
        emit Approval(msg.sender, otherAddress, value);
        return true;
    }
    
    function GetAddressDividends(address addressToCheck) private view returns(uint256) 
    {
        uint256 newDividendPoints = totalHolderShareFees - addressLastDividends[addressToCheck];
        return (balances[addressToCheck].mul(newDividendPoints)).div(pointMultiplier);
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
}
