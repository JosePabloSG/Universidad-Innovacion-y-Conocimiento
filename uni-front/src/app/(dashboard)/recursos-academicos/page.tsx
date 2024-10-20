"use client"

import { useState } from "react"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Pencil, Trash, Plus } from "lucide-react"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Label } from "@/components/ui/label"

interface Aula {
  Id_Aula: number
  Codigo_Aula: string
  Capacidad: number
  Ubicacion: string
  Equipamiento: string
}

interface RecursoAcademico {
  Id_Recurso_Academico: number
  Estado: string
  Tipo: string
}

interface CursoRecursoAcademico {
  Id_Curso_Rec_Academico: number
  Id_Recurso_Academico: number
  Id_Curso: number
}

export default function GestionRecursosAcademicos() {
  const [aulas, setAulas] = useState<Aula[]>([
    { Id_Aula: 1, Codigo_Aula: "A101", Capacidad: 30, Ubicacion: "Edificio A", Equipamiento: "Proyector, Pizarrón" },
    { Id_Aula: 2, Codigo_Aula: "B202", Capacidad: 40, Ubicacion: "Edificio B", Equipamiento: "Computadoras, Proyector" },
  ])
  const [recursosAcademicos, setRecursosAcademicos] = useState<RecursoAcademico[]>([
    { Id_Recurso_Academico: 1, Estado: "Disponible", Tipo: "Proyector" },
    { Id_Recurso_Academico: 2, Estado: "En Mantenimiento", Tipo: "Microscopio" },
  ])
  const [cursosRecursosAcademicos, setCursosRecursosAcademicos] = useState<CursoRecursoAcademico[]>([
    { Id_Curso_Rec_Academico: 1, Id_Recurso_Academico: 1, Id_Curso: 1 },
    { Id_Curso_Rec_Academico: 2, Id_Recurso_Academico: 2, Id_Curso: 2 },
  ])

  const [editingItem, setEditingItem] = useState<any | null>(null)
  const [newItem, setNewItem] = useState<any>({})
  const [isEditModalOpen, setIsEditModalOpen] = useState(false)
  const [isAddModalOpen, setIsAddModalOpen] = useState(false)
  const [activeTab, setActiveTab] = useState("aulas")

  const handleEdit = (item: any) => {
    setEditingItem(item)
    setIsEditModalOpen(true)
  }

  const handleSave = () => {
    if (editingItem) {
      switch (activeTab) {
        case "aulas":
          setAulas(aulas.map(a => a.Id_Aula === editingItem.Id_Aula ? editingItem : a))
          break
        case "recursos":
          setRecursosAcademicos(recursosAcademicos.map(r => r.Id_Recurso_Academico === editingItem.Id_Recurso_Academico ? editingItem : r))
          break
        case "cursos-recursos":
          setCursosRecursosAcademicos(cursosRecursosAcademicos.map(cr => cr.Id_Curso_Rec_Academico === editingItem.Id_Curso_Rec_Academico ? editingItem : cr))
          break
      }
      setIsEditModalOpen(false)
      setEditingItem(null)
    }
  }

  const handleDelete = (id: number) => {
    switch (activeTab) {
      case "aulas":
        setAulas(aulas.filter(a => a.Id_Aula !== id))
        break
      case "recursos":
        setRecursosAcademicos(recursosAcademicos.filter(r => r.Id_Recurso_Academico !== id))
        break
      case "cursos-recursos":
        setCursosRecursosAcademicos(cursosRecursosAcademicos.filter(cr => cr.Id_Curso_Rec_Academico !== id))
        break
    }
  }

  const handleAdd = () => {
    switch (activeTab) {
      case "aulas":
        const newAulaId = Math.max(...aulas.map(a => a.Id_Aula)) + 1
        setAulas([...aulas, { ...newItem, Id_Aula: newAulaId }])
        break
      case "recursos":
        const newRecursoId = Math.max(...recursosAcademicos.map(r => r.Id_Recurso_Academico)) + 1
        setRecursosAcademicos([...recursosAcademicos, { ...newItem, Id_Recurso_Academico: newRecursoId }])
        break
      case "cursos-recursos":
        const newCursoRecursoId = Math.max(...cursosRecursosAcademicos.map(cr => cr.Id_Curso_Rec_Academico)) + 1
        setCursosRecursosAcademicos([...cursosRecursosAcademicos, { ...newItem, Id_Curso_Rec_Academico: newCursoRecursoId }])
        break
    }
    setIsAddModalOpen(false)
    setNewItem({})
  }

  const renderTable = () => {
    switch (activeTab) {
      case "aulas":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Código</TableHead>
                <TableHead>Capacidad</TableHead>
                <TableHead>Ubicación</TableHead>
                <TableHead>Equipamiento</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {aulas.map((aula) => (
                <TableRow key={aula.Id_Aula}>
                  <TableCell>{aula.Id_Aula}</TableCell>
                  <TableCell>{aula.Codigo_Aula}</TableCell>
                  <TableCell>{aula.Capacidad}</TableCell>
                  <TableCell>{aula.Ubicacion}</TableCell>
                  <TableCell>{aula.Equipamiento}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(aula)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(aula.Id_Aula)}>
                      <Trash className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )
      case "recursos":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Estado</TableHead>
                <TableHead>Tipo</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {recursosAcademicos.map((recurso) => (
                <TableRow key={recurso.Id_Recurso_Academico}>
                  <TableCell>{recurso.Id_Recurso_Academico}</TableCell>
                  <TableCell>{recurso.Estado}</TableCell>
                  <TableCell>{recurso.Tipo}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(recurso)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(recurso.Id_Recurso_Academico)}>
                      <Trash className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )
      case "cursos-recursos":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>ID Recurso Académico</TableHead>
                <TableHead>ID Curso</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {cursosRecursosAcademicos.map((cursoRecurso) => (
                <TableRow key={cursoRecurso.Id_Curso_Rec_Academico}>
                  <TableCell>{cursoRecurso.Id_Curso_Rec_Academico}</TableCell>
                  <TableCell>{cursoRecurso.Id_Recurso_Academico}</TableCell>
                  <TableCell>{cursoRecurso.Id_Curso}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(cursoRecurso)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(cursoRecurso.Id_Curso_Rec_Academico)}>
                      <Trash className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )
    }
  }

  const renderEditModal = () => {
    switch (activeTab) {
      case "aulas":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="codigo" className="text-right">
                Código
              </Label>
              <Input
                id="codigo"
                value={editingItem?.Codigo_Aula || ""}
                onChange={(e) => setEditingItem({...editingItem, Codigo_Aula: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="capacidad" className="text-right">
                Capacidad
              </Label>
              <Input
                id="capacidad"
                type="number"
                value={editingItem?.Capacidad || ""}
                onChange={(e) => setEditingItem({...editingItem, Capacidad: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="ubicacion" className="text-right">
                Ubicación
              </Label>
              <Input
                id="ubicacion"
                value={editingItem?.Ubicacion || ""}
                onChange={(e) => setEditingItem({...editingItem, Ubicacion: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="equipamiento" className="text-right">
                Equipamiento
              </Label>
              <Input
                id="equipamiento"
                value={editingItem?.Equipamiento || ""}
                onChange={(e) => setEditingItem({...editingItem, Equipamiento: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "recursos":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="estado" className="text-right">
                Estado
              </Label>
              <Input
                id="estado"
                value={editingItem?.Estado || ""}
                onChange={(e) => setEditingItem({...editingItem, Estado: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="tipo" className="text-right">
                Tipo
              </Label>
              <Input
                id="tipo"
                value={editingItem?.Tipo || ""}
                onChange={(e) => setEditingItem({...editingItem, Tipo: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "cursos-recursos":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="idRecurso" className="text-right">
                ID Recurso Académico
              </Label>
              <Input
                id="idRecurso"
                type="number"
                value={editingItem?.Id_Recurso_Academico || ""}
                onChange={(e) => setEditingItem({...editingItem, Id_Recurso_Academico: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="idCurso" className="text-right">
                ID Curso
              </Label>
              <Input
                id="idCurso"
                type="number"
                value={editingItem?.Id_Curso || ""}
                onChange={(e) => setEditingItem({...editingItem, Id_Curso: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
          </div>
        )
    }
  }

  const renderAddModal = () => {
    switch  (activeTab) {
      case "aulas":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newCodigo" className="text-right">
                Código
              </Label>
              <Input
                id="newCodigo"
                value={newItem.Codigo_Aula || ""}
                onChange={(e) => setNewItem({...newItem, Codigo_Aula: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newCapacidad" className="text-right">
                Capacidad
              </Label>
              <Input
                id="newCapacidad"
                type="number"
                value={newItem.Capacidad || ""}
                onChange={(e) => setNewItem({...newItem, Capacidad: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newUbicacion" className="text-right">
                Ubicación
              </Label>
              <Input
                id="newUbicacion"
                value={newItem.Ubicacion || ""}
                onChange={(e) => setNewItem({...newItem, Ubicacion: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newEquipamiento" className="text-right">
                Equipamiento
              </Label>
              <Input
                id="newEquipamiento"
                value={newItem.Equipamiento || ""}
                onChange={(e) => setNewItem({...newItem, Equipamiento: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "recursos":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newEstado" className="text-right">
                Estado
              </Label>
              <Input
                id="newEstado"
                value={newItem.Estado || ""}
                onChange={(e) => setNewItem({...newItem, Estado: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newTipo" className="text-right">
                Tipo
              </Label>
              <Input
                id="newTipo"
                value={newItem.Tipo || ""}
                onChange={(e) => setNewItem({...newItem, Tipo: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "cursos-recursos":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newIdRecurso" className="text-right">
                ID Recurso Académico
              </Label>
              <Input
                id="newIdRecurso"
                type="number"
                value={newItem.Id_Recurso_Academico || ""}
                onChange={(e) => setNewItem({...newItem, Id_Recurso_Academico: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newIdCurso" className="text-right">
                ID Curso
              </Label>
              <Input
                id="newIdCurso"
                type="number"
                value={newItem.Id_Curso || ""}
                onChange={(e) => setNewItem({...newItem, Id_Curso: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
          </div>
        )
    }
  }

  return (
    <div className="container mx-auto p-4">
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="aulas">Aulas</TabsTrigger>
          <TabsTrigger value="recursos">Recursos Académicos</TabsTrigger>
          <TabsTrigger value="cursos-recursos">Cursos-Recursos</TabsTrigger>
        </TabsList>
        <TabsContent value="aulas">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Aulas</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Aula
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nueva Aula</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Aula</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
        <TabsContent value="recursos">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Recursos Académicos</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Recurso
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nuevo Recurso Académico</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Recurso</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
        <TabsContent value="cursos-recursos">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Cursos-Recursos Académicos</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Relación
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nueva Relación Curso-Recurso</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Relación</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
      </Tabs>

      <Dialog open={isEditModalOpen} onOpenChange={setIsEditModalOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Editar {activeTab === "aulas" ? "Aula" : activeTab === "recursos" ? "Recurso Académico" : "Relación Curso-Recurso"}</DialogTitle>
          </DialogHeader>
          {renderEditModal()}
          <Button onClick={handleSave}>Guardar Cambios</Button>
        </DialogContent>
      </Dialog>
    </div>
  )
}