// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave{

        address waver;
        string message;
        uint256 timestamp;

    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;


    constructor() payable {
        console.log("Contrato no ar!");
        seed = (block.timestamp + block.difficulty) % 100;

    }

    function wave(string memory _message) public {

        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Espere 30segundos");

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s tchauzinho", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed <= 50){
            console.log("%s venceu!",msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            
            require(
                prizeAmount <= address(this).balance,
                "Tentando sacar mais dinheiro que o contrato possui."
            );
            (bool sucess,) = (msg.sender).call{value: prizeAmount}("");
            require(sucess, "Falhou em sacar dinheiro do contrato");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllwaves() public view returns (Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("Temos um total de %d tchauzinhos!", totalWaves);
        return totalWaves;
    }
}