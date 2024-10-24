import { customerRepository } from "@/repositories";

export const deleteCustomer = (id: number): Promise<void> => {
  return customerRepository.delete(id);
};
