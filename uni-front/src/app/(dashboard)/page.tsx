"use client";
import {
  useCreateCustomer,
  useDeleteCustomer,
  useGetAllCustomers,
} from "@/hooks";

export default function DasboardPage() {
  const { customers } = useGetAllCustomers();
  const { onSubmit, handleSubmit, register } = useCreateCustomer();
  const { confirmDelete } = useDeleteCustomer({ itemId: 3 });

  return (
    <div>
      <h1>Dashboard</h1>
      <form onSubmit={handleSubmit(onSubmit)}>
        <div>
          <label htmlFor="name">Nombre:</label>
          <input id="name" {...register("name")} />
        </div>
        <div>
          <label htmlFor="lastname">Apellido:</label>
          <input id="lastname" {...register("lastName")} />
        </div>
        <button type="submit">Agregar Cliente</button>
      </form>
      <button onClick={confirmDelete}>Eliminar Cliente</button>
      <pre>{JSON.stringify(customers, null, 2)}</pre>
    </div>
  );
}
