import { config } from "dotenv";
import { server, settings, use } from "nexus";
import { prisma } from "nexus-plugin-prisma";
import checkJwt from "./util/jwt";

const isDev = process.env.NODE_ENV === "development";

config();

settings.change({
  server: {
    playground: true,
    port: Number(process.env.PORT) || 4000
  }
});

server.express.use(checkJwt);

use(prisma());

