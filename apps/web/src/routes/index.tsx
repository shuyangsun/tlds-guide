import { createFileRoute } from "@tanstack/react-router";
import {
  AWSLogo,
  AzureLogo,
  GCPLogo,
  CloudflareLogo,
} from "../components/logos";
import { GOOD_TLDS } from "@/model/tlds";

export const Route = createFileRoute("/")({ component: App });

function App() {
  return (
    <div className="min-h-screen flex flex-col items-center py-6 px-4">
      {/* Header */}
      <header className="text-center mb-6 max-w-lg">
        <h1 className="text-base sm:text-lg font-medium text-slate-600 mb-3">
          Domain TLDs cloud provider support
        </h1>
        <div className="flex justify-center items-center gap-4 sm:gap-6">
          <AWSLogo className="h-5 sm:h-6 w-auto" />
          <AzureLogo className="h-5 sm:h-6 w-auto" />
          <GCPLogo className="h-5 sm:h-6 w-auto" />
          <CloudflareLogo className="h-4 sm:h-5 w-auto" />
        </div>
      </header>
      {/* TLD List */}
      <ul className="text-left text-xl text-slate-700 space-y-1 ml-10">
        {GOOD_TLDS.map((tld) => (
          <li key={tld}>.{tld}</li>
        ))}
      </ul>
    </div>
  );
}
