#ifndef PIECE_H
#define PIECE_H

#include "Board.h"
#include "Color.h"
#include "Coordinate.h"

class Piece {
  protected:    
    int value;
    ColorOptions color;
    Coordinate location;
    bool moveMade = false;
    bool isCaptured = false;
};

#endif