enum HttpMethod {
  GET = "GET",
  POST = "POST",
  PATCH = "PATCH",
  DELETE = "DELETE",
}

interface HttpClientOptions {
  method: HttpMethod;
  endpoint: string;
  data?: any;
  headers?: HeadersInit;
}

class HttpError extends Error {
  status?: number;
  data?: any;

  constructor(message: string, status?: number, data?: any) {
    super(message);
    this.status = status;
    this.data = data;
    Object.setPrototypeOf(this, HttpError.prototype);
  }
}

async function httpClient<T>({
  method,
  endpoint,
  data,
  headers,
}: HttpClientOptions): Promise<T> {
  const config: RequestInit = {
    method,
    headers: {
      "Content-Type": "application/json",
      ...headers,
    },
    ...(data && { body: JSON.stringify(data) }),
  };

  const response = await fetch(
    `${process.env.NEXT_PUBLIC_BACKEND_URL}${endpoint}`,
    config
  );

  let responseData: any = null;

  const contentType = response.headers.get("Content-Type");

  if (contentType && contentType.includes("application/json")) {
    responseData = await response.json();
  } else if (contentType && contentType.includes("text/")) {
    responseData = await response.text();
  }

  if (!response.ok) {
    const error = new HttpError(
      responseData?.message || "Ocurrió un error en la solicitud",
      response.status,
      responseData
    );
    throw error;
  }

  return responseData as T;
}

export { HttpMethod, HttpError };
export type { HttpClientOptions };
export default httpClient;
