var TicTacToe = artifacts.require("TicTacToe");

contract("TicTacToe", function(accounts){
    console.log(accounts);

    it ("should be possible to win", function(){

        var TicTacToeinstance;

        var platerOne = accounts[0];
        var platerTwo = accounts[1];

        return TicTacToe.new({from: platerOne, value: web3.utils.toWei('0.1','ether')}).then(function(instance){
            TicTacToeinstance = instance;
            return TicTacToeinstance.joinGame({from: platerTwo, value: web3.utils.toWei('0.1','ether')});
        }).then(txResult=> {
            console.log(txResult.logs[0].args.player);
            return TicTacToeinstance.setStone(0,0,{from: txResult.logs[0].args.player});
        }).then(txResult=> {
            console.log(txResult.logs[0].args.player);
            return TicTacToeinstance.setStone(1,1,{from: txResult.logs[0].args.player});
        }).then(txResult=> {
            console.log(txResult.logs[0].args.player);
            return TicTacToeinstance.setStone(0,1,{from: txResult.logs[0].args.player});
        }).then(txResult=> {
            console.log(txResult.logs[0].args.player);
            return TicTacToeinstance.setStone(1,0,{from: txResult.logs[0].args.player});
        }).then(txResult=> {
            console.log(txResult.logs[0].args.player);
            return TicTacToeinstance.setStone(0,2,{from: txResult.logs[0].args.player});

        }).then(txResult=> {
            console.log(txResult);
            
        }).catch(err=> {
            console.log(err);
        })
    })
});