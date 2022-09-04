import * as fs from "fs";

type Board = (number | null)[][];

const ROWS_PER_BOARD = 5;
const COLUMN_INDICES = [0, 1, 2, 3, 4];

class Bingo {
  numsToDraw: number[];
  boards: Board[];
  lastBoardToWin: Board | undefined;

  DRAWN = null;

  constructor(inputFilename: string) {
    const input = fs.readFileSync(inputFilename, "utf8").split("\n");

    this.numsToDraw = input[0].split(",").map(Number);

    const boardsToRead = (input.length - 2) / (ROWS_PER_BOARD + 1);
    this.boards = [];
    for (let i = 0; i < boardsToRead; i++) {
      const boardStartIndex = 2 + i * (ROWS_PER_BOARD + 1);
      const board = input.slice(
        boardStartIndex,
        boardStartIndex + ROWS_PER_BOARD
      );
      this.boards.push(Bingo.readBoard(board));
    }

    this.lastBoardToWin = undefined;
  }

  static readBoard = (rows: string[]) => {
    return rows.map((row) => row.split(" ").filter(Boolean).map(Number));
  };

  static boardIsWinner = (board: Board) => {
    return (
      board.some((row) => row.every((cell) => cell === null)) ||
      COLUMN_INDICES.some((i) => board.every((row) => row[i] === null))
    );
  };

  static boardScore = (board: Board) => {
    return board.reduce<number>(
      (acc, row) =>
        acc + row.reduce<number>((acc, num) => (num ? acc + num : acc), 0),
      0
    );
  };

  /**
   * Return whether or not board is winner
   */
  markBoard = (board: Board, drawnNum: number) => {
    for (const row of board) {
      for (let i = 0; i < row.length; i++) {
        if (row[i] === drawnNum) {
          row[i] = null;
          if (Bingo.boardIsWinner(board)) {
            this.lastBoardToWin = board;
            return true;
          } else {
            return false;
          }
        }
      }
    }
    return false;
  };

  draw = () => {
    const drawnNum = this.numsToDraw.shift();
    if (drawnNum === undefined) {
      throw new Error("No more numbers to draw!");
    }

    this.boards = this.boards.filter(
      (board) => !this.markBoard(board, drawnNum)
    );

    if (this.boards.length === 0 && this.lastBoardToWin) {
      return Bingo.boardScore(this.lastBoardToWin) * drawnNum;
    }
  };
}

const bingo = new Bingo("../inputs/day04.txt");

// eslint-disable-next-line no-constant-condition
while (true) {
  const result = bingo.draw();
  if (result !== undefined) {
    console.log(result);
    break;
  }
}

// Answer: 17408
