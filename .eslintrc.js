module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true
    },
    "extends": [
      "eslint:recommended",
      "plugin:vue/recommended"
    ],
    "parserOptions": {
        "ecmaVersion": 6,
        "sourceType": "module"
    },
    "globals": {
      "_": true,
      "axios": true,
      "describe": true,
      "it": true,
      "beforeEach": true,
      "beforeAll": true,
      "afterEach": true,
      "afterAll": true,
      "expect": true,
      "assert": true,
      "sinon": true
    },
    "rules": {
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "double"
        ],
        "semi": [
            "error",
            "always"
        ]
    },
    "plugins": [
      "vue"
    ]
};
