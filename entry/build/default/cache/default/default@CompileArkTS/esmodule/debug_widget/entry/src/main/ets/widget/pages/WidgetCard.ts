if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface WidgetCard_Params {
    text?: string;
    by?: string;
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
    }
    aboutToBeDeleted() {
        this.__text.aboutToBeDeleted();
        this.__by.aboutToBeDeleted();
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.justifyContent(FlexAlign.Center);
            Column.alignItems(HorizontalAlign.Center);
            Column.padding(12);
            Column.linearGradient({
                direction: GradientDirection.RightBottom,
                colors: [
                    ['#667eea', 0.0],
                    ['#764ba2', 1.0]
                ]
            });
            Column.borderRadius(16);
            Column.onClick(() => {
                postCardAction(this, {
                    action: 'router',
                    abilityName: 'EntryAbility'
                });
            });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 一言文字
            Text.create(this.text);
            // 一言文字
            Text.fontSize(16);
            // 一言文字
            Text.fontColor('#FFFFFF');
            // 一言文字
            Text.textAlign(TextAlign.Center);
            // 一言文字
            Text.maxLines(4);
            // 一言文字
            Text.textOverflow({ overflow: TextOverflow.Ellipsis });
            // 一言文字
            Text.width('100%');
            // 一言文字
            Text.padding({ left: 16, right: 16 });
            // 一言文字
            Text.textShadow({
                radius: 4,
                color: '#80000000',
                offsetX: 1,
                offsetY: 1
            });
        }, Text);
        // 一言文字
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 作者
            if (this.by !== '') {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(`—— ${this.by}`);
                        Text.fontSize(12);
                        Text.fontColor('#E0FFFFFF');
                        Text.textAlign(TextAlign.End);
                        Text.width('100%');
                        Text.margin({ top: 8 });
                        Text.padding({ right: 16 });
                        Text.textShadow({
                            radius: 3,
                            color: '#80000000',
                            offsetX: 1,
                            offsetY: 1
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
