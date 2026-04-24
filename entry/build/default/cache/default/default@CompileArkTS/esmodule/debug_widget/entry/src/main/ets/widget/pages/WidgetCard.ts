if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface WidgetCard_Params {
    text?: string;
    by?: string;
    widgetDark?: string;
    widgetShadow?: string;
    widgetCenter?: string;
}
/**
 * 桌面小组件卡片 - 元服务版
 * 显示一言文字和作者，支持点击跳转到元服务
 */
const localStorage = new LocalStorage();
class WidgetCard extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: WidgetCard_Params) {
    }
    updateStateVars(params: WidgetCard_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__text.purgeDependencyOnElmtId(rmElmtId);
        this.__by.purgeDependencyOnElmtId(rmElmtId);
        this.__widgetDark.purgeDependencyOnElmtId(rmElmtId);
        this.__widgetShadow.purgeDependencyOnElmtId(rmElmtId);
        this.__widgetCenter.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__text.aboutToBeDeleted();
        this.__by.aboutToBeDeleted();
        this.__widgetDark.aboutToBeDeleted();
        this.__widgetShadow.aboutToBeDeleted();
        this.__widgetCenter.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __text: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('text', '生活不止眼前的苟且，还有诗和远方。', "text");
    get text() {
        return this.__text.get();
    }
    set text(newValue: string) {
        this.__text.set(newValue);
    }
    private __by: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('by', '高晓松', "by");
    get by() {
        return this.__by.get();
    }
    set by(newValue: string) {
        this.__by.set(newValue);
    }
    private __widgetDark: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('widget_dark', 'false', "widgetDark");
    get widgetDark() {
        return this.__widgetDark.get();
    }
    set widgetDark(newValue: string) {
        this.__widgetDark.set(newValue);
    }
    private __widgetShadow: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('widget_shadow', 'true', "widgetShadow");
    get widgetShadow() {
        return this.__widgetShadow.get();
    }
    set widgetShadow(newValue: string) {
        this.__widgetShadow.set(newValue);
    }
    private __widgetCenter: ObservedPropertyAbstractPU<string> = this.createLocalStorageProp<string>('widget_center', 'true', "widgetCenter");
    get widgetCenter() {
        return this.__widgetCenter.get();
    }
    set widgetCenter(newValue: string) {
        this.__widgetCenter.set(newValue);
    }
    private isEnabled(value: string): boolean {
        return value === 'true';
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.justifyContent(FlexAlign.Center);
            Column.alignItems(HorizontalAlign.Center);
            Column.padding(0);
            Column.backgroundColor(Color.Transparent);
            Column.onClick(() => {
                postCardAction(this, {
                    action: 'router',
                    abilityName: 'EntryAbility'
                });
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.isEnabled(this.widgetCenter)) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.text);
                        Text.fontSize(15);
                        Text.fontColor(this.isEnabled(this.widgetDark) ? '#1C1C1C' : '#FFFFFF');
                        Text.textAlign(TextAlign.Center);
                        Text.maxLines(4);
                        Text.textOverflow({ overflow: TextOverflow.Ellipsis });
                        Text.width('100%');
                        Text.textShadow({
                            radius: this.isEnabled(this.widgetShadow) ? 8 : 0,
                            color: this.isEnabled(this.widgetShadow) ? '#B0000000' : '#00000000',
                            offsetX: 0,
                            offsetY: 0
                        });
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.text);
                        Text.fontSize(15);
                        Text.fontColor(this.isEnabled(this.widgetDark) ? '#1C1C1C' : '#FFFFFF');
                        Text.textAlign(TextAlign.Start);
                        Text.maxLines(4);
                        Text.textOverflow({ overflow: TextOverflow.Ellipsis });
                        Text.textShadow({
                            radius: this.isEnabled(this.widgetShadow) ? 8 : 0,
                            color: this.isEnabled(this.widgetShadow) ? '#B0000000' : '#00000000',
                            offsetX: 0,
                            offsetY: 0
                        });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.by !== '') {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Text.create(`—— ${this.by}`);
                                    Text.fontSize(15);
                                    Text.fontColor(this.isEnabled(this.widgetDark) ? '#434343' : '#FFFFFF');
                                    Text.textAlign(TextAlign.End);
                                    Text.width('100%');
                                    Text.textShadow({
                                        radius: this.isEnabled(this.widgetShadow) ? 8 : 0,
                                        color: this.isEnabled(this.widgetShadow) ? '#B0000000' : '#00000000',
                                        offsetX: 0,
                                        offsetY: 0
                                    });
                                }, Text);
                                Text.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "WidgetCard";
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadEtsCard(new WidgetCard(undefined, {}, localStorage), "com.atomicservice.6917599415967211466/entry/ets/widget/pages/WidgetCard");
ViewStackProcessor.StopGetAccessRecording();
