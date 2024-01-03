#ifndef BOARD_H
#define BOARD_H

#include <vector>

#include "Move.h"
#include "Piece.h"
#include "Square.h"
#include "Subject.h"

class Board: public Subject {
  private: 
    std::vector<std::vector<Square>> board{8, std::vector<Square>(8)};
    std::vector<std::unique_ptr<Piece>> pieces;

    std::vector<Move> moves;

  public: 
    std::string prettyprint();
};

#endif