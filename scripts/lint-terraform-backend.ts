#!/usr/bin/env tsx
// Path: scripts/lint-terraform-backend.ts

/**
 * Validates that Terraform backend S3 key matches the file's directory path.
 * Expected format: <repo-name>/<path/to/directory>/terraform.tfstate
 *
 * Usage: pnpm tsx scripts/lint-terraform-backend.ts [file1] [file2] ...
 * If no files provided, validates all backend.tf files in terraform/ directory.
 */

import fs from "fs";
import path from "path";
import { globSync } from "glob";

const REPO_NAME = "new-startup-landing";

interface ValidationResult {
  valid: boolean;
  skipped?: boolean;
  error?: string;
}

function validateBackendKey(filePath: string): ValidationResult {
  const content = fs.readFileSync(filePath, "utf-8");

  // Check if file contains terraform backend "s3" block
  const backendMatch = content.match(
    /terraform\s*\{[\s\S]*?backend\s+"s3"\s*\{([\s\S]*?)\}/
  );

  if (!backendMatch) {
    // No S3 backend block found, skip validation
    return { valid: true, skipped: true };
  }

  const backendBlock = backendMatch[1];

  // Extract the key value
  const keyMatch = backendBlock.match(/key\s*=\s*"([^"]+)"/);

  if (!keyMatch) {
    return {
      valid: false,
      error: `No 'key' attribute found in backend "s3" block`,
    };
  }

  const actualKey = keyMatch[1];

  // Calculate expected key based on file path
  // Get the directory relative to repo root
  const absoluteDir = path.dirname(path.resolve(filePath));
  const repoRoot = process.cwd();
  const relativeDir = path.relative(repoRoot, absoluteDir);

  const expectedKey = `${REPO_NAME}/${relativeDir}/terraform.tfstate`;

  if (actualKey !== expectedKey) {
    return {
      valid: false,
      error: `Backend key mismatch:\n  Expected: "${expectedKey}"\n  Actual:   "${actualKey}"`,
    };
  }

  return { valid: true };
}

function findBackendFiles(): string[] {
  return globSync("terraform/**/backend.tf", { cwd: process.cwd() });
}

function main(): void {
  let files = process.argv.slice(2);

  if (files.length === 0) {
    files = findBackendFiles();
    if (files.length === 0) {
      console.log("No backend.tf files found in terraform/ directory.");
      return;
    }
    console.log(`Found ${files.length} backend.tf file(s) to validate.\n`);
  }

  let hasErrors = false;
  const green = "\x1b[32m";
  const red = "\x1b[31m";
  const reset = "\x1b[0m";

  for (const file of files) {
    const result = validateBackendKey(file);

    if (result.skipped) {
      console.log(`${green}✓${reset} ${file} (no S3 backend block, skipped)`);
    } else if (result.valid) {
      console.log(`${green}✓${reset} ${file}`);
    } else {
      console.error(`${red}✗${reset} ${file}`);
      console.error(`  ${result.error}`);
      hasErrors = true;
    }
  }

  if (hasErrors) {
    process.exit(1);
  }
}

main();
