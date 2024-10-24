export interface Customer {
  id: number;
  name: string;
  lastName: string;
}

export interface CreateCustomer {
  name: string;
  lastName: string;
}

export interface UpdateCustomer {
  name: string;
  lastName: string;
}
