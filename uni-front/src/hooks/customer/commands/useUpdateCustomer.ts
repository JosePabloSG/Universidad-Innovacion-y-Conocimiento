import { updateCustomerSchema } from "@/schemas";
import { updateCustomer } from "@/services";
import { Customer, UpdateCustomer } from "@/types";
import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { SubmitHandler, useForm } from "react-hook-form";
import { z } from "zod";

type FormsFields = z.infer<typeof updateCustomerSchema>;

const useUpdateCustomer = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    setValue,
    formState: { errors },
    setError,
  } = useForm<FormsFields>({
    resolver: zodResolver(updateCustomerSchema),
  });

  const mutation = useMutation({
    mutationFn: (data: { id: number; customer: UpdateCustomer }) =>
      updateCustomer(data.id, data.customer),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["customers"],
      });
    },
  });

  const onSubmit: SubmitHandler<FormsFields> = async (data) => {
    try {
      const formData = convertToFormData(data);
      await mutation.mutateAsync({ id: formData.id, customer: formData });
      setIsOpen(false);
    } catch (error) {
      setIsOpen(false);
    }
  };

  return {
    isOpen,
    setIsOpen,
    errorMessage,
    handleSubmit,
    setValue,
    setErrorMessage,
    onSubmit,
    register,
    errors,
    setError,
  };
};

export default useUpdateCustomer;

export const convertToFormData = (customer: any): Customer => {
  return {
    id: customer.id,
    name: customer.name,
    lastName: customer.lastName,
  };
};
