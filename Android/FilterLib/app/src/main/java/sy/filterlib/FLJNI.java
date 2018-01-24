package sy.filterlib;

import java.nio.ByteBuffer;

/**
 * Created by SHI.yang on 2017/9/13.
 */

public class FLJNI {
    static {
        System.loadLibrary("native-lib");
    }

    boolean mHasInitialised = false;

    void FLInit(){
        nativeFLInit();
        mHasInitialised = true;
    }

    void FLDraw(int texid){
        nativeFLRender(texid);
    }

    void FLSetSize(int width, int height){
        nativeFLResize(width, height);
    }

    /*
    *
    *
    * @type 0:nv12
    *       1:nv21
    *       2:rgba
    * */
    void FLSetImageData(ByteBuffer data, int width, int height, int len, int type) {
        nativeFLSetImageData(data, width, height, len, type);
    }

    public native void nativeFLInit();
    public native void nativeFLRender(int texid);
    public native void nativeFLResize(int width, int height);
    public native void nativeFLSetImageData(ByteBuffer data, int width, int height, int len, int type);
}
