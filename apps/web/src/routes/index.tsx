import { createFileRoute } from "@tanstack/react-router";
import {
  ICANNLogo,
  AWSLogo,
  AzureLogo,
  GCPLogo,
  CloudflareLogo,
} from "../components/logos";
import { type TldProvider, TLD_PROVIDERS, TLD_SUPPORT } from "@/model/tlds";

export const Route = createFileRoute("/")({ component: App });

function App() {
  const logos: Record<TldProvider, React.ReactElement> = {
    ICANN: <ICANNLogo className="h-6 sm:h-7 w-auto mx-auto" />,
    AWS: <AWSLogo className="h-6 sm:h-7 w-auto mx-auto" />,
    AZURE: <AzureLogo className="h-6 sm:h-7 w-auto mx-auto" />,
    GCP: <GCPLogo className="h-6 sm:h-7 w-auto mx-auto" />,
    CLOUDFLARE: <CloudflareLogo className="h-6 sm:h-7 w-auto mx-auto" />,
  };
  return (
    <div className="min-h-screen flex flex-col items-center py-4 sm:py-6 px-2 sm:px-4">
      {/* Header */}
      <header className="text-center mb-4 sm:mb-6 max-w-lg px-2">
        <p className="text-xs text-slate-500 mb-3">Updated: 2026-1-1</p>
      </header>
      <div className="w-full max-w-5xl">
        <table className="min-w-full bg-white border border-slate-200 rounded-lg shadow-sm">
          <thead className="bg-slate-50">
            <tr>
              <th className="sticky top-0 z-10 after:absolute after:bottom-0 after:left-0 after:right-0 after:h-[2px] after:bg-slate-300 px-2 sm:px-3 py-3 text-left text-xs font-semibold text-slate-700 uppercase tracking-wider bg-slate-50 w-20 sm:w-24">
                TLD
              </th>
              {TLD_PROVIDERS.map((provider) => (
                <th
                  key={provider}
                  className="sticky top-0 z-10 after:absolute after:bottom-0 after:left-0 after:right-0 after:h-[2px] after:bg-slate-300 px-2 sm:px-4 py-3 text-center text-xs font-semibold text-slate-700 uppercase tracking-wider bg-slate-100"
                >
                  {logos[provider]}
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-200">
            {TLD_SUPPORT.map((row, idx) => (
              <tr
                key={row.tld}
                className={idx % 2 === 0 ? "bg-white" : "bg-slate-50"}
              >
                <td className="px-2 sm:px-3 py-3 sm:py-4 whitespace-nowrap text-xs sm:text-sm font-medium text-slate-900">
                  {row.tld}
                </td>
                {TLD_PROVIDERS.map((provider) => (
                  <td
                    key={`${row.tld}-${provider}`}
                    className={`px-2 sm:px-4 py-3 sm:py-4 whitespace-nowrap text-center text-lg sm:text-xl font-bold ${
                      row.support[provider]
                        ? "bg-green-100 text-green-700"
                        : "bg-red-100 text-red-700"
                    }`}
                  >
                    {row.support[provider] ? "✓" : "✗"}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
