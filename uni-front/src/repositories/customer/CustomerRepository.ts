import { GenericRepository } from "@/core/generic-repository/Repository/GenericRepository";
import { Customer } from "@/types";

class CustomerRepository extends GenericRepository<Customer> {
  constructor() {
    super("/customers");
  }
}

const customerRepository = new CustomerRepository();

export default customerRepository;
