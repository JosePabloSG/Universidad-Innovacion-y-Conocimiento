import { Customer } from "@/types";
import { customerRepository } from "@/repositories";

export const createCustomer = (customer: Customer): Promise<Customer> => {
  return customerRepository.create(customer);
};
