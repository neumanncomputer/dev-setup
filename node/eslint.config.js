import js from '@eslint/js';
import prettier from 'eslint-config-prettier';
import globals from 'globals';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { ignores: ['node_modules', 'dist'] },
  js.configs.recommended,
  tseslint.configs.recommended,
  // Prettier と衝突する整形系ルールを無効化
  prettier,
  { languageOptions: { globals: globals.node } },
);
