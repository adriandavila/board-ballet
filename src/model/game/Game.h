#ifndef GAME_H
#define GAME_H

#include <vector>

#include "Board.h"
#include "Player.h"

class Game {
  public:
    enum BoardState {Active=0, WhiteWin, BlackWin, Stalemate};
    
  private:
    std::vector<std::unique_ptr<Player>> players;
    Board* board;
    Player* current_turn;
    BoardState state;
};

#endif