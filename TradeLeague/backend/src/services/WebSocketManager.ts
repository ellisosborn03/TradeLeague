import { WebSocketServer, WebSocket } from 'ws';
import jwt from 'jsonwebtoken';
import { AuthUser } from '../middleware/auth';

interface AuthenticatedWebSocket extends WebSocket {
  user?: AuthUser;
  subscriptions?: Set<string>;
}

class WebSocketManager {
  private wss?: WebSocketServer;
  private clients: Set<AuthenticatedWebSocket> = new Set();

  initialize(wss: WebSocketServer) {
    this.wss = wss;

    wss.on('connection', (ws: AuthenticatedWebSocket, request) => {
      console.log('New WebSocket connection');
      ws.subscriptions = new Set();

      // Handle authentication
      ws.on('message', (data) => {
        try {
          const message = JSON.parse(data.toString());
          this.handleMessage(ws, message);
        } catch (error) {
          console.error('Invalid WebSocket message:', error);
          ws.send(JSON.stringify({
            type: 'error',
            message: 'Invalid message format',
          }));
        }
      });

      ws.on('close', () => {
        console.log('WebSocket connection closed');
        this.clients.delete(ws);
      });

      ws.on('error', (error) => {
        console.error('WebSocket error:', error);
        this.clients.delete(ws);
      });

      this.clients.add(ws);
    });
  }

  private handleMessage(ws: AuthenticatedWebSocket, message: any) {
    switch (message.type) {
      case 'auth':
        this.handleAuth(ws, message.token);
        break;
      case 'subscribe':
        this.handleSubscribe(ws, message.channel);
        break;
      case 'unsubscribe':
        this.handleUnsubscribe(ws, message.channel);
        break;
      case 'ping':
        ws.send(JSON.stringify({ type: 'pong' }));
        break;
      default:
        ws.send(JSON.stringify({
          type: 'error',
          message: 'Unknown message type',
        }));
    }
  }

  private handleAuth(ws: AuthenticatedWebSocket, token: string) {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET!) as AuthUser;
      ws.user = decoded;
      ws.send(JSON.stringify({
        type: 'auth_success',
        user: decoded,
      }));
    } catch (error) {
      ws.send(JSON.stringify({
        type: 'auth_error',
        message: 'Invalid token',
      }));
    }
  }

  private handleSubscribe(ws: AuthenticatedWebSocket, channel: string) {
    if (!ws.user) {
      ws.send(JSON.stringify({
        type: 'error',
        message: 'Authentication required',
      }));
      return;
    }

    ws.subscriptions?.add(channel);
    ws.send(JSON.stringify({
      type: 'subscribed',
      channel,
    }));
  }

  private handleUnsubscribe(ws: AuthenticatedWebSocket, channel: string) {
    ws.subscriptions?.delete(channel);
    ws.send(JSON.stringify({
      type: 'unsubscribed',
      channel,
    }));
  }

  // Broadcast methods
  broadcast(channel: string, data: any) {
    const message = JSON.stringify({
      type: 'broadcast',
      channel,
      data,
    });

    this.clients.forEach((ws) => {
      if (ws.readyState === WebSocket.OPEN && ws.subscriptions?.has(channel)) {
        ws.send(message);
      }
    });
  }

  sendToUser(userId: string, data: any) {
    const message = JSON.stringify({
      type: 'direct_message',
      data,
    });

    this.clients.forEach((ws) => {
      if (ws.readyState === WebSocket.OPEN && ws.user?.userId === userId) {
        ws.send(message);
      }
    });
  }

  // Real-time updates for different features
  broadcastLeaderboardUpdate(leagueId: string, leaderboard: any[]) {
    this.broadcast(`league:${leagueId}:leaderboard`, {
      type: 'leaderboard_update',
      leagueId,
      leaderboard,
    });
  }

  broadcastVaultUpdate(vaultId: string, performance: any) {
    this.broadcast(`vault:${vaultId}`, {
      type: 'vault_update',
      vaultId,
      performance,
    });
  }

  broadcastPredictionMarketUpdate(marketId: string, odds: any[]) {
    this.broadcast(`prediction:${marketId}`, {
      type: 'market_update',
      marketId,
      odds,
    });
  }

  broadcastNewPrediction(marketId: string, prediction: any) {
    this.broadcast(`prediction:${marketId}`, {
      type: 'new_prediction',
      marketId,
      prediction,
    });
  }

  broadcastPrizeDistribution(recipients: string[], amounts: number[]) {
    recipients.forEach((userId, index) => {
      this.sendToUser(userId, {
        type: 'prize_received',
        amount: amounts[index],
      });
    });
  }

  // Global announcements
  broadcastGlobalAnnouncement(message: string, type: 'info' | 'warning' | 'success' = 'info') {
    this.broadcast('global', {
      type: 'announcement',
      message,
      level: type,
      timestamp: new Date().toISOString(),
    });
  }

  // Send system notifications
  sendSystemNotification(userId: string, notification: {
    title: string;
    message: string;
    type: 'info' | 'warning' | 'success' | 'error';
    actionUrl?: string;
  }) {
    this.sendToUser(userId, {
      type: 'notification',
      notification: {
        ...notification,
        timestamp: new Date().toISOString(),
      },
    });
  }

  // Connection statistics
  getConnectionStats() {
    const authenticated = Array.from(this.clients).filter(ws => ws.user).length;
    const total = this.clients.size;
    
    return {
      total,
      authenticated,
      anonymous: total - authenticated,
    };
  }

  // Cleanup disconnected clients
  cleanup() {
    this.clients.forEach((ws) => {
      if (ws.readyState !== WebSocket.OPEN) {
        this.clients.delete(ws);
      }
    });
  }
}

export const wsManager = new WebSocketManager();

// Cleanup every 5 minutes
setInterval(() => {
  wsManager.cleanup();
}, 5 * 60 * 1000);