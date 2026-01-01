import { ICANN_TLDS } from "./tld/icann";
import { AWS_TLDS } from "./tld/aws";
import { GCP_TLDS } from "./tld/gcp";
import { CLOUDFLARE_TLDS } from "./tld/cloudflare";

const Providers = ["ICANN", "AWS", "AZURE", "GCP", "CLOUDFLARE"];

type Provider = (typeof Providers)[number];

class TldSupport {
  constructor(
    public tld: string,
    public support: Record<Provider, boolean>
  ) {}
}

const PROVIDERS: Record<Provider, Set<string>> = {
  ICANN: ICANN_TLDS,
  AWS: AWS_TLDS,
  // AZURE: AZURE_TLDS,
  AZURE: ICANN_TLDS, // TODO: placeholder for now, need to find good source.
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

  // Neither is in priorities, sort alphabetically
  return a.localeCompare(b);
}

export const TLD_SUPPORT: TldSupport[] = [
  ...unionSets(...Object.values(PROVIDERS)),
]
  .sort(customSort)
  .map((tld) => {
    const support = {} as Record<Provider, boolean>;
    for (const provider of Providers) {
      support[provider as Provider] = PROVIDERS[provider as Provider].has(tld);
    }
    return new TldSupport(tld, support);
  });
