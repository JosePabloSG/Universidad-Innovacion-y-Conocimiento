'use client'

import { useState, useRef, useEffect } from 'react';
import Link from 'next/link';
import { User, ChevronDown } from 'lucide-react';

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);

  useEffect(() => {
    function handleClickOutside(event: { target: any; }) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, []);

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
        <div className="flex items-center space-x-4">
          <div className="relative" ref={dropdownRef}>
            <button
              onClick={() => setIsOpen(!isOpen)}
              className="p-2 md:p-3 hover:bg-teal-700 rounded-full transition-colors duration-300 flex items-center"
            >
              <User className="w-6 h-6 md:w-8 md:h-8" />
              <ChevronDown className="ml-2 h-4 w-4" />
              <span className="sr-only">Menú de usuario</span>
            </button>
            {isOpen && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10">
                <Link 
                  href="/perfil" 
                  className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                >
                  Mi perfil
                </Link>
                <Link 
                  href="/auth/login" 
                  className="block px-4 py-2 text-sm text-red-600 hover:bg-gray-100"
                >
                  Cerrar Sesión
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
}