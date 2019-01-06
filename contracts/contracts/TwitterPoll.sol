pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;
import "./utils/ConcatLib.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract TwitterPoll is Ownable {
  using ConcatLib for bytes15[];
  string public question;
  string public optionA;
  string public optionB;
  bytes15[][2] public votes;

  constructor(string _question, string _optionA, string _optionB) public {
    question = _question;
    optionA = _optionA;
    optionB = _optionB;
  }

  function submitVotes(bytes15[] _votesForOptionA, bytes15[] _votesForOptionB) public {
    votes[0].concat(_votesForOptionA);
    votes[1].concat(_votesForOptionB);
  }

  function voteCount(uint option) public view returns (uint){
    return votes[option].length;
  }
}
