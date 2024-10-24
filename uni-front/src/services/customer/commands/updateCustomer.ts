import { Customer, UpdateCustomer } from "@/types";
import { customerRepository } from "@/repositories";

export const updateCustomer = (
  id: number,
  customer: UpdateCustomer
): Promise<Customer> => {
  return customerRepository.update(id, customer);
};
