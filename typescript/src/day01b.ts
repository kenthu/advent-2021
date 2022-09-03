import * as fs from "fs";

const input = fs
  .readFileSync("../inputs/day01.txt", "utf8")
  .split("\n")
  .map((line) => parseInt(line));

let increases = 0;
for (let i = 0; i < input.length - 3; i++) {
  if (input[i + 3] > input[i]) {
    increases++;
  }
}
console.log(increases);

// Answer: 1518
