// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract  testMulticall{
    function test1 (uint _i) external view returns (uint, uint){
        return (_i, block.timestamp);
    }
    function test2 (uint _i) external view returns (uint, uint){
        return (_i, block.timestamp);
    }

    //to call the above 2 function together from another or from this contract we have to get data from this 2 functions

    function getData1 (uint _i) external pure returns(bytes memory){
        //return abi.encodeWithSignature(_name(uint)", _i);
        return abi.encodeWithSelector(this.test1.selector,_i);
    }
     function getData2 (uint _i) external pure returns(bytes memory){
        //return abi.encodeWithSignature(_name(uint)", _i);
        return abi.encodeWithSelector(this.test2.selector,_i);
    }
}


contract Multicall{
    function multiCall(address[] calldata _address, bytes[] calldata data)
    external
    view
    returns (bytes[] memory)
    {
        //it is required that address of the targets and bytes of the data are same
        require (_address.length == data.length, "Invalid numbers");

        // creating bytes array in memory to return the length of the data
        bytes[] memory results = new bytes[] (data.length);

        //if current function make some txn we have to use call but we use view thats why we have to use staticcall
        for(uint i; i < data.length; i++){
            (bool sucess, bytes memory result) = _address[i].staticcall(data[i]);
            require (sucess, "call failed");
            results[i] = result;
        }
        return results;
    }
}