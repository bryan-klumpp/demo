import {
  AngularNodeAppEngine,
  createNodeRequestHandler,
  isMainModule,
  writeResponseToNodeResponse,
} from '@angular/ssr/node';
import express from 'express';
import { join } from 'node:path';
import { WebSocketServer } from 'ws';

const browserDistFolder = join(import.meta.dirname, '../browser');

const app = express();
const angularApp = new AngularNodeAppEngine();

// Start a standalone WebSocket server for demo/broadcast on port 4401
let wsStarted = false;
function startWebSocketServer() {
  if (wsStarted) return;
  try {
    const wss = new WebSocketServer({ port: 4401 });
    wss.on('connection', (ws) => {
      ws.on('message', (data) => {
        // Broadcast to all clients
        wss.clients.forEach((client) => {
          if (client.readyState === 1 /* OPEN */) {
            client.send(data.toString());
          }
        });
      });
    });
    console.log('WebSocket server listening on ws://localhost:4401');
    wsStarted = true;
  } catch (e) {
    console.warn('WebSocket server start failed:', (e as any)?.message);
  }
}
startWebSocketServer();

/**
 * Example Express Rest API endpoints can be defined here.
 * Uncomment and define endpoints as necessary.
 *
 * Example:
 * ```ts
 * app.get('/api/{*splat}', (req, res) => {
 *   // Handle API request
 * });
 * ```
 */

/**
 * Serve static files from /browser
 */
app.use(
  express.static(browserDistFolder, {
    maxAge: '1y',
    index: false,
    redirect: false,
  }),
);

/**
 * Handle all other requests by rendering the Angular application.
 */
app.use((req, res, next) => {
  angularApp
    .handle(req)
    .then((response) =>
      response ? writeResponseToNodeResponse(response, res) : next(),
    )
    .catch(next);
});

/**
 * Start the server if this module is the main entry point.
 * The server listens on the port defined by the `PORT` environment variable, or defaults to 4000.
 */
if (isMainModule(import.meta.url)) {
  const port = process.env['PORT'] || 4000;
  app.listen(port, (error) => {
    if (error) {
      throw error;
    }

    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}

/**
 * Request handler used by the Angular CLI (for dev-server and during build) or Firebase Cloud Functions.
 */
export const reqHandler = createNodeRequestHandler(app);
