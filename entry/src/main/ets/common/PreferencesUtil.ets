import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

/**
 * 偏好设置工具类 - 替代 Android SharedPreferences
 * 元服务版：支持轻量级持久化存储
 */
export class PreferencesUtil {
  private static readonly PREF_NAME = 'onetext_settings';
  private static instance: PreferencesUtil | null = null;
  private prefs: preferences.Preferences | null = null;

  private constructor() {
  }

  static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.instance) {
      PreferencesUtil.instance = new PreferencesUtil();
    }
    return PreferencesUtil.instance;
  }

  async init(context: common.UIAbilityContext): Promise<void> {
    this.prefs = await preferences.getPreferences(context, PreferencesUtil.PREF_NAME);
  }

  async getString(key: string, defaultValue: string = ''): Promise<string> {
    if (!this.prefs) return defaultValue;
    const value = await this.prefs.get(key, defaultValue);
    return value as string;
  }

  async putString(key: string, value: string): Promise<void> {
    if (!this.prefs) return;
    await this.prefs.put(key, value);
    await this.prefs.flush();
  }

  async getNumber(key: string, defaultValue: number = 0): Promise<number> {
    if (!this.prefs) return defaultValue;
    const value = await this.prefs.get(key, defaultValue);
    return value as number;
  }

  async putNumber(key: string, value: number): Promise<void> {
    if (!this.prefs) return;
    await this.prefs.put(key, value);
    await this.prefs.flush();
  }

  async getBoolean(key: string, defaultValue: boolean = false): Promise<boolean> {
    if (!this.prefs) return defaultValue;
    const value = await this.prefs.get(key, defaultValue);
    return value as boolean;
  }

  async putBoolean(key: string, value: boolean): Promise<void> {
    if (!this.prefs) return;
    await this.prefs.put(key, value);
    await this.prefs.flush();
  }

  async remove(key: string): Promise<void> {
    if (!this.prefs) return;
    await this.prefs.delete(key);
    await this.prefs.flush();
  }
  
  /**
   * 批量读取多个键值
   */
  async getMultiple<T extends Record<string, any>>(keys: T): Promise<T> {
    if (!this.prefs) return keys;
    
    const result = {} as T;
    const promises = Object.keys(keys).map(async (key) => {
      const defaultValue = keys[key as keyof T];
      const value = await this.prefs!.get(key, defaultValue);
      result[key as keyof T] = value as T[keyof T];
    });
    
    await Promise.all(promises);
    return result;
  }
}
