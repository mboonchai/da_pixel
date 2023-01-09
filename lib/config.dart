class Config {

    Config._();
    //1920 x 480
    // pixel: 40 x 10
    // size: 40(dot)+8(gap) ~ 5:1
    static double ratio = 4;
    static double numPixelY = 10;

    static double gapSize = 0.2;
    static bool rotateScreen = false;  //rotate 90 degree clock wise

    static int cacheResolution = 1; //1 = 5(dot) + 1(gap) size , 0 = pixelSize + pixelGap

}