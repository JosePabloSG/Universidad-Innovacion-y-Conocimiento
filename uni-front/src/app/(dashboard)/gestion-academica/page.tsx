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
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"

interface NivelAcademico {
  Id_Nivel_Academico: number
  Nombre: string
}

interface Facultad {
  Id_Facultad: number
  Nombre: string
}

interface ProgramaAcademico {
  Id_Prog_Academico: number
  Nombre: string
  Duracion: number
  Id_Nivel_Academico: number
  Id_Facultad: number
}

export default function GestionAcademica() {
  const [nivelesAcademicos, setNivelesAcademicos] = useState<NivelAcademico[]>([
    { Id_Nivel_Academico: 1, Nombre: "Licenciatura" },
    { Id_Nivel_Academico: 2, Nombre: "Maestría" },
  ])
  const [facultades, setFacultades] = useState<Facultad[]>([
    { Id_Facultad: 1, Nombre: "Facultad de Ingeniería" },
    { Id_Facultad: 2, Nombre: "Facultad de Ciencias" },
  ])
  const [programasAcademicos, setProgramasAcademicos] = useState<ProgramaAcademico[]>([
    { Id_Prog_Academico: 1, Nombre: "Ingeniería en Sistemas", Duracion: 8, Id_Nivel_Academico: 1, Id_Facultad: 1 },
    { Id_Prog_Academico: 2, Nombre: "Biología", Duracion: 10, Id_Nivel_Academico: 1, Id_Facultad: 2 },
  ])

  const [editingItem, setEditingItem] = useState<any | null>(null)
  const [newItem, setNewItem] = useState<any>({})
  const [isEditModalOpen, setIsEditModalOpen] = useState(false)
  const [isAddModalOpen, setIsAddModalOpen] = useState(false)
  const [activeTab, setActiveTab] = useState("niveles")

  const handleEdit = (item: any) => {
    setEditingItem(item)
    setIsEditModalOpen(true)
  }

  const handleSave = () => {
    if (editingItem) {
      switch (activeTab) {
        case "niveles":
          setNivelesAcademicos(nivelesAcademicos.map(n => n.Id_Nivel_Academico === editingItem.Id_Nivel_Academico ? editingItem : n))
          break
        case "facultades":
          setFacultades(facultades.map(f => f.Id_Facultad === editingItem.Id_Facultad ? editingItem : f))
          break
        case "programas":
          setProgramasAcademicos(programasAcademicos.map(p => p.Id_Prog_Academico === editingItem.Id_Prog_Academico ? editingItem : p))
          break
      }
      setIsEditModalOpen(false)
      setEditingItem(null)
    }
  }

  const handleDelete = (id: number) => {
    switch (activeTab) {
      case "niveles":
        setNivelesAcademicos(nivelesAcademicos.filter(n => n.Id_Nivel_Academico !== id))
        break
      case "facultades":
        setFacultades(facultades.filter(f => f.Id_Facultad !== id))
        break
      case "programas":
        setProgramasAcademicos(programasAcademicos.filter(p => p.Id_Prog_Academico !== id))
        break
    }
  }

  const handleAdd = () => {
    switch (activeTab) {
      case "niveles":
        const newNivelId = Math.max(...nivelesAcademicos.map(n => n.Id_Nivel_Academico)) + 1
        setNivelesAcademicos([...nivelesAcademicos, { ...newItem, Id_Nivel_Academico: newNivelId }])
        break
      case "facultades":
        const newFacultadId = Math.max(...facultades.map(f => f.Id_Facultad)) + 1
        setFacultades([...facultades, { ...newItem, Id_Facultad: newFacultadId }])
        break
      case "programas":
        const newProgramaId = Math.max(...programasAcademicos.map(p => p.Id_Prog_Academico)) + 1
        setProgramasAcademicos([...programasAcademicos, { ...newItem, Id_Prog_Academico: newProgramaId }])
        break
    }
    setIsAddModalOpen(false)
    setNewItem({})
  }

  const renderTable = () => {
    switch (activeTab) {
      case "niveles":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nombre</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {nivelesAcademicos.map((nivel) => (
                <TableRow key={nivel.Id_Nivel_Academico}>
                  <TableCell>{nivel.Id_Nivel_Academico}</TableCell>
                  <TableCell>{nivel.Nombre}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(nivel)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(nivel.Id_Nivel_Academico)}>
                      <Trash className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )
      case "facultades":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nombre</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {facultades.map((facultad) => (
                <TableRow key={facultad.Id_Facultad}>
                  <TableCell>{facultad.Id_Facultad}</TableCell>
                  <TableCell>{facultad.Nombre}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(facultad)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(facultad.Id_Facultad)}>
                      <Trash className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        )
      case "programas":
        return (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nombre</TableHead>
                <TableHead>Duración</TableHead>
                <TableHead>Nivel Académico</TableHead>
                <TableHead>Facultad</TableHead>
                <TableHead>Acciones</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {programasAcademicos.map((programa) => (
                <TableRow key={programa.Id_Prog_Academico}>
                  <TableCell>{programa.Id_Prog_Academico}</TableCell>
                  <TableCell>{programa.Nombre}</TableCell>
                  <TableCell>{programa.Duracion}</TableCell>
                  <TableCell>{nivelesAcademicos.find(n => n.Id_Nivel_Academico === programa.Id_Nivel_Academico)?.Nombre}</TableCell>
                  <TableCell>{facultades.find(f => f.Id_Facultad === programa.Id_Facultad)?.Nombre}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(programa)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(programa.Id_Prog_Academico)}>
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
      case "niveles":
      case "facultades":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="name" className="text-right">
                Nombre
              </Label>
              <Input
                id="name"
                value={editingItem?.Nombre || ""}
                onChange={(e) => setEditingItem({...editingItem, Nombre: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "programas":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="name" className="text-right">
                Nombre
              </Label>
              <Input
                id="name"
                value={editingItem?.Nombre || ""}
                onChange={(e) => setEditingItem({...editingItem, Nombre: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="duracion" className="text-right">
                Duración
              </Label>
              <Input
                id="duracion"
                type="number"
                value={editingItem?.Duracion || ""}
                onChange={(e) => setEditingItem({...editingItem, Duracion: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="nivel" className="text-right">
                Nivel Académico
              </Label>
              <Select
                value={editingItem?.Id_Nivel_Academico?.toString()}
                onValueChange={(value) => setEditingItem({...editingItem, Id_Nivel_Academico: parseInt(value)})}
              >
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Seleccione un nivel" />
                </SelectTrigger>
                <SelectContent>
                  {nivelesAcademicos.map((nivel) => (
                    <SelectItem key={nivel.Id_Nivel_Academico} value={nivel.Id_Nivel_Academico.toString()}>
                      {nivel.Nombre}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="facultad" className="text-right">
                Facultad
              </Label>
              <Select
                value={editingItem?.Id_Facultad?.toString()}
                onValueChange={(value) => setEditingItem({...editingItem, Id_Facultad: parseInt(value)})}
              >
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Seleccione una facultad" />
                </SelectTrigger>
                <SelectContent>
                  {facultades.map((facultad) => (
                    <SelectItem key={facultad.Id_Facultad} value={facultad.Id_Facultad.toString()}>
                      {facultad.Nombre}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        )
    }
  }

  const renderAddModal = () => {
    switch (activeTab) {
      case "niveles":
      case "facultades":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newName" className="text-right">
                Nombre
              </Label>
              <Input
                id="newName"
                value={newItem.Nombre || ""}
                onChange={(e) => setNewItem({...newItem, Nombre: e.target.value})}
                className="col-span-3"
              />
            </div>
          </div>
        )
      case "programas":
        return (
          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newName" className="text-right">
                Nombre
              </Label>
              <Input
                id="newName"
                value={newItem.Nombre || ""}
                onChange={(e) => setNewItem({...newItem, Nombre: e.target.value})}
                className="col-span-3"
              />
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newDuracion" className="text-right">
                Duración
              </Label>
              <Input
                id="newDuracion"
                type="number"
                value={newItem.Duracion || ""}
                onChange={(e) => setNewItem({...newItem, Duracion: parseInt(e.target.value)})}
                className="col-span-3"
              />
            </div>
            <div className="grid  grid-cols-4 items-center gap-4">
              <Label htmlFor="newNivel" className="text-right">
                Nivel Académico
              </Label>
              <Select
                value={newItem.Id_Nivel_Academico?.toString()}
                onValueChange={(value) => setNewItem({...newItem, Id_Nivel_Academico: parseInt(value)})}
              >
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Seleccione un nivel" />
                </SelectTrigger>
                <SelectContent>
                  {nivelesAcademicos.map((nivel) => (
                    <SelectItem key={nivel.Id_Nivel_Academico} value={nivel.Id_Nivel_Academico.toString()}>
                      {nivel.Nombre}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-4 items-center gap-4">
              <Label htmlFor="newFacultad" className="text-right">
                Facultad
              </Label>
              <Select
                value={newItem.Id_Facultad?.toString()}
                onValueChange={(value) => setNewItem({...newItem, Id_Facultad: parseInt(value)})}
              >
                <SelectTrigger className="col-span-3">
                  <SelectValue placeholder="Seleccione una facultad" />
                </SelectTrigger>
                <SelectContent>
                  {facultades.map((facultad) => (
                    <SelectItem key={facultad.Id_Facultad} value={facultad.Id_Facultad.toString()}>
                      {facultad.Nombre}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        )
    }
  }

  return (
    <div className="container mx-auto p-4">
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="grid w-full grid-cols-3">
          <TabsTrigger value="niveles">Niveles Académicos</TabsTrigger>
          <TabsTrigger value="facultades">Facultades</TabsTrigger>
          <TabsTrigger value="programas">Programas Académicos</TabsTrigger>
        </TabsList>
        <TabsContent value="niveles">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Niveles Académicos</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Nivel
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nuevo Nivel Académico</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Nivel</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
        <TabsContent value="facultades">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Facultades</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Facultad
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nueva Facultad</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Facultad</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
        <TabsContent value="programas">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-bold">Programas Académicos</h2>
            <Dialog open={isAddModalOpen} onOpenChange={setIsAddModalOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="h-4 w-4 mr-2" /> Agregar Programa
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Agregar Nuevo Programa Académico</DialogTitle>
                </DialogHeader>
                {renderAddModal()}
                <Button onClick={handleAdd}>Agregar Programa</Button>
              </DialogContent>
            </Dialog>
          </div>
          {renderTable()}
        </TabsContent>
      </Tabs>

      <Dialog open={isEditModalOpen} onOpenChange={setIsEditModalOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Editar {activeTab === "niveles" ? "Nivel Académico" : activeTab === "facultades" ? "Facultad" : "Programa Académico"}</DialogTitle>
          </DialogHeader>
          {renderEditModal()}
          <Button onClick={handleSave}>Guardar Cambios</Button>
        </DialogContent>
      </Dialog>
    </div>
  )
}