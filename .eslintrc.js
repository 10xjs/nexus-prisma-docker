module.exports = {
  root: true,
  parserOptions: {
    ecmaFeatures: {
      legacyDecorators: true,
    },
    sourceType: "module",
    ecmaVersion: 2020,
  },
  plugins: ["vue", "@typescript-eslint", "prettier"],
  extends: [
    "standard",
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:vue/recommended",
    "@nuxtjs",
    "@nuxtjs/eslint-config-typescript",
    "prettier/@typescript-eslint", // Disable ESLint rules from @typescript-eslint/eslint-plugin that would conflict with prettier
    "prettier/vue",
    "plugin:prettier/recommended", // Make sure this is always the last configuration in the extends array.
  ],
  ignorePatterns: [
    "node_modules",
    "*.d.ts",
    "generated",
    "static/*",
    "dist",
    "build",
    "nuxt",
  ],
  rules: {
    "prettier/prettier": "error",
    "semi": ["error"],
    "semi-style": ["error", "last"]
  },
};
