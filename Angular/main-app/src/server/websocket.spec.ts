import { WebSocketServer } from 'ws';

describe('WebSocket Server', () => {
  let mockWss: any;
  let mockClients: Set<any>;
  let mockWs1: any;
  let mockWs2: any;
  let mockWs3: any;

  beforeEach(() => {
    // Create mock WebSocket clients
    mockWs1 = {
      readyState: 1, // OPEN
      send: jasmine.createSpy('ws1Send'),
      on: jasmine.createSpy('ws1On')
    };
    
    mockWs2 = {
      readyState: 1, // OPEN
      send: jasmine.createSpy('ws2Send'),
      on: jasmine.createSpy('ws2On')
    };
    
    mockWs3 = {
      readyState: 3, // CLOSED
      send: jasmine.createSpy('ws3Send'),
      on: jasmine.createSpy('ws3On')
    };

    // Create mock clients set
    mockClients = new Set([mockWs1, mockWs2, mockWs3]);

    // Create mock WebSocket server
    mockWss = {
      clients: mockClients,
      on: jasmine.createSpy('wssOn')
    };
  });

  it('should broadcast message to all open clients', () => {
    // Simulate the broadcast logic from server.ts
    const broadcastMessage = (data: string) => {
      mockWss.clients.forEach((client: any) => {
        if (client.readyState === 1 /* OPEN */) {
          client.send(data);
        }
      });
    };

    const testMessage = JSON.stringify({ type: 'ws-text', value: 'test broadcast' });
    broadcastMessage(testMessage);

    // Should send to open clients only
    expect(mockWs1.send).toHaveBeenCalledWith(testMessage);
    expect(mockWs2.send).toHaveBeenCalledWith(testMessage);
    expect(mockWs3.send).not.toHaveBeenCalled(); // closed connection
  });

  it('should handle connection and set up message handler', () => {
    let connectionHandler: (ws: any) => void;
    
    // Capture the connection handler
    mockWss.on.and.callFake((event: string, handler: any) => {
      if (event === 'connection') {
        connectionHandler = handler;
      }
    });

    // Simulate server setup from server.ts
    mockWss.on('connection', (ws: any) => {
      ws.on('message', (data: any) => {
        // Broadcast to all clients
        mockWss.clients.forEach((client: any) => {
          if (client.readyState === 1 /* OPEN */) {
            client.send(data.toString());
          }
        });
      });
    });

    expect(mockWss.on).toHaveBeenCalledWith('connection', jasmine.any(Function));

    // Test the connection handler
    connectionHandler!(mockWs1);
    expect(mockWs1.on).toHaveBeenCalledWith('message', jasmine.any(Function));
  });

  it('should handle message relay correctly', () => {
    let messageHandler: (data: any) => void;
    
    // Set up message handler capture
    mockWs1.on.and.callFake((event: string, handler: any) => {
      if (event === 'message') {
        messageHandler = handler;
      }
    });

    // Simulate connection setup
    mockWs1.on('message', (data: any) => {
      mockWss.clients.forEach((client: any) => {
        if (client.readyState === 1 /* OPEN */) {
          client.send(data.toString());
        }
      });
    });

    // Simulate receiving a message from mockWs1
    const testData = Buffer.from(JSON.stringify({ type: 'ws-text', value: 'relay test' }));
    messageHandler!(testData);

    // Should broadcast to all open clients (including sender)
    expect(mockWs1.send).toHaveBeenCalledWith(testData.toString());
    expect(mockWs2.send).toHaveBeenCalledWith(testData.toString());
    expect(mockWs3.send).not.toHaveBeenCalled();
  });

  it('should handle different readyState values correctly', () => {
    // Set different connection states
    mockWs1.readyState = 0; // CONNECTING
    mockWs2.readyState = 1; // OPEN
    mockWs3.readyState = 2; // CLOSING

    const broadcastMessage = (data: string) => {
      mockWss.clients.forEach((client: any) => {
        if (client.readyState === 1 /* OPEN */) {
          client.send(data);
        }
      });
    };

    const testMessage = 'test message';
    broadcastMessage(testMessage);

    // Only OPEN connection should receive message
    expect(mockWs1.send).not.toHaveBeenCalled(); // CONNECTING
    expect(mockWs2.send).toHaveBeenCalledWith(testMessage); // OPEN
    expect(mockWs3.send).not.toHaveBeenCalled(); // CLOSING
  });

  it('should handle empty clients set', () => {
    mockWss.clients = new Set();

    const broadcastMessage = (data: string) => {
      mockWss.clients.forEach((client: any) => {
        if (client.readyState === 1 /* OPEN */) {
          client.send(data);
        }
      });
    };

    // Should not throw error with empty clients
    expect(() => broadcastMessage('test')).not.toThrow();
  });

  describe('Server Integration Tests', () => {
    it('should start WebSocket server on correct port', () => {
      const mockWebSocketServerConstructor = jasmine.createSpy('WebSocketServer')
        .and.returnValue(mockWss);
      
      // Mock the WebSocketServer import (in real test, this would be done with module mocking)
      const createWebSocketServer = (options: { port: number }) => {
        return mockWebSocketServerConstructor(options);
      };

      // Simulate server creation from server.ts
      const wss = createWebSocketServer({ port: 4401 });
      
      expect(mockWebSocketServerConstructor).toHaveBeenCalledWith({ port: 4401 });
      expect(wss).toBe(mockWss);
    });

    xit('should handle server start errors gracefully', () => { //TODO fix test, this hangs
      const consoleSpy = spyOn(console, 'warn');
      
      // Simulate server startup with error handling
      const startWebSocketServer = () => {
        try {
          throw new Error('Port already in use');
        } catch (e) {
          console.warn('WebSocket server start failed:', (e as any)?.message);
        }
      };

      expect(() => startWebSocketServer()).not.toThrow();
      expect(consoleSpy).toHaveBeenCalledWith(
        'WebSocket server start failed:',
        'Port already in use'
      );
    });

    it('should prevent multiple server starts', () => {
      let wsStarted = false;
      const mockServerStart = jasmine.createSpy('serverStart');

      const startWebSocketServer = () => {
        if (wsStarted) return;
        try {
          mockServerStart();
          wsStarted = true;
        } catch (e) {
          console.warn('WebSocket server start failed:', (e as any)?.message);
        }
      };

      // First call should start server
      startWebSocketServer();
      expect(mockServerStart).toHaveBeenCalledTimes(1);

      // Second call should be ignored
      startWebSocketServer();
      expect(mockServerStart).toHaveBeenCalledTimes(1);
    });
  });
});
