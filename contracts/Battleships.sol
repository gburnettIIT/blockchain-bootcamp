pragma solidity ^0.4.19;


interface Battleships {

    event ShipPlaced(
        address indexed by,
        uint8 x,
        uint8 y,
        uint shipId
    );

    event ShipSunk(
        address indexed sunkBy,
        address indexed ownedBy,
        uint shipId
    );

    event GameStarted(
        address indexed player,
        address indexed opponent
    );

    event TurnPlayed(
        address indexed player,
        address indexed opponent,
        uint8 x,
        uint8 y,
        uint8 result
    );

    event GameEnded(
        address indexed player,
        address indexed opponent,
        uint8 result
    );

    /**
     * Starts a new game between `msg.sender` and the nominated opponent.
     * MUST emit the `GameStarted` event.
     * @param opponent The address you are playing against.
     */
    function startGame(address opponent) external;

    /**
     * At the start of the game each player must place their ships, one at a time.
     *
     * Ship Types
     *
     *   | Type       | size  | count
     * 1 | Tug        | 1 x 1 | 1
     * 2 | Frigate    | 1 x 2 | 2
     * 3 | Destroyer  | 1 x 3 | 2
     * 4 | Battleship | 1 x 4 | 2
     * 5 | Carrier    | 2 x 5 | 1
     *
     * The ships get placed one at a time until there are no more ships.
     * The function MUST throw if the placed ship overlaps with another.
     *
     * @param x The horizontal grid location of the top-left corner of the ship.
     * @param y The vertical grid location of the top-left corner of the ship.
     * @param ship The type of ship.
     * @param direction The direction the ship is facing. (0 is down, 1 is across)
     */
    function placeShip(uint8 x, uint8 y, uint8 ship, uint8 direction) external;

    /**
     * A shot is fired.
     * MUST emit `TurnPlayed` event with the result of the shot.
     * Results are either `0` for a miss, or the int8 representing the ship type that was hit.
     * If a hits on a ship account for more than 50% of its size then it is sunk.
     * A negative number denotes that part of the ship was hit.
     * If a ship is sunk then the ship is removed from the board emit a `ShipSunk` event.
     * @param x The horizontal grid location of the shot.
     * @param y The vertical grid location of the shot.
     */
    function playTurn(uint8 x, uint8 y) external;

    /**
     * gets your opponent's address
     * @return the address of your current opponent. Returns 0x0 if youare not playing.
     */
    function getOpponent() external view returns (address);

    /**
     * Get the current content of the nominated cell for the player.
     * Results are either `0` for nothing, or the uint8 representing the ship type.
     * If a hits on a ship account for more than 50% of its size then it is sunk
     * and the ship is removed from the board. If this happens emit a `ShipSunk` event.
     * @param x The horizontal grid location of the player's grid cell.
     * @param y The vertical grid location of the player's grid cell.
     */
    function getCell(uint8 x, uint8 y) external view returns (uint8);

    /**
     * Have all of the ships of the given type been placed?
     * @param shipType The type of ship you are checking on, or if 0 it checks all ship types.
     * @return true if all the ships of the given type have been placed.
     */
    function allShipsPlaced(uint8 shipType) external view returns (bool);

    /**
     * The address of the player whose turn it is.
     * @return the current player's address.
     */
    function whoseTurn() external view returns (address);

    /**
     * Check if the game is still going.
     * @return true if the one of the players has no remaining ships.
     */
    function isGameOver() external view returns (bool);
}
