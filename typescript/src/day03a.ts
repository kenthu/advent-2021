import * as fs from "fs";

const input = fs.readFileSync("../inputs/day03.txt", "utf8").split("\n");
const lineLength = input[0].length;

// At each position, how many 1s and 0s we've seen
const counts = Array.from({ length: lineLength }, () => ({
  "0": 0,
  "1": 0,
}));

for (const line of input.filter(Boolean)) {
  for (let pos = 0; pos < lineLength; pos++) {
    const bit = line[pos];
    if (bit === "0" || bit === "1") {
      counts[pos][bit]++;
    }
  }
}

// Using most common bit
let gammaRate = "";
// Using least common bit
let epsilonRate = "";

for (const countForPos of counts) {
  gammaRate += countForPos["1"] > countForPos["0"] ? "1" : "0";
  epsilonRate += countForPos["1"] > countForPos["0"] ? "0" : "1";
}

console.log(parseInt(gammaRate, 2) * parseInt(epsilonRate, 2));

// Answer: 1071734
