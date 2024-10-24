import { getAllCustomers } from "@/services";
import { useQuery } from "@tanstack/react-query";

const useGetAllCustomers = () => {
  const {
    data: customers,
    isLoading,
    isError,
    error,
  } = useQuery({
    queryKey: ["customers"],
    queryFn: getAllCustomers,
  });

  return {
    customers,
    isLoading,
    isError,
    error,
  };
};

export default useGetAllCustomers;
