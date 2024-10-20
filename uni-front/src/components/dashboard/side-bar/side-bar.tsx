import {
  Calendar,
  Users,
  BookOpen,
  School,
  Clock,
  FileText,
  Home,
} from "lucide-react";
import Link from "next/link";

const menuItems = [
  { name: "Inicio", icon: Home, href: "/" },
  { name: "Horarios", icon: Calendar, href: "/horarios" },
  { name: "Estudiantes", icon: Users, href: "/estudiantes" },
  { name: "Docentes", icon: Users, href: "/docentes" },
  { name: "Recursos Académicos", icon: BookOpen, href: "/recursos-academicos" },
  { name: "Aulas", icon: School, href: "/aulas" },
  { name: "Cursos", icon: Clock, href: "/cursos" },
  { name: "Historial", icon: FileText, href: "/historial" },
];
export default function SideBar() {
  return (
    <aside
      className={`bg-white w-64 min-h-screen p-4 md:block border shadow-sm rounded`}
    >
      <nav>
        <h2 className="text-xl font-bold mb-6 text-gray-800">
          Sistema Académico
        </h2>
        <ul>
          {menuItems.map((item) => (
            <li key={item.name} className="mb-2">
              <Link
                href={item.href}
                className="flex items-center p-2 text-gray-700 hover:bg-gray-200 rounded"
              >
                <item.icon className="mr-3 h-5 w-5" />
                {item.name}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    </aside>
  );
}
