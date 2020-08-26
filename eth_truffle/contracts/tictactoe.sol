pragma solidity >= 0.5.1;

contract TicTacToe{
    
    address payable public player1;
    address payable public player2;
    
    address [3][3] board;
    uint8[3][3] board_h;
    uint8 public boardsize = 3;
    
    address payable private activatePlayer;
    
    address payable public gameWiner;
    
    bool gameActive = false;
    
    uint8 movesCounter;
    
    event ActivatePlayer(address player);
    event PlayerJoined_0858713(address player);
    event NextPlayer_0858713(address player);
    
    event GameoverWithWinner(address winner);
    event GameoverWithDraw();
    
    uint constant public gameCost = 0.1 ether;
    
    uint balance2withdrawPlay1;
    uint balance2withdrawPlay2;
    
    event PayoutSuccess(address payable receiver, uint amount);
    
    uint timeToReact = 3 minutes;
    uint gameValidUntil;
    
    constructor() public payable{
        player1 = msg.sender;
        
        require(msg.value==gameCost);
        
        gameValidUntil = now + timeToReact;
    }
    
    function joinGame( ) public payable{
        assert(player2==address(0));
        player2 = msg.sender;
        
        //activatePlayer = player1;
        gameActive = true;
        
        
        if (block.number%2 ==0){
            activatePlayer = player2;
        }else{
            activatePlayer = player1;
        }
        
        require(msg.value==gameCost);
        
        emit ActivatePlayer(activatePlayer);

        emit PlayerJoined_0858713(player1);
        emit NextPlayer_0858713(player2);
        
        gameValidUntil = now + timeToReact;
    }
    
    function setStone(uint8 x, uint8 y) public{
        
        assert(gameActive);
        
        assert(x<boardsize);
        assert(y<boardsize);
        assert(board[x][y]==address(0));
        
        require(activatePlayer==msg.sender);
        
        require(gameValidUntil > now);
        
        board[x][y] = msg.sender;
        toHuman();
        
        if  (winCheck()){
            setWinner(activatePlayer);
            return;
        }
        
        if(activatePlayer==player1){
            activatePlayer=player2;
        }else{
            activatePlayer=player1;
        }
        
        emit NextPlayer_0858713(activatePlayer);
        
        movesCounter++;
        
        if (movesCounter==(boardsize**2)){
            setDraw();
            
        }
        
        gameValidUntil = now + timeToReact;
        
    }
    
    function winCheck() public view returns(bool){
        // [0,0] | [0,1] | [0,2]
        //----------------------
        // [1,0] | [1,1] | [1,2]
        //----------------------
        // [2,0] | [2,1] | [2,2]
        
        for (uint8 i=0; i<3; i++){
            if (board[0][i]==activatePlayer && board[1][i]==activatePlayer && board[2][i]==activatePlayer){
                return true;
            }
            
            if (board[i][0]==activatePlayer && board[i][1]==activatePlayer && board[i][2]==activatePlayer){
                return true;
            }
        }
        
        if (board[0][0]==activatePlayer && board[1][1]==activatePlayer && board[2][2]==activatePlayer){
            return true;
        }else if (board[0][2]==activatePlayer && board[1][1]==activatePlayer && board[2][0]==activatePlayer){
            return true;
        }
    
        return false;
    }
    
    
    function setDraw() private{
        gameActive = false;
        emit GameoverWithDraw();
        
        uint balance2send = address(this).balance/2;
        balance2withdrawPlay1 = balance2send;
        balance2withdrawPlay2 = balance2send;
        withDrawBoth();
    }
    
    function setWinner(address payable player) private{
        gameWiner = player;
        gameActive = false;
        emit GameoverWithWinner(player);
        
        uint balance2send = address(this).balance;
        
        if (player.send(balance2send)!=true){
            if (player==player1){
            balance2withdrawPlay1 = balance2send;
            }else if (player==player2){
                balance2withdrawPlay2 = balance2send;
            }
        }else{
            emit GameoverWithWinner(player);
        }
        
        //withDrawWin();
    }
    
    function withDrawWin() public payable{
        if(msg.sender==player1){
            require(balance2withdrawPlay1>0);
            player1.transfer(balance2withdrawPlay1);
            balance2withdrawPlay1=0;
            emit PayoutSuccess(player1,balance2withdrawPlay1);
        }else{
            require(balance2withdrawPlay2>0);
            player2.transfer(balance2withdrawPlay2);
            balance2withdrawPlay2=0;
            emit PayoutSuccess(player2,balance2withdrawPlay2);
        }
        
        
    }
    
    function withDrawBoth() public payable{
        require(balance2withdrawPlay1>0);
        require(balance2withdrawPlay2>0);
        
        player1.transfer(balance2withdrawPlay1);
        balance2withdrawPlay1=0;
        emit PayoutSuccess(player1,balance2withdrawPlay1);
        
        player2.transfer(balance2withdrawPlay2);
        balance2withdrawPlay2=0;
        emit PayoutSuccess(player2,balance2withdrawPlay2);
        
    }
    
    function emergencyCashout() public{
        require(gameValidUntil>now);
        require(gameActive);
        setDraw();
    }
    
    function getBoard() public view returns (address[3][3] memory){
        return board;
    }
    
    function toHuman() private{
        //assert(player2==address(0));
        for(uint8 i=0; i<3; i++){
            for(uint8 j=0; j<3; j++){
                if (board[i][j]==player1){
                    board_h[i][j]=1;
                }else if (board[i][j]==player2){
                    board_h[i][j]=2;
                }
            }
        }
    }
    
    
    function getBoard_h() public view returns (uint8[3][3] memory){
        return board_h;
    }
    
    function getActivate() public view returns (address){
        return activatePlayer;
    }
    
}

