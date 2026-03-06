// NetworkUtil.ets - API 12+ 兼容版本
import connection from '@ohos.net.connection';
import promptAction from '@ohos.promptAction';

/**
 * 网络状态检测工具类
 * 提供网络连接状态检查和网络类型判断
 */
export class NetworkUtil {
  private static instance: NetworkUtil | null = null;
  
  private constructor() {}
  
  static getInstance(): NetworkUtil {
    if (!NetworkUtil.instance) {
      NetworkUtil.instance = new NetworkUtil();
    }
    return NetworkUtil.instance;
  }
  
  /**
   * 检查网络连接状态
   * @returns 是否已连接
   */
  async isConnected(): Promise<boolean> {
    try {
      const netManager = connection.createNetConn();
      return await netManager.hasDefaultNet();
    } catch (error) {
      console.error('NetworkUtil', `isConnected error: ${JSON.stringify(error)}, stack: ${(error as Error).stack}`);
      return false;
    }
  }
  
  /**
   * 获取网络类型
   * @returns 网络类型字符串
   */
  async getNetworkType(): Promise<string> {
    try {
      const netManager = connection.createNetConn();
      const defaultNet = await netManager.getDefaultNet();
      if (!defaultNet) {
        return 'Disconnected';
      }
      
      const capabilities = await defaultNet.getNetCapabilities();
      if (!capabilities) {
        return 'Unknown';
      }
      
      // 在新 API 中，通过检查能力来判断网络类型
      if (capabilities.hasCapability(connection.NetCap.NET_CAPABILITY_WIFI)) {
        return 'WiFi';
      } else if (capabilities.hasCapability(connection.NetCap.NET_CAPABILITY_CELLULAR)) {
        return 'Mobile';
      } else if (capabilities.hasCapability(connection.NetCap.NET_CAPABILITY_ETHERNET)) {
        return 'Ethernet';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      console.error('NetworkUtil', `getNetworkType error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
      return 'Unknown';
    }
  }
  
  /**
   * 检查并提示网络状态
   * @param showToast 是否显示提示
   * @returns 是否已连接
   */
  async checkAndNotify(showToast: boolean = true): Promise<boolean> {
    const connected = await this.isConnected();
    if (!connected && showToast) {
      promptAction.showToast({ 
        message: '网络连接不可用，请检查网络设置' 
      });
    }
    return connected;
  }
}
