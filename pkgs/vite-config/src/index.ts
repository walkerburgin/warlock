import { defineConfig, UserConfigFnObject } from "vite";
import fs from "node:fs";
import path from "node:path";

export { ConfigEnv } from "vite"; 

export const generateBaseConfig: UserConfigFnObject = defineConfig(_env => {
    return {
        base: "./",
        clearScreen: false,
        server: {
            fs: {
                strict: false,
            },
            https: {
                key: fs.readFileSync(path.join(import.meta.dirname, "./ssl/server.key"), "utf-8"),
                cert: fs.readFileSync(path.join(import.meta.dirname, "./ssl/server.crt"), "utf-8"),
            },
        },
    };
});
