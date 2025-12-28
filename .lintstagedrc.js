import path from "path";

export default {
  "*.{ts,tsx,js,jsx,md,yaml,yml}": "prettier --write",
  "*.tf": [
    "pnpm tsx scripts/lint-terraform-backend.ts",
    "terraform fmt",
    (filenames) => {
      const dirs = [...new Set(filenames.map((file) => path.dirname(file)))];
      return dirs.map((dir) => `tflint --chdir=${dir}`);
    },
    "pnpm tsx scripts/add-file-path.ts --fix",
  ],
  "*.tfvars": ["terraform fmt", "pnpm tsx scripts/add-file-path.ts --fix"],
};
