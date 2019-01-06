pragma solidity ^0.4.24;

library ConcatLib {
  function concat(bytes15[] storage _preBytes, bytes15[] _postBytes) internal  {
    for (uint i=0; i < _postBytes.length; i++) {
      _preBytes.push(_postBytes[i]);
    }
  }
}
