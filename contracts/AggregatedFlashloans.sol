pragma solidity >= 0.5.0 < 0.7.0;
import "@kollateral/contracts/invoke/IInvoker.sol";
import "@kollateral/contracts/invoke/KollateralInvokable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract AggregatedFlashloans is KollateralInvokable {

  address owner; // contract owner
  address internal INVOKER_ROPSTEN;

  // initialize deployment parameters
  constructor() public{
      owner = msg.sender;
       INVOKER_ROPSTEN = address(0x234A76352e816c48098F20F830A21c820085b902); //Kollateral inovker on Ropsten
  }

  // only the contract owner can call fund
  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  // initializes the flash loan aggregation parameters
  function invoke() external payable {
    address to = address(this);
    bytes memory data = "";
    address tokenAddress = address(0x0000000000000000000000000000000000000001); //Ropsten ETH
    uint256 tokenAmount = 1e18; // i.e. 1 ETH worth
    IInvoker(INVOKER_ROPSTEN).invoke(to, data, tokenAddress, tokenAmount);
  }

  /**
    Mid-flash loan aggregation logic i.e. what you do with
    the temporarily acquired flash liquidity from DyDx and Aave
  */
  function execute(bytes calldata data) external payable {

    // ***Step 1: Arbitrage or liquidation or whatever logic goes here

    repay(); // ***Step 2: Repay the aggregated flash loan + above fees
    /* Remember to factor in:
        + 6bps in Kollateral aggregation fee
        + 9bps in native Aave flash loan fee
        + 2 Wei in native DyDx floan loan fee
    */

  }

  /**
    ***Step 3: sweep entire balance on the contract back to contract owner
  */
  function WithdrawBalance() public payable onlyOwner {
      msg.sender.transfer(address(this).balance); // withdraw all ETH
  }

}
