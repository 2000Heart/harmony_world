import { CourseLearning } from '@ohos/learning';
import { KnowledgeMap } from '@ohos/map';
import { QuickStartPage } from '@ohos/quickstart';
import { BreakpointSystem, BreakpointTypeEnum } from '@ohos/utils';
import { AbilityConstant } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult | Promise<AbilityConstant.OnContinueResult> {
    return AbilityConstant.OnContinueResult.AGREE;
  }

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
        .fontWeight(500)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Tabs({
      barPosition: this.currentBreakpoint === BreakpointTypeEnum.LG ?
      BarPosition.Start :
      BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        QuickStartPage()
      }
      .tabBar(this.tabBarBuilder('快速入门', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      TabContent() {
        CourseLearning()
      }
      .tabBar(this.tabBarBuilder('课程学习', 1, $r('app.media.ic_02_on'), $r('app.media.ic_02_off')))

      TabContent() {
        KnowledgeMap()
      }
      .tabBar(this.tabBarBuilder('知识地图', 2, $r('app.media.ic_03_on'), $r('app.media.ic_03_off')))
    }
    .vertical(this.currentBreakpoint === BreakpointTypeEnum.LG ? true : false)
    .divider({
      strokeWidth: 0.5,
      color: '#0D182431'
    })
    .scrollable(false)
    .backgroundColor('#F1F3F5')
    .padding({ top: 36, bottom: 28 })
  }
}