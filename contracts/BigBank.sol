// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract BigBank {
  using SafeMath for uint256;

  IERC20 public usdt;
  mapping (address => uint256) public collateral;
  mapping (address => uint256) public liquidity;
  mapping (address => uint256) public loans;

  constructor(address _usdtAddress) {
    usdt = IERC20(_usdtAddress);
  }

  function addCollateral(uint _amount) public {
    // TODO: take 100usdt for service charges

    usdt.transferFrom(msg.sender, address(this), _amount);
    uint256 userCollateral = collateral[msg.sender];
    collateral[msg.sender] = userCollateral.add(_amount);
  }

  function removeCollateral(uint _amount) public {
    // TODO: check to make sure user is not on loan

    usdt.transfer(msg.sender, _amount);
    uint256 userCollateral = collateral[msg.sender];
    collateral[msg.sender] = userCollateral.sub(_amount); 
  }

  function takeLoan(uint _amount) public {
    // TODO: make sure user only borrows what's less than 91% of their collateral + loaned amount
    usdt.transfer(msg.sender, _amount);
    uint256 userLoan = loans[msg.sender];
    loans[msg.sender] = userLoan.add(_amount); 
  }

  function payBackLoan(uint _amount) public {
    // TODO: make sure user is on loan
    usdt.transferFrom(msg.sender, address(this), _amount);
    uint256 userLoan = loans[msg.sender];
    loans[msg.sender] = userLoan.sub(_amount); 
  }

  function provideLiquidity(uint _amount) public {
    uint256 userLiquidity = liquidity[msg.sender];
    liquidity[msg.sender] = userLiquidity.add(_amount); 
  }

  function removeLiquidity(uint _amount) public {
    // TODO: make sure user provided lquidity is upto the withdraw amount requested
    uint256 userLiquidity = liquidity[msg.sender];
    liquidity[msg.sender] = userLiquidity.sub(_amount); 
  }
}
