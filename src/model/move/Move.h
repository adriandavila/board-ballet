#ifndef MOVE_H
#define MOVE_H

#include "Coordinate.h"
#include "Piece.h"

class Move {
  private:
    Coordinate moveFrom;
    Coordinate moveTo;

    Piece *captured;
};

#endif