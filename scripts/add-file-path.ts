// Path: scripts/add-file-path.ts

/**
 * add-file-path.ts
 *
 * A utility script to prepend standardized "file path headers" to files.
 * Currently supports Terraform files (.tf, .tfvars), extensible for other types.
 *
 * Usage:
 *   bun scripts/add-file-path.ts [--fix] <file-or-dir> [file-or-dir...]
 *
 * Modes:
 *   lint (default): Reports files missing or having incorrect headers without modifying them
 *   fix (--fix):    Adds or updates headers in files
 *
 * Examples:
 *   bun scripts/add-file-path.ts terraform/              # Lint mode (dry run)
 *   bun scripts/add-file-path.ts --fix terraform/        # Fix mode (writes changes)
 *   bun scripts/add-file-path.ts terraform/staging/networking/dns/main.tf
 *   bun scripts/add-file-path.ts --fix terraform/modules terraform/staging
 */

import { readFileSync, writeFileSync, statSync, readdirSync } from "fs";
import { join, relative, extname, resolve } from "path";

// ---------------------------------------------------------------------------
// Configuration Types
// ---------------------------------------------------------------------------

interface HeaderConfig {
  /** Glob-style extensions pattern, e.g., "*.{tf,tfvars}" */
  pattern: string;
  /** The prefix to use for the header line (e.g., "# Path: " or "// Path: ") */
  prefix: string;
  /** File extensions this config applies to (derived from pattern) */
  extensions: string[];
}

// ---------------------------------------------------------------------------
// Global Ignore Patterns
// ---------------------------------------------------------------------------

/** Regex patterns for directories/files to ignore during traversal */
const IGNORE_PATTERNS: RegExp[] = [
  /\.git/,
  /\.wrangler/,
  /\.tanstack/,
  /\.vscode/,
  /\.husky/,
  /\.terraform/,
  /node_modules/,
  /build/,
  /dist/,
  /dist-ssr/,
  /routeTree\.gen\.ts$/,
  /LICENSE/,
];

// ---------------------------------------------------------------------------
// Header Configurations
// ---------------------------------------------------------------------------

const HEADER_CONFIGS: HeaderConfig[] = [
  {
    pattern: "*.{tf,tfvars}",
    prefix: "# Path: ",
    extensions: [".tf", ".tfvars"],
  },
  // Future: JS/TS support
  // {
  //   pattern: "*.{js,ts,jsx,tsx}",
  //   prefix: "// Path: ",
  //   extensions: [".js", ".ts", ".jsx", ".tsx"],
  // },
];

// ---------------------------------------------------------------------------
// Helper Functions
// ---------------------------------------------------------------------------

/**
 * Get the project root directory (where package.json is located)
 */
function getProjectRoot(): string {
  return resolve(process.cwd());
}

/**
 * Find the header config for a given file extension
 */
function getHeaderConfig(filePath: string): HeaderConfig | undefined {
  const ext = extname(filePath).toLowerCase();
  return HEADER_CONFIGS.find((config) => config.extensions.includes(ext));
}

/**
 * Check if a directory path matches any ignore pattern
 */
function shouldIgnoreDirectory(dirPath: string): boolean {
  return IGNORE_PATTERNS.some((pattern) => pattern.test(dirPath));
}

/**
 * Get all matching files from a path (file or directory)
 */
function getFilesToProcess(inputPath: string, projectRoot: string): string[] {
  const absolutePath = resolve(inputPath);
  const files: string[] = [];

  try {
    const stat = statSync(absolutePath);

    if (stat.isFile()) {
      // Check if the file matches any supported extension
      if (getHeaderConfig(absolutePath)) {
        files.push(absolutePath);
      }
    } else if (stat.isDirectory()) {
      // Recursively traverse directory
      traverseDirectory(absolutePath, files, projectRoot);
    }
  } catch (error) {
    console.error(`Error accessing path: ${inputPath}`, error);
  }

  return files;
}

/**
 * Recursively traverse a directory and collect matching files
 */
function traverseDirectory(
  dirPath: string,
  files: string[],
  projectRoot: string
): void {
  const relativeDirPath = relative(projectRoot, dirPath);

  // Check if this directory should be ignored
  if (shouldIgnoreDirectory(relativeDirPath)) {
    return; // Skip this directory entirely
  }

  try {
    const entries = readdirSync(dirPath, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = join(dirPath, entry.name);

      if (entry.isDirectory()) {
        // Check if directory should be ignored
        const relPath = relative(projectRoot, fullPath);
        if (!shouldIgnoreDirectory(relPath)) {
          traverseDirectory(fullPath, files, projectRoot);
        }
      } else if (entry.isFile()) {
        const config = getHeaderConfig(fullPath);
        if (config) {
          files.push(fullPath);
        }
      }
    }
  } catch (error) {
    console.error(`Error reading directory: ${dirPath}`, error);
  }
}

/**
 * Process a single file: add, update, or skip the header
 * @param fix - If true, writes changes to file. If false, only reports what would change.
 */
function processFile(
  filePath: string,
  projectRoot: string,
  fix: boolean
): { action: "added" | "updated" | "skipped"; file: string } {
  const config = getHeaderConfig(filePath);
  if (!config) {
    return { action: "skipped", file: filePath };
  }

  const relativePath = relative(projectRoot, filePath);
  const expectedHeader = `${config.prefix}${relativePath}`;

  let content = readFileSync(filePath, "utf-8");
  const lines = content.split("\n");
  const firstLine = lines[0] || "";

  // Check if the first line already has the correct header
  if (firstLine === expectedHeader) {
    return { action: "skipped", file: relativePath };
  }

  // Check if the first line has an existing header (same prefix)
  const hasExistingHeader = firstLine.startsWith(config.prefix);

  let newContent: string;
  let action: "added" | "updated";

  if (hasExistingHeader) {
    // Replace the existing header
    // Also handle the case where there's already a blank line after
    let restOfContent: string;

    if (lines.length > 1 && lines[1] === "") {
      // There's already a blank line after header, keep the rest
      restOfContent = lines.slice(2).join("\n");
    } else {
      // No blank line after header
      restOfContent = lines.slice(1).join("\n");
    }

    newContent = `${expectedHeader}\n\n${restOfContent}`;
    action = "updated";
  } else {
    // Insert new header with blank line
    newContent = `${expectedHeader}\n\n${content}`;
    action = "added";
  }

  // Only write to file in fix mode
  if (fix) {
    writeFileSync(filePath, newContent, "utf-8");
  }

  return { action, file: relativePath };
}

// ---------------------------------------------------------------------------
// Main Execution
// ---------------------------------------------------------------------------

function main(): void {
  const args = process.argv.slice(2);

  // Parse --fix flag
  const fixIndex = args.indexOf("--fix");
  const fix = fixIndex !== -1;
  if (fix) {
    args.splice(fixIndex, 1);
  }

  if (args.length === 0) {
    console.error(
      "Usage: bun scripts/add-file-path.ts [--fix] <file-or-dir> [file-or-dir...]"
    );
    console.error(
      "Example: bun scripts/add-file-path.ts terraform/           # Lint mode"
    );
    console.error(
      "Example: bun scripts/add-file-path.ts --fix terraform/     # Fix mode"
    );
    process.exit(1);
  }

  const projectRoot = getProjectRoot();
  const allFiles: string[] = [];

  // Collect all files from all input paths
  for (const inputPath of args) {
    const files = getFilesToProcess(inputPath, projectRoot);
    allFiles.push(...files);
  }

  // Remove duplicates (in case same file is specified multiple times)
  const uniqueFiles = [...new Set(allFiles)];

  if (uniqueFiles.length === 0) {
    console.log("No matching files found to process.");
    return;
  }

  // Process each file and collect results
  const results = {
    added: [] as string[],
    updated: [] as string[],
    skipped: [] as string[],
  };

  for (const file of uniqueFiles) {
    const result = processFile(file, projectRoot, fix);
    results[result.action].push(result.file);
  }

  // Print summary
  const modeLabel = fix ? "Fix" : "Lint";
  const modeEmoji = fix ? "🔧" : "🔍";

  console.log(`\n${modeEmoji} File Path Header ${modeLabel} Results:`);
  console.log("─".repeat(50));

  if (results.added.length > 0) {
    const verb = fix ? "Added" : "Missing";
    const symbol = fix ? "+" : "⚠";
    console.log(
      `\n${fix ? "✅" : "⚠️ "} ${verb} headers (${results.added.length}):`
    );
    results.added.forEach((f) => console.log(`   ${symbol} ${f}`));
  }

  if (results.updated.length > 0) {
    const verb = fix ? "Updated" : "Incorrect";
    const symbol = fix ? "~" : "⚠";
    console.log(
      `\n${fix ? "🔄" : "⚠️ "} ${verb} headers (${results.updated.length}):`
    );
    results.updated.forEach((f) => console.log(`   ${symbol} ${f}`));
  }

  if (results.skipped.length > 0) {
    console.log(`\n✅ Correct headers (${results.skipped.length}):`);
    results.skipped.forEach((f) => console.log(`   ✓ ${f}`));
  }

  console.log("\n" + "─".repeat(50));

  const issueCount = results.added.length + results.updated.length;

  if (fix) {
    console.log(
      `Total: ${uniqueFiles.length} files | ` +
        `Added: ${results.added.length} | ` +
        `Updated: ${results.updated.length} | ` +
        `Skipped: ${results.skipped.length}`
    );
  } else {
    console.log(
      `Total: ${uniqueFiles.length} files | ` +
        `Issues: ${issueCount} | ` +
        `Correct: ${results.skipped.length}`
    );

    if (issueCount > 0) {
      console.log(`\n💡 Run with --fix to automatically fix these issues.`);
      process.exit(1);
    }
  }
}

main();
