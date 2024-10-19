'use client'
import { useState } from 'react'
import Link from 'next/link'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Calendar, Users, BookOpen, School, Clock, FileText, Menu } from 'lucide-react'

export default function Dashboard() {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  const toggleSidebar = () => setSidebarOpen(!sidebarOpen)

  const menuItems = [
    { name: 'Horarios', icon: Calendar, href: '/horarios' },
    { name: 'Estudiantes', icon: Users, href: '/estudiantes' },
    { name: 'Docentes', icon: Users, href: '/docentes' },
    { name: 'Recursos Académicos', icon: BookOpen, href: '/recursos' },
    { name: 'Aulas', icon: School, href: '/aulas' },
    { name: 'Cursos', icon: Clock, href: '/cursos' },
    { name: 'Historial', icon: FileText, href: '/historial' },
  ]

  return (
    <div className="flex h-screen bg-gray-100">
      {/* Sidebar */}
      <aside className={`bg-white w-64 min-h-screen p-4 ${sidebarOpen ? 'block' : 'hidden'} md:block`}>
        <nav>
          <h2 className="text-xl font-bold mb-6 text-gray-800">Sistema Académico</h2>
          <ul>
            {menuItems.map((item) => (
              <li key={item.name} className="mb-2">
                <Link href={item.href} className="flex items-center p-2 text-gray-700 hover:bg-gray-200 rounded">
                  <item.icon className="mr-3 h-5 w-5" />
                  {item.name}
                </Link>
              </li>
            ))}
          </ul>
        </nav>
      </aside>

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Top bar */}
        <header className="bg-white shadow-md p-4">
          <div className="flex items-center justify-between">
            <Button variant="ghost" size="icon" className="md:hidden" onClick={toggleSidebar}>
              <Menu className="h-6 w-6" />
            </Button>
            <h1 className="text-xl font-semibold text-gray-800">Dashboard</h1>
            <div className="w-6 h-6" /> {/* Placeholder for symmetry */}
          </div>
        </header>

        {/* Dashboard content */}
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-100 p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Total Estudiantes</CardTitle>
                <Users className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">1,234</div>
                <p className="text-xs text-muted-foreground">+10% desde el último semestre</p>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Cursos Activos</CardTitle>
                <BookOpen className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">56</div>
                <p className="text-xs text-muted-foreground">+3 nuevos cursos este semestre</p>
              </CardContent>
            </Card>
            <Card>
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium">Aulas Disponibles</CardTitle>
                <School className="h-4 w-4 text-muted-foreground" />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">23</div>
                <p className="text-xs text-muted-foreground">85% de ocupación</p>
              </CardContent>
            </Card>
          </div>

          <div className="mt-6">
            <Card>
              <CardHeader>
                <CardTitle>Horario del Día</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="font-medium">Matemáticas Avanzadas</span>
                    <span className="text-sm text-muted-foreground">09:00 - 10:30</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="font-medium">Programación Web</span>
                    <span className="text-sm text-muted-foreground">11:00 - 12:30</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="font-medium">Física Cuántica</span>
                    <span className="text-sm text-muted-foreground">14:00 - 15:30</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </main>
      </div>
    </div>
  )
}