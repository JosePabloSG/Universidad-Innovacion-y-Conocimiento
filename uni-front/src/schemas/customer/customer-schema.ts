import { z } from "zod";

export const createCustomerSchema = z.object({
  name: z.string().min(2).max(50),
  lastName: z.string().min(2).max(50),
});

export const updateCustomerSchema = z.object({
  name: z.string().min(2).max(50),
  lastName: z.string().min(2).max(50),
});
