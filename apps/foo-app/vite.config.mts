import { generateBaseConfig, ConfigEnv } from "@monorepo/vite-config";

export default (env: ConfigEnv) => {
    const config = generateBaseConfig(env);
    return config;
};