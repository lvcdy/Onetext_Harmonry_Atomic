import { FormExtensionAbility, formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { preferences } from '@kit.ArkData';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';

const TAG = 'EntryFormAbility';
const DOMAIN = 0x0000;
const MIN_UPDATE_INTERVAL = 30 * 60000; // 最小 30 分钟更新一次

/**
 * 桌面卡片 FormExtensionAbility
 * 元服务版：支持免安装卡片，formId 持久化存储
 */
export default class EntryFormAbility extends FormExtensionAbility {
  private lastUpdateTime: Map<string, number> = new Map();

  onAddForm(want: Want): formBindingData.FormBindingData {
    hilog.info(DOMAIN, TAG, 'onAddForm');

    const formId = want.parameters?.['ohos.extra.param.key.form_identity'] as string;
    if (formId) {
      this.saveFormId(formId);
    }

    const formData: Record<string, string> = {
      'text': '生活不止眼前的苟且，还有诗和远方。',
      'by': '高晓松'
    };
    return formBindingData.createFormBindingData(formData);
  }

  onCastToNormalForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `onCastToNormalForm, formId: ${formId}`);
  }

  async onUpdateForm(formId: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `onUpdateForm, formId: ${formId}`);
    
    // 限流检查
    const now = Date.now();
    const lastUpdate = this.lastUpdateTime.get(formId) || 0;
    if (now - lastUpdate < MIN_UPDATE_INTERVAL) {
      hilog.warn(DOMAIN, TAG, `Update too frequent, ignored. Last update: ${lastUpdate}`);
      return;
    }
    
    this.lastUpdateTime.set(formId, now);
    await this.updateWidgetData(formId);
  }

  async onFormEvent(formId: string, message: string): Promise<void> {
    hilog.info(DOMAIN, TAG, `onFormEvent, formId: ${formId}, message: ${message}`);
    if (message === 'refresh') {
      // 手动刷新也需要限流
      const now = Date.now();
      const lastUpdate = this.lastUpdateTime.get(formId) || 0;
      if (now - lastUpdate < MIN_UPDATE_INTERVAL) {
        hilog.warn(DOMAIN, TAG, `Form event refresh too frequent, ignored`);
        return;
      }
      this.lastUpdateTime.set(formId, now);
      await this.updateWidgetData(formId);
    }
  }

  onRemoveForm(formId: string): void {
    hilog.info(DOMAIN, TAG, `onRemoveForm, formId: ${formId}`);
    this.removeFormId(formId);
  }

  onAcquireFormState(want: Want): formInfo.FormState {
    return formInfo.FormState.READY;
  }

  /**
   * 持久化存储 formId
   */
  private async saveFormId(formId: string): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(this.context, 'form_ids');
      const idsStr = (await prefs.get('form_id_list', '')) as string;
      const ids = idsStr ? idsStr.split(',') : [];
      if (!ids.includes(formId)) {
        ids.push(formId);
        await prefs.put('form_id_list', ids.join(','));
        await prefs.flush();
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, `saveFormId error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
    }
  }

  /**
   * 移除已删除的 formId
   */
  private async removeFormId(formId: string): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(this.context, 'form_ids');
      const idsStr = (await prefs.get('form_id_list', '')) as string;
      const ids = idsStr ? idsStr.split(',').filter((id: string) => id !== formId) : [];
      await prefs.put('form_id_list', ids.join(','));
      await prefs.flush();
    } catch (e) {
      hilog.error(DOMAIN, TAG, `removeFormId error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
    }
  }

  private async updateWidgetData(formId: string): Promise<void> {
    try {
      const prefs = await preferences.getPreferences(this.context, 'onetext_settings');
      const feedArrayStr = await this.readFeedData();
      if (feedArrayStr) {
        const parsed = JSON.parse(feedArrayStr);
        if (!Array.isArray(parsed)) {
          throw new Error('Invalid feed data format');
        }
        const arr: object[] = parsed as object[];
        if (arr.length > 0) {
          const randomIndex = Math.floor(Math.random() * arr.length);
          const item = arr[randomIndex] as Record<string, string>;

          const feedCode = (await prefs.get('feed_code', 0)) as number;
          const feedConfigStr = await this.readFeedConfig();
          let textKey = 'text';
          let byKey = 'by';
          if (feedConfigStr) {
            const parsedConfig = JSON.parse(feedConfigStr);
            if (!Array.isArray(parsedConfig)) {
              throw new Error('Invalid feed config format');
            }
            const feeds = parsedConfig as Record<string, string>[];
            if (feedCode < feeds.length) {
              textKey = feeds[feedCode]['text_key'] ?? 'text';
              byKey = feeds[feedCode]['by_key'] ?? 'by';
            }
          }

          const formData: Record<string, string> = {
            'text': item[textKey] ?? '',
            'by': item[byKey] ?? ''
          };
          const formBindData = formBindingData.createFormBindingData(formData);
          await formProvider.updateForm(formId, formBindData);
        }
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, `updateWidgetData error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
    }
  }

  private async readFeedData(): Promise<string | null> {
    try {
      const filesDir = this.context.filesDir;
      const path = `${filesDir}/OneText/OneText-Library.json`;
      if (fileIo.accessSync(path)) {
        const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY);
        const stat = fileIo.statSync(path);
        const buf = new ArrayBuffer(stat.size);
        fileIo.readSync(file.fd, buf);
        fileIo.closeSync(file);
        const decoder = new util.TextDecoder('utf-8');
        return decoder.decodeToString(new Uint8Array(buf));
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, `readFeedData error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
    }
    return null;
  }

  private async readFeedConfig(): Promise<string | null> {
    try {
      const filesDir = this.context.filesDir;
      const path = `${filesDir}/Feed/Feed.json`;
      if (fileIo.accessSync(path)) {
        const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY);
        const stat = fileIo.statSync(path);
        const buf = new ArrayBuffer(stat.size);
        fileIo.readSync(file.fd, buf);
        fileIo.closeSync(file);
        const decoder = new util.TextDecoder('utf-8');
        return decoder.decodeToString(new Uint8Array(buf));
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, `readFeedConfig error: ${JSON.stringify(e)}, stack: ${(e as Error).stack}`);
    }
    return null;
  }
}
