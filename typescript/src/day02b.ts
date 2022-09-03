import * as fs from "fs";

const input = fs.readFileSync("../inputs/day02.txt", "utf8").split("\n");

let horizontalPosition = 0;
let depth = 0;
let aim = 0;

for (const line of input) {
  if (!line) {
    continue;
  }
  const [command, arg] = line.split(" ");
  const numArg = parseInt(arg);
  switch (command) {
    case "forward":
      horizontalPosition += numArg;
      depth += aim * numArg;
      break;
    case "down":
      aim += numArg;
      break;
    case "up":
      aim -= numArg;
      break;
    default:
      throw new Error("Unrecognized command");
  }
}

console.log(horizontalPosition * depth);

// Answer: 1963088820
