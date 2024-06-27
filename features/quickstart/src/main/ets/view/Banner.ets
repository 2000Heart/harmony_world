import { BreakpointType, BreakpointTypeEnum } from '@ohos/utils';
import { BannerClass } from '../model/BannerClass';
import { bufferToString } from '../util/BufferUtil';

@Preview
@Component
export struct Banner {
  @Consume('articlePathStack') articlePathStack: NavPathStack;
  @State bannerList: BannerClass[] = [];
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;

  aboutToAppear(): void {
    this.getBannerDataFromJSON()
  }

  getBannerDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('BannerData.json').then(value => {
      this.bannerList = JSON.parse(bufferToString(value.buffer)) as BannerClass[];
    })
  }

  clickToDetailPage(item: BannerClass) {
    this.articlePathStack.pushPathByName('bannerDetailPage', item);
  }

  build() {
    Swiper() {
      ForEach(this.bannerList, (item: BannerClass) => {
        Image($r(item.imageSrc))
          .objectFit(ImageFit.Contain)
          .width('100%')
          .borderRadius(16)
          .padding({ top: 11, left: 16, right: 16 })
          .onClick(() => {
            this.clickToDetailPage(item)
          })

      }, (item: BannerClass) => item.id)
    }
    .autoPlay(true)
    .loop(true)
    .displayCount(new BreakpointType({ sm: 1, md: 2, lg: 2 }).getValue(this.currentBreakpoint))
    .displayMode(SwiperDisplayMode.STRETCH)
    .indicator(
      this.currentBreakpoint == BreakpointTypeEnum.SM ?
        Indicator.dot().color('#1a000000').selectedColor('#0A59F7') :
        false
    )
    .nextMargin(
      new BreakpointType<Length>(
        { sm: 0, md: 12, lg: 266 }
      ).getValue(this.currentBreakpoint)
    )
  }
}
