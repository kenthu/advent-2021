import { count } from "console";
import * as fs from "fs";

interface Line {
  x1: number,
  y1: number,
  x2: number,
  y2: number,
}

type Grid = number[][];

const readLines = (inputFilename: string): Line[] => {
  const input = fs.readFileSync(inputFilename, "utf8").split("\n");

  return input.filter(Boolean).map((inputLine) => {
    const points = inputLine.split(" -> ").map(point => point.split(",").map(Number));
    return {
      x1: points[0][0],
      y1: points[0][1],
      x2: points[1][0],
      y2: points[1][1],
    }
  });
}

const processLines = (lines: Line[], gridWidth: number, gridHeight: number) => {
  const grid: Grid = new Array(gridHeight).fill(null).map(() => new Array(gridWidth).fill(0));

  for (const { x1, y1, x2, y2 } of lines) {
    if (x1 === x2) {
      // Vertical line
      const [start, end] = y1 <= y2 ? [y1, y2] : [y2, y1];
      for (let y = start; y <= end; y++) {
        grid[x1][y]++;
      }
    } else if (y1 === y2) {
      // Horizontal line
      const [start, end] = x1 <= x2 ? [x1, x2] : [x2, x1];
      for (let x = start; x <= end; x++) {
        grid[x][y1]++;
      }
    }
  }

  return grid;
};

const printGrid = (grid: Grid) => {
  for (const row of grid) {
    console.log(row.join(" "));
  }
};

const countOverlaps = (grid: Grid) => {
  return grid.map((row) => row.filter(numLines => numLines >= 2).length).reduce((a, b) => a + b);
}

const lines = readLines("../inputs/day05-test.txt");
// for (const line of lines) {
//   console.log(JSON.stringify(line, null, 2));
// }
const grid = processLines(lines, 10, 10);
// printGrid(grid);
console.log(countOverlaps(grid));
// Answer: 

// compare to ruby!
