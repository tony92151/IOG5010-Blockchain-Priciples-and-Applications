import Web3 from "web3";
//import metaCoinArtifact from "../../build/contracts/MetaCoin.json";

import contract from "truffle-contract";

import tictactoe_artifacts from "../../build/contracts/TicTacToe.json";

import "./style.css"

import $ from "jquery"

var TicTacToeIns, account, accounts;

const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    TicTacToe.setProvider(web3.currentProvider);

    await web3.eth.getAccounts(function(err,accs){
      if(err!=nulll){
        alert("therev was an error");
        return;
      }
      if(accs.length==0){
        alert("Couldn't get any accounts")
      }

      accounts = accs;
      account = accounts[0];
      console.log(account);
    });

    // createNewGame: function(){
    //   TicTacToe.new(TicTacToe.new({from: account, value: web3.utils.toWei('0.1','ether'),gas: 3000000}).then(instance=>{
    //     TicTacToeIns = instance;

    //     console.log(instance);

    //   }).then(error=> {
    //     console.log(error);
    //   }),
    // };

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = metaCoinArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        metaCoinArtifact.abi,
        deployedNetwork.address,
      );

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

      
    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }

    // createNewGame: function(){
    //   TicTacToe.new({from: account, value: this.web3.utils.toWei('0.1','ether'),gas: 3000000}).then(instance=>{
    //     TicTacToeIns = instance;
    //     console.log(instance);
    //   }).catch(error=> {
    //     console.log(error);
    //   })
    // }
  },

  // createNewGame: function(){
  //   console.log("Create Game called");
  //   TicTacToe.new(TicTacToe.new({from: account, value: web3.utils.toWei('0.1','ether'),gas: 3000000}).then(instance=>{
  //     TicTacToeIns = instance;
  //     console.log()
  //   })
  // },
  // joinGame: function(){
  //   console.log("joinGame Called");
  // }
  createNewGame: function(){
    TicTacToe.new({from: account, value: this.web3.utils.toWei('0.1','ether'),gas: 3000000}).then(instance=>{
      TicTacToeIns = instance;

      console.log(instance);

    }).catch(error=> {
      console.log(error);
    })
  }
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
    );
  }

  App.start();
});
