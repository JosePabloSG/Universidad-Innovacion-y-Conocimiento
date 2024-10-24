import { createCustomerSchema } from "@/schemas";
import { SubmitHandler, useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useState } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Customer } from "@/types";
import { createCustomer } from "@/services";

type FormsFields = z.infer<typeof createCustomerSchema>;

const useCreateCustomer = () => {
  const [isOpen, setIsOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
    setError,
  } = useForm<FormsFields>({
    resolver: zodResolver(createCustomerSchema),
  });

  const handleAddNew = () => {
    setIsOpen(true);
  };

  const mutation = useMutation({
    mutationFn: (customer: Customer) => createCustomer(customer),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["customers"],
      });
    },
  });

  const onSubmit: SubmitHandler<FormsFields> = async (data) => {
    try {
      const formData = convertToFormData(data);
      await mutation.mutateAsync(formData);
      setIsOpen(false);
    } catch (error) {
      setIsOpen(false);
    }
  };

  return {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
    setError,
    handleAddNew,
    isOpen,
    onSubmit,
  };
};

export default useCreateCustomer;

export const convertToFormData = (customer: any): Customer => {
  return {
    id: customer.id,
    name: customer.name,
    lastName: customer.lastName,
  };
};
