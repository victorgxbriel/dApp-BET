// Nome: Victor Gabriel Araujo Silva
// Nome: Israel Hall Leigthon
// Conta do contrato: 0xC16b22F9f23B1aEb59cE2829321181598Aace7b3

// Seu contrato começa aqui!
  // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Aposta {

    enum Diamonds {
      Sifrao,
      Rose,
      Mesclado,
      Verde
    }

    struct Play {
      Diamonds [4] dados;
      uint value;
      bool result;
      uint ret; 
    }

    address public owner;
    mapping (address => Play[]) private jogadas;

    event ApostaFeita(Play indexed p);

    constructor() payable  {
      owner = msg.sender;
    }

    function apostas() external view returns(Play[] memory) {
      return jogadas[msg.sender];
    }

    function saldo() external view returns(uint) {
      uint val;
      for(uint i = 0; i < jogadas[msg.sender].length; i++){
        val += jogadas[msg.sender][i].ret;
      }
      return val;
    }

    function apostar() external payable returns(Diamonds[4] memory ) {
      require(msg.value > 0, "valor zerado");
      Play memory p;
      p.dados = randomDados();
      p.value = msg.value;
      uint mult = verificar(p.dados);
      p.result = mult == 0 ? false : true;
      p.ret = p.value * mult;
      jogadas[msg.sender].push(p);

      emit ApostaFeita(p);
      return p.dados;
    }

    function resgatar() external payable {
      uint valor;
      for(uint i = 0; i < jogadas[msg.sender].length; i++){
        valor += jogadas[msg.sender][i].ret; 
      }
      require(address(this).balance >= valor, "Contrato quebrado");
      payable(msg.sender).transfer(valor);
      delete jogadas[msg.sender];
    }

    function verificar(Diamonds[4] memory dados) public pure returns(uint) {
      if(dados[0] != dados[1] && dados[0] != dados[2] && dados[0] != dados[3] && dados[1] != dados[2] && dados[1] != dados[3] && dados[2] != dados[3]){
        return 2;
      } else {
        if(dados[0] == dados[1] && dados[0] == dados[2] && dados[0] == dados[3]){
          if(dados[0] == Diamonds.Mesclado)
            return 4;
          else if(dados[0] == Diamonds.Rose)
            return 2;
          else if(dados[0] == Diamonds.Sifrao)
            return 10;
          else if(dados[0] == Diamonds.Verde)
            return 5;
        }
      }
      return 0;
    }

    /*
    function randomDados() public view returns(Diamonds[4] memory) {
      Diamonds[4] memory d;
      for(uint i = 0; i < 4; i++){
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 5;
        if(random == 1) {
          d[i] = Diamonds.Sifrao;
        } else if(random == 2) {
          d[i] = Diamonds.Rose;
        } else if(random == 3){
          d[i] = Diamonds.Mesclado;
        } else if(random == 4){
          d[i] = Diamonds.Verde;
        }
      }
      return d;
    }
    */
    function randomDados() public view returns(Diamonds[4] memory) {
    uint seed = uint(keccak256(abi.encode(block.timestamp, block.difficulty, blockhash(block.number - 1))));
    Diamonds[4] memory d;

    for(uint i = 0; i < 4; i++) {
        uint random = uint(keccak256(abi.encodePacked(seed, i)));
        uint index = random % 4;

        if(index == 0) {
            d[i] = Diamonds.Sifrao;
        } else if(index == 1) {
            d[i] = Diamonds.Rose;
        } else if(index == 2) {
            d[i] = Diamonds.Mesclado;
        } else if(index == 3) {
            d[i] = Diamonds.Verde;
        }
    }

    return d;
  }

}
