/* eslint-disable @typescript-eslint/no-explicit-any */
'use client'
import React, { useState, useEffect } from "react";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Eye, EyeOff } from "lucide-react";

// Simulating fetching data from an API
const fetchData = async () => {
  // In a real application, this would be an API call
  return {
    auditoria_accion: [
      { id_accion: 1, accion_realizada: "Insertar" },
      { id_accion: 2, accion_realizada: "Actualizar" },
      { id_accion: 3, accion_realizada: "Eliminar" },
    ],
    historial_cambio: [
      {
        id_historial_cambio: 1,
        usuario: "admin@example.com",
        fecha: "2023-05-15T10:30:00",
        id_registro: 101,
        tabla: "Estudiantes",
        id_accion: 1,
        datos_anteriores: null,
        datos_nuevos:
          '{"nombre":"Juan Pérez","edad":20,"carrera":"Ingeniería"}',
      },
      {
        id_historial_cambio: 2,
        usuario: "profesor@example.com",
        fecha: "2023-05-16T14:45:00",
        id_registro: 201,
        tabla: "Cursos",
        id_accion: 2,
        datos_anteriores: '{"nombre":"Matemáticas Básicas","creditos":3}',
        datos_nuevos: '{"nombre":"Matemáticas Avanzadas","creditos":4}',
      },
      {
        id_historial_cambio: 3,
        usuario: "admin@example.com",
        fecha: "2023-05-17T09:15:00",
        id_registro: 301,
        tabla: "Aulas",
        id_accion: 3,
        datos_anteriores: '{"numero":"A101","capacidad":30}',
        datos_nuevos: null,
      },
    ],
  };
};

export default function AuditLogViewer() {
  interface AuditData {
    auditoria_accion: { id_accion: number; accion_realizada: string }[];
    historial_cambio: {
      id_historial_cambio: number;
      usuario: string;
      fecha: string;
      id_registro: number;
      tabla: string;
      id_accion: number;
      datos_anteriores: string | null;
      datos_nuevos: string | null;
    }[];
  }

  const [data, setData] = useState<AuditData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData().then((result) => {
      setData(result);
      setLoading(false);
    });
  }, []);

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        Cargando...
      </div>
    );
  }

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Visor de Auditoría</h1>
      <Tabs defaultValue="historial">
        <TabsList>
          <TabsTrigger value="historial">Historial de Cambios</TabsTrigger>
          <TabsTrigger value="acciones">Acciones de Auditoría</TabsTrigger>
        </TabsList>
        <TabsContent value="historial">
          <Card>
            <CardHeader>
              <CardTitle>Historial de Cambios</CardTitle>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>ID</TableHead>
                    <TableHead>Usuario</TableHead>
                    <TableHead>Fecha</TableHead>
                    <TableHead>Tabla</TableHead>
                    <TableHead>Acción</TableHead>
                    <TableHead>Detalles</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {data && data.historial_cambio.map((item: any) => (
                    <TableRow key={item.id_historial_cambio}>
                      <TableCell>{item.id_historial_cambio}</TableCell>
                      <TableCell>{item.usuario}</TableCell>
                      <TableCell>
                        {new Date(item.fecha).toLocaleString()}
                      </TableCell>
                      <TableCell>{item.tabla}</TableCell>
                      <TableCell>
                        {
                          data.auditoria_accion.find(
                            (a: any) => a.id_accion === item.id_accion
                          )?.accion_realizada
                        }
                      </TableCell>
                      <TableCell>
                        <ChangeDetails
                          anterior={item.datos_anteriores}
                          nuevo={item.datos_nuevos}
                        />
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="acciones">
          <Card>
            <CardHeader>
              <CardTitle>Acciones de Auditoría</CardTitle>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>ID</TableHead>
                    <TableHead>Acción Realizada</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {data && data.auditoria_accion.map((item: any) => (
                    <TableRow key={item.id_accion}>
                      <TableCell>{item.id_accion}</TableCell>
                      <TableCell>{item.accion_realizada}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

function ChangeDetails({
  anterior,
  nuevo,
}: {
  anterior: string | null;
  nuevo: string | null;
}) {
  const [showDetails, setShowDetails] = useState(false);

  const formatData = (data: string | null) => {
    if (!data) return "N/A";
    try {
      return JSON.stringify(JSON.parse(data), null, 2);
    } catch {
      return data;
    }
  };

  return (
    <div>
      <button
        onClick={() => setShowDetails(!showDetails)}
        className="flex items-center text-blue-500 hover:text-blue-700"
      >
        {showDetails ? (
          <EyeOff className="w-4 h-4 mr-1" />
        ) : (
          <Eye className="w-4 h-4 mr-1" />
        )}
        {showDetails ? "Ocultar" : "Ver"}
      </button>
      {showDetails && (
        <div className="mt-2 space-y-2">
          <div>
            <strong>Anterior:</strong>
            <pre className="text-xs bg-gray-100 p-2 rounded">
              {formatData(anterior)}
            </pre>
          </div>
          <div>
            <strong>Nuevo:</strong>
            <pre className="text-xs bg-gray-100 p-2 rounded">
              {formatData(nuevo)}
            </pre>
          </div>
        </div>
      )}
    </div>
  );
}
