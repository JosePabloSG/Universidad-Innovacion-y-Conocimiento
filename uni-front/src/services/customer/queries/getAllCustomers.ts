import { Customer } from "@/types";
import { customerRepository } from "@/repositories";

export const getAllCustomers = (): Promise<Customer[]> => {
  return customerRepository.getAll();
};
