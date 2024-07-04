// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ReservoirV6_0_0.sol";  // Import the Reservoir contract

contract CallerContract {
    ReservoirV6_0_0 public reservoir;

    event Debug(string message);
    event ExecutionResult(bool success, bytes data);

    constructor(address _reservoirAddress) {
        // Initialize the Reservoir contract address
        reservoir = ReservoirV6_0_0(payable(_reservoirAddress));
    }

    function callExecute() external payable {
        // Prepare the ExecutionInfo array
        ReservoirV6_0_0.ExecutionInfo[] memory executionInfos = new ReservoirV6_0_0.ExecutionInfo[](1);

        // Example of data to send (this should be tailored to the function you want to call)
        bytes memory data = abi.encodeWithSignature("exampleFunction()");

        // Fill the ExecutionInfo struct
        executionInfos[0] = ReservoirV6_0_0.ExecutionInfo({
            module: address(this),  // The address of the contract to call
            data: data,             // The calldata to send
            value: 1              // The value to send with the call (in wei)
        });

        // Log a debug message
        emit Debug("Calling execute function on Reservoir");

        // Call the execute function on the Reservoir contract
        try reservoir.execute{value: msg.value}(executionInfos) {
            // Log success
            emit Debug("Execution successful");
        } catch Error(string memory reason) {
            // Log the error reason
            emit Debug(reason);
        } catch (bytes memory reason) {
            // Log the error reason
            emit ExecutionResult(false, reason);
        }
    }

    // Example function to be called
    function exampleFunction() external {
        // Logic of the example function
        emit Debug("exampleFunction called");
    }
}
