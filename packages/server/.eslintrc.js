module.exports = {
  root: false,
  env: {
    browser: true,
    node: true,
  },
  parserOptions: {
    ecmaFeatures: {
      legacyDecorators: true,
    },
    sourceType: "module",
    ecmaVersion: 2020,
  },
  extends: ["../../.eslintrc.js"],
  rules: {
    "prettier/prettier": "error",
    "space-before-function-paren": 0,
    quotes: [
      "error",
      "double",
      { avoidEscape: true, allowTemplateLiterals: false },
    ],
    semi: ["error"],
    "semi-style": ["error", "last"]
  },
};
