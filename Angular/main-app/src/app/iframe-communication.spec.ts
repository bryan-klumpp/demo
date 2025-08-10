describe('Iframe Communication Tests', () => {
  describe('PostMessage Communication', () => {
    let mockParentWindow: any;
    let mockWindow: any;
    let inputElement: HTMLInputElement;

    beforeEach(() => {
      // Set up DOM
      document.body.innerHTML = `
        <input id="mainText" type="text" autocomplete="off" />
        <input id="leftText" type="text" placeholder="Type to sync..." />
      `;

      inputElement = document.getElementById('mainText') as HTMLInputElement;
      
      // Mock window.parent
      mockParentWindow = {
        postMessage: jasmine.createSpy('parentPostMessage')
      };
      
      mockWindow = {
        parent: mockParentWindow,
        addEventListener: jasmine.createSpy('addEventListener')
      };

      // Replace global window with mock
      spyOnProperty(window, 'parent').and.returnValue(mockParentWindow);
    });

    it('should send postMessage when input value changes', () => {
      // Simulate the event listener logic from main-iframe.html
      const handleInput = (event: Event) => {
        const target = event.target as HTMLInputElement;
        window.parent.postMessage({
          type: 'sync-text',
          value: target.value,
          source: 'main'
        }, '*');
      };

      inputElement.addEventListener('input', handleInput);
      
      // Simulate user input
      inputElement.value = 'test message';
      const inputEvent = new Event('input');
      inputElement.dispatchEvent(inputEvent);

      expect(mockParentWindow.postMessage).toHaveBeenCalledWith({
        type: 'sync-text',
        value: 'test message',
        source: 'main'
      }, '*');
    });

    it('should update input value when receiving postMessage', () => {
      const leftInput = document.getElementById('leftText') as HTMLInputElement;
      
      // Simulate the message handler logic from left-rail.html
      const handleMessage = (event: MessageEvent) => {
        const data = event.data;
        if (data && data.type === 'sync-text' && data.source !== 'left') {
          leftInput.value = data.value;
        }
      };

      // Simulate receiving a message
      const messageEvent = new MessageEvent('message', {
        data: {
          type: 'sync-text',
          value: 'received message',
          source: 'main'
        }
      });

      handleMessage(messageEvent);

      expect(leftInput.value).toBe('received message');
    });

    it('should ignore messages from same source', () => {
      const leftInput = document.getElementById('leftText') as HTMLInputElement;
      leftInput.value = 'original value';
      
      const handleMessage = (event: MessageEvent) => {
        const data = event.data;
        if (data && data.type === 'sync-text' && data.source !== 'left') {
          leftInput.value = data.value;
        }
      };

      // Simulate receiving a message from same source
      const messageEvent = new MessageEvent('message', {
        data: {
          type: 'sync-text',
          value: 'should be ignored',
          source: 'left'
        }
      });

      handleMessage(messageEvent);

      expect(leftInput.value).toBe('original value');
    });

    it('should ignore non sync-text messages', () => {
      const leftInput = document.getElementById('leftText') as HTMLInputElement;
      leftInput.value = 'original value';
      
      const handleMessage = (event: MessageEvent) => {
        const data = event.data;
        if (data && data.type === 'sync-text' && data.source !== 'left') {
          leftInput.value = data.value;
        }
      };

      // Simulate receiving a different message type
      const messageEvent = new MessageEvent('message', {
        data: {
          type: 'other-message',
          value: 'should be ignored',
          source: 'main'
        }
      });

      handleMessage(messageEvent);

      expect(leftInput.value).toBe('original value');
    });
  });

  describe('WebSocket Communication', () => {
    let mockWebSocket: any;
    let mockWebSocketConstructor: jasmine.Spy;
    let wsInput: HTMLInputElement;
    let wsStatus: HTMLElement;

    beforeEach(() => {
      // Set up DOM
      document.body.innerHTML = `
        <input id="wsText" type="text" placeholder="Type to broadcast..." />
        <span id="wsStatus">connecting...</span>
        <input id="leftWsText" type="text" placeholder="WebSocket sync..." />
      `;

      wsInput = document.getElementById('wsText') as HTMLInputElement;
      wsStatus = document.getElementById('wsStatus') as HTMLElement;

      // Mock WebSocket
      mockWebSocket = {
        send: jasmine.createSpy('send'),
        close: jasmine.createSpy('close'),
        readyState: 1, // WebSocket.OPEN
        onopen: null,
        onclose: null,
        onerror: null,
        onmessage: null
      };

      mockWebSocketConstructor = jasmine.createSpy('WebSocket').and.returnValue(mockWebSocket);
      
      // Replace global WebSocket
      (window as any).WebSocket = mockWebSocketConstructor;
      (window as any).WebSocket.OPEN = 1;
      (window as any).WebSocket.CLOSED = 3;
    });

    it('should create WebSocket connection with correct URL', () => {
      // Simulate connect function from iframe
      const connect = () => {
        const ws = new (window as any).WebSocket('ws://localhost:4401');
        return ws;
      };

      const ws = connect();

      expect(mockWebSocketConstructor).toHaveBeenCalledWith('ws://localhost:4401');
      expect(ws).toBe(mockWebSocket);
    });

    it('should update status on WebSocket open', () => {
      const connect = () => {
        const ws = new (window as any).WebSocket('ws://localhost:4401');
        ws.onopen = () => {
          wsStatus.textContent = 'connected';
        };
        return ws;
      };

      const ws = connect();
      
      // Simulate onopen event
      if (ws.onopen) {
        ws.onopen(new Event('open'));
      }

      expect(wsStatus.textContent).toBe('connected');
    });

    it('should update status on WebSocket close', () => {
      const connect = () => {
        const ws = new (window as any).WebSocket('ws://localhost:4401');
        ws.onclose = () => {
          wsStatus.textContent = 'disconnected';
        };
        return ws;
      };

      const ws = connect();
      
      // Simulate onclose event
      if (ws.onclose) {
        ws.onclose(new CloseEvent('close'));
      }

      expect(wsStatus.textContent).toBe('disconnected');
    });

    it('should send message when input changes', () => {
      const ws = mockWebSocket;
      
      // Simulate input event handler
      const handleInput = (event: Event) => {
        const target = event.target as HTMLInputElement;
        const value = target.value;
        if (ws && ws.readyState === 1) { // WebSocket.OPEN
          ws.send(JSON.stringify({ type: 'ws-text', value: value }));
        }
      };

      wsInput.addEventListener('input', handleInput);
      
      // Simulate user input
      wsInput.value = 'test websocket message';
      const inputEvent = new Event('input');
      wsInput.dispatchEvent(inputEvent);

      expect(mockWebSocket.send).toHaveBeenCalledWith(
        JSON.stringify({ type: 'ws-text', value: 'test websocket message' })
      );
    });

    it('should not send message when WebSocket is not open', () => {
      const ws = mockWebSocket;
      ws.readyState = 0; // WebSocket.CONNECTING
      
      const handleInput = (event: Event) => {
        const target = event.target as HTMLInputElement;
        const value = target.value;
        if (ws && ws.readyState === 1) { // WebSocket.OPEN
          ws.send(JSON.stringify({ type: 'ws-text', value: value }));
        }
      };

      wsInput.addEventListener('input', handleInput);
      
      wsInput.value = 'should not send';
      const inputEvent = new Event('input');
      wsInput.dispatchEvent(inputEvent);

      expect(mockWebSocket.send).not.toHaveBeenCalled();
    });

    it('should update input value when receiving WebSocket message', () => {
      const leftWsInput = document.getElementById('leftWsText') as HTMLInputElement;
      
      const ws = mockWebSocket;
      ws.onmessage = (event: MessageEvent) => {
        try {
          const msg = JSON.parse(event.data);
          if (msg && msg.type === 'ws-text') {
            const field = document.getElementById('leftWsText') as HTMLInputElement;
            if (field && document.activeElement !== field) {
              field.value = msg.value != null ? msg.value : '';
            }
          }
        } catch (err) {
          // ignore parse errors
        }
      };

      // Simulate receiving WebSocket message
      const messageData = JSON.stringify({
        type: 'ws-text',
        value: 'websocket broadcast message'
      });

      if (ws.onmessage) {
        ws.onmessage(new MessageEvent('message', { data: messageData }));
      }

      expect(leftWsInput.value).toBe('websocket broadcast message');
    });

    it('should not update input if element is focused', () => {
      const leftWsInput = document.getElementById('leftWsText') as HTMLInputElement;
      leftWsInput.value = 'user typing...';
      
      // Mock document.activeElement
      spyOnProperty(document, 'activeElement', 'get').and.returnValue(leftWsInput);
      
      const ws = mockWebSocket;
      ws.onmessage = (event: MessageEvent) => {
        try {
          const msg = JSON.parse(event.data);
          if (msg && msg.type === 'ws-text') {
            const field = document.getElementById('leftWsText') as HTMLInputElement;
            if (field && document.activeElement !== field) {
              field.value = msg.value != null ? msg.value : '';
            }
          }
        } catch (err) {
          // ignore parse errors
        }
      };

      const messageData = JSON.stringify({
        type: 'ws-text',
        value: 'should not override'
      });

      if (ws.onmessage) {
        ws.onmessage(new MessageEvent('message', { data: messageData }));
      }

      expect(leftWsInput.value).toBe('user typing...');
    });

    it('should handle malformed WebSocket messages gracefully', () => {
      const leftWsInput = document.getElementById('leftWsText') as HTMLInputElement;
      leftWsInput.value = 'original value';
      
      const ws = mockWebSocket;
      ws.onmessage = (event: MessageEvent) => {
        try {
          const msg = JSON.parse(event.data);
          if (msg && msg.type === 'ws-text') {
            const field = document.getElementById('leftWsText') as HTMLInputElement;
            if (field && document.activeElement !== field) {
              field.value = msg.value != null ? msg.value : '';
            }
          }
        } catch (err) {
          // ignore parse errors
        }
      };

      // Send malformed JSON
      if (ws.onmessage) {
        ws.onmessage(new MessageEvent('message', { data: 'invalid json {' }));
      }

      expect(leftWsInput.value).toBe('original value');
    });

    it('should ignore non ws-text WebSocket messages', () => {
      const leftWsInput = document.getElementById('leftWsText') as HTMLInputElement;
      leftWsInput.value = 'original value';
      
      const ws = mockWebSocket;
      ws.onmessage = (event: MessageEvent) => {
        try {
          const msg = JSON.parse(event.data);
          if (msg && msg.type === 'ws-text') {
            const field = document.getElementById('leftWsText') as HTMLInputElement;
            if (field && document.activeElement !== field) {
              field.value = msg.value != null ? msg.value : '';
            }
          }
        } catch (err) {
          // ignore parse errors
        }
      };

      const messageData = JSON.stringify({
        type: 'other-type',
        value: 'should be ignored'
      });

      if (ws.onmessage) {
        ws.onmessage(new MessageEvent('message', { data: messageData }));
      }

      expect(leftWsInput.value).toBe('original value');
    });
  });
});
