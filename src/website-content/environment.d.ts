declare namespace NodeJS {
    interface ProcessEnv {
      FLEXPORT_API_CLIENT_ID: string;
      FLEXPORT_API_CLIENT_SECRET: string;
      NODE_TLS_REJECT_UNAUTHORIZED: string;
    }
}
