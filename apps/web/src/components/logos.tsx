interface LogoProps {
  className?: string;
}

export function AWSLogo({ className }: LogoProps) {
  return <img src="/aws-logo.svg" alt="AWS" className={className} />;
}

export function GCPLogo({ className }: LogoProps) {
  return <img src="/gcp-logo.svg" alt="Google Cloud" className={className} />;
}

export function CloudflareLogo({ className }: LogoProps) {
  return (
    <img src="/cloudflare-logo.svg" alt="Cloudflare" className={className} />
  );
}
