import { env } from "./env";

export const BASENAME = env.REACT_APP_BASENAME ?? env.REACT_APP_INITIAL_BASENAME;
