#ifndef PLAYER_H
#define PLAYER_H

#include "Board.h"
#include "Color.h"

class Player {
  protected:
    Board *board;
    ColorOptions color;
};

#endif