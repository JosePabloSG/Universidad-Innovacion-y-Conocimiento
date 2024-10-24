import { deleteCustomer } from "@/services";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";

const useDeleteCustomer = ({ itemId }: { itemId: number }) => {
  const queryClient = useQueryClient();
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isOpen, setIsOpen] = useState(false);

  const mutation = useMutation({
    mutationFn: (itemId: number) => deleteCustomer(itemId),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["customers"],
      });
    },
  });
  const confirmDelete = async () => {
    try {
      await mutation.mutateAsync(itemId);
      setIsOpen(false);
    } catch (error: any) {
      setErrorMessage(error.message);
    }
  };

  const handleDelete = async () => {
    setIsOpen(true);
  };

  const closeErrorModal = () => {
    setErrorMessage(null);
  };
  return {
    isOpen,
    handleDelete,
    errorMessage,
    closeErrorModal,
    confirmDelete,
  };
};

export default useDeleteCustomer;
