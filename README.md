# AnimatedTransitionsDemo
<br/>学习了转场动画, 自己写个demo备份一下. 目前Demo中只处理了以下几种动画.
<br/>typedef NS_ENUM (NSUInteger, GATransitionAnimateType)  {
<br/>    NoneAnimateType,    // 没有动画
<br/>    FadeAnimateType,    // 渐显动画
<br/>    SwipeAnimateType,   // 侧滑动画 需要在UIScreenEdgePanGestureRecognizer中调用
<br/>    PopupAnimateType,   // 弹性Pop动画
<br/>    CircleAnimateType,  // 扩散圆动画
<br/>    CardAnimateType,    // 底部卡片动画 使用时需要modalPresentationStyle = UIModalPresentationCustom
<br/>    OpenAnimateType     // Push/Pop开门动画 需要在导航的Push/Pop中调用
<br/>};
<br/>博客:https://blog.csdn.net/wsyx768/article/details/102957851
