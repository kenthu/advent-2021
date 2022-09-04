import * as fs from "fs";

const input = fs.readFileSync("../inputs/day03.txt", "utf8").split("\n");
const lineLength = input[0].length;

const findRating = (
  nums: string[],
  bitSelector: "mostCommon" | "leastCommon"
) => {
  for (let pos = 0; pos < lineLength; pos++) {
    const counts = { "0": 0, "1": 0 };
    for (const num of nums) {
      const bit = num[pos];
      if (bit !== "0" && bit !== "1") {
        throw new Error("Invalid bit");
      }
      counts[bit]++;
    }

    let filterBit: "0" | "1";
    if (bitSelector === "mostCommon") {
      filterBit = counts["1"] >= counts["0"] ? "1" : "0";
    } else if (bitSelector === "leastCommon") {
      filterBit = counts["1"] >= counts["0"] ? "0" : "1";
    } else {
      throw new Error("Invalid bitSelector");
    }

    nums = nums.filter((num) => num[pos] === filterBit);
    if (nums.length === 1) {
      return parseInt(nums[0], 2);
    }
  }

  throw new Error("Could not find rating");
};

const oxygenGeneratorRating = findRating(input.filter(Boolean), "mostCommon");
const co2ScrubberRating = findRating(input.filter(Boolean), "leastCommon");
console.log(`oxygenGeneratorRating: ${oxygenGeneratorRating}`);
console.log(`co2ScrubberRating: ${co2ScrubberRating}`);

console.log(oxygenGeneratorRating * co2ScrubberRating);

// Answer: 6124992
