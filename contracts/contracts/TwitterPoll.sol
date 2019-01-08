pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
import "./utils/ConcatLib.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract TwitterPoll is Ownable {
  using ConcatLib for string[];
  string public question;
  string[] public yesVotes;
  string[] public noVotes;

  constructor(string memory _question) public {
    question = _question;
  }

  function submitVotes(string[] memory _yesVotes, string[] memory _noVotes) public onlyOwner() {
    yesVotes.concat(_yesVotes);
    noVotes.concat(_noVotes);
  }

  function getYesVotes() public view returns (string[] memory){
    return yesVotes;
  }

  function getNoVotes() public view returns (string[] memory){
    return noVotes;
  }
}
