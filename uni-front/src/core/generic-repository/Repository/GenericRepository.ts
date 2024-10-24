import httpClient, { HttpMethod } from "@/helpers/httpClient";
import { IRepository } from "../Interfaces/IRepository";

export class GenericRepository<T extends Record<string, any>> implements IRepository<T> {
  protected endpoint: string;

  constructor(endpoint: string) {
    this.endpoint = endpoint;
  }

  getAll(): Promise<T[]> {
    return httpClient<T[]>({
      method: HttpMethod.GET,
      endpoint: this.endpoint,
    });
  }

  getById(id: number): Promise<T> {
    return httpClient<T>({
      method: HttpMethod.GET,
      endpoint: `${this.endpoint}/${id}`,
    });
  }

  create(item: T): Promise<T> {
    return httpClient<T>({
      method: HttpMethod.POST,
      endpoint: this.endpoint,
      data: item,
    });
  }

  update(id: number, item: Partial<T>): Promise<T> {
    return httpClient<T>({
      method: HttpMethod.PATCH,
      endpoint: `${this.endpoint}/${id}`,
      data: item,
    });
  }

  delete(id: number): Promise<void> {
    return httpClient<void>({
      method: HttpMethod.DELETE,
      endpoint: `${this.endpoint}/${id}`,
    });
  }
}
