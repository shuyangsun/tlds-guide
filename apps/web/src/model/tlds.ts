import { ICANN_TLDS } from "./tld/icann";
import { AWS_TLDS } from "./tld/aws";
import { AZURE_TLDS } from "./tld/azure";
import { GCP_TLDS } from "./tld/gcp";
import { CLOUDFLARE_TLDS } from "./tld/cloudflare";

export const TLD_PROVIDERS = ["ICANN", "AWS", "AZURE", "GCP", "CLOUDFLARE"];

export type TldProvider = (typeof TLD_PROVIDERS)[number];

class TldSupport {
  constructor(
    public tld: string,
    public support: Record<TldProvider, boolean>
  ) {}
}

const PROVIDER_SUPPORTS: Record<TldProvider, Set<string>> = {
  ICANN: ICANN_TLDS,
  AWS: AWS_TLDS,
  AZURE: AZURE_TLDS,
  GCP: GCP_TLDS,
  CLOUDFLARE: CLOUDFLARE_TLDS,
};

function unionSets<T>(...sets: Set<T>[]): Set<T> {
  const result = new Set<T>();
  for (const set of sets) {
    for (const item of set) {
      result.add(item);
    }
  }
  return result;
}

const ALL_TLDS: string[] = [...unionSets(...Object.values(PROVIDER_SUPPORTS))];
const SUPPORT_COUNT: Map<string, number> = new Map<string, number>(
  ALL_TLDS.map((tld) => {
    let count = 0;
    for (const supported of Object.values(PROVIDER_SUPPORTS)) {
      if (supported.has(tld)) {
        count++;
      }
    }
    return [tld, count] as [string, number];
  })
);

function customSort(a: string, b: string): number {
  const priorities: string[] = ["com", "ai"];

  const aIndex = priorities.indexOf(a);
  const bIndex = priorities.indexOf(b);

  // If both are in priorities, sort by their priority order
  if (aIndex !== -1 && bIndex !== -1) {
    return aIndex - bIndex;
  }

  // If only a is in priorities, it comes first
  if (aIndex !== -1) {
    return -1;
  }

  // If only b is in priorities, it comes first
  if (bIndex !== -1) {
    return 1;
  }

  // Neither is in priorities, sort by support count
  const aCount = SUPPORT_COUNT.get(a) ?? 0;
  const bCount = SUPPORT_COUNT.get(b) ?? 0;
  if (aCount != bCount) {
    return bCount - aCount;
  }

  // Equal count, sort by locale.
  return a.localeCompare(b);
}

export const TLD_SUPPORT: TldSupport[] = [
  ...unionSets(...Object.values(PROVIDER_SUPPORTS)),
]
  .sort(customSort)
  .map((tld) => {
    const support = {} as Record<TldProvider, boolean>;
    for (const provider of TLD_PROVIDERS) {
      support[provider as TldProvider] =
        PROVIDER_SUPPORTS[provider as TldProvider].has(tld);
    }
    return new TldSupport(tld, support);
  });
