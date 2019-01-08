pragma solidity ^0.5.0;

library ConcatLib {
  function concat(string[] storage _preBytes, string[] memory _postBytes) internal  {
    for (uint i=0; i < _postBytes.length; i++) {
      _preBytes.push(_postBytes[i]);
    }
  }
}
