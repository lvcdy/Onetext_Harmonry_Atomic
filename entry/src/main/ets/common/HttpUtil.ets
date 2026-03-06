import http from '@ohos.net.http';
import connection from '@ohos.net.connection';

/**
 * HTTP 网络请求工具类
 * 元服务版：轻量级网络请求，支持超时和错误处理
 */
export class HttpUtil {
  /**
   * 检查网络连接状态
   */
  static async checkNetwork(): Promise<boolean> {
    try {
      const netState = await connection.getNetworkState();
      return netState.isConnected;
    } catch (e) {
      console.error('HttpUtil', `checkNetwork error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
      return false;
    }
  }
  /**
   * 发送 GET 请求
   * @param url 请求地址
   * @returns 响应字符串
   */
  static async get(url: string): Promise<string> {
    // 先检查网络状态
    const isConnected = await HttpUtil.checkNetwork();
    if (!isConnected) {
      throw new Error('Network disconnected');
    }
    
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 15000,
        readTimeout: 15000,
        header: {
          'Content-Type': 'application/json',
          'User-Agent': 'OneText/3.0.0 (HarmonyOS AtomicService)'
        }
      });
      if (response.responseCode === http.ResponseCode.OK) {
        return response.result as string;
      }
      throw new Error(`HTTP Error: ${response.responseCode}`);
    } finally {
      httpRequest.destroy();
    }
  }

  /**
   * 下载文件内容并返回字符串
   * @param url 下载地址
   * @returns 文件内容字符串
   */
  static async downloadText(url: string): Promise<string> {
    return await HttpUtil.get(url);
  }
}
