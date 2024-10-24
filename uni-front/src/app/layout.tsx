import './globals.css';
import ReactQueryProvider from '@/lib/query-provider';

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body className="">
          <ReactQueryProvider>
            {children}
          </ReactQueryProvider>
      </body>
    </html>
  );
}
