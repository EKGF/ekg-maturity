/** @type {import('@commitlint/types').UserConfig} */
const config = {
  extends: ["@commitlint/config-angular"],
  rules: {
    // Angular style: stricter rules
    "subject-case": [
      2,
      "never",
      ["start-case", "pascal-case", "upper-case"],
    ],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "scope-case": [2, "always", "lower-case"],
  },
};

module.exports = config;
