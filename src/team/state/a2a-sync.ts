import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

/**
 * A2A Shadow Syncer - Non-intrusive memory sharing for OMC.
 * Syncs local state to global Redis AND recalls facts for agents.
 */
export class A2ASyncer {
  private static redisUrl = process.env.A2A_REDIS_URL || 'redis://:fsc-mesh-2026@100.80.87.180:6379';
  private static isEnabled = !!process.env.A2A_ENABLE_SYNC;

  /**
   * Sync a fact or message to the a2a-dev bus.
   */
  static async sync(type: string, payload: any, roundId: string = 'omc-global') {
    if (!this.isEnabled) return;

    try {
      const data = JSON.stringify(payload).replace(/"/g, '\\"');
      const cmd = `redis-cli -u ${this.redisUrl} XADD a2a:omc:sync * type ${type} data "${data}" round ${roundId}`;
      exec(cmd); // Fire and forget
    } catch (e) {
      // Silent fail
    }
  }

  /**
   * Recall global facts from Redis for a given round.
   * Returns a formatted string to be injected into Agent context.
   */
  static async recallFacts(roundId: string = 'omc-global'): Promise<string> {
    if (!this.isEnabled) return '';

    try {
      // We look for both omc-sync events and the shared memory facts from a2a-dev
      const memoryKey = `a2a:memory:${roundId}`;
      const { stdout } = await execAsync(`redis-cli -u ${this.redisUrl} HGETALL ${memoryKey}`);
      
      if (!stdout || stdout.trim() === '') return '';

      // Simple HGETALL parser for redis-cli output (alternating key/value lines)
      const lines = stdout.split('\n').map(l => l.trim()).filter(l => l !== '');
      let factsStr = "\n### Global Shared Memory (from Redis) ###\n";
      for (let i = 0; i < lines.length; i += 2) {
        if (lines[i] && lines[i+1]) {
          factsStr += `- ${lines[i]}: ${lines[i+1]}\n`;
        }
      }
      return factsStr + "### End Shared Memory ###\n";
    } catch (e) {
      return '';
    }
  }
}
