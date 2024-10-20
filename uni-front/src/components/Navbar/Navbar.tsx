import Link from 'next/link';
import { User } from 'lucide-react';

export default function Navbar() {
  return (
    <nav className="bg-black text-white p-4 shadow-md min-h-[80px]">
      <div className="w-full flex justify-between items-center px-4">
        <div className="flex items-center">
          <Link 
            href="/" 
            className="text-lg sm:text-xl md:text-2xl font-bold"
          >
            Universidad Innovación y Conocimiento
          </Link>
        </div>
        <div className="flex items-center">
          <Link 
            href="/perfil" 
            className="p-2 md:p-3 hover:bg-teal-700 rounded-full transition-colors duration-300"
          >
            <User className="w-6 h-6 md:w-8 md:h-8" />
            <span className="sr-only">Perfil de usuario</span>
          </Link>
        </div>
      </div>
    </nav>
  );
}
