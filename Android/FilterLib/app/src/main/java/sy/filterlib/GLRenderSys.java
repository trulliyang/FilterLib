package sy.filterlib;

import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.ConfigurationInfo;
import android.graphics.SurfaceTexture;
import android.util.Log;

import java.nio.ByteBuffer;

import javax.microedition.khronos.egl.EGLContext;

/**
 * Created by admin on 2017/9/8.
 */

public class GLRenderSys implements Runnable, GLRenderSysListener {
    private GLRenderSysGLContext mGLContext = null;
    private Thread mThread;
    private boolean mIsStop = true;
    private GLRenderSysListener mListener = null;
    private static GLRenderSys mGLRenderSys = null;

    public static GLRenderSys getInstance() {
        if (mGLRenderSys == null) {
            mGLRenderSys = new GLRenderSys();
        }
        return mGLRenderSys;
    }

    public void init(Context devContext, EGLContext eglContext) {
        //创建JAVA线程
        init(eglContext, this);
        start();

        ActivityManager am = (ActivityManager) devContext.getSystemService(Context.ACTIVITY_SERVICE);
        ConfigurationInfo info = am.getDeviceConfigurationInfo();
//        ykNative.setGlVersion(info.reqGlEsVersion);
    }

    public void init(EGLContext glcontext, GLRenderSysListener listener) {
        mListener = listener;
        if (mGLContext == null) {
            mGLContext = new GLRenderSysGLContext();
            mGLContext.initContext(glcontext);
            mGLContext.setGLRenderSysListener(listener);
        }
    }

    public void createSceneTextureView(final SurfaceTexture texture, final int width, final int height, final boolean isOutStream) {
        if (null != mGLContext) {
            mGLContext.createGLScene(texture);
            Log.e("shiyang", "shiyang createSceneTextureView mGLContext!=null");
        } else {
            Log.e("shiyang", "shiyang createSceneTextureView mGLContext==null");
        }
    }

    public void destroy() {
        //线程结束
        mIsStop = true;
    }

    public void start() {
        mIsStop = false;
        mThread = new Thread(this);
        mThread.start();
    }

    @Override
    public void run() {
        if(mListener == null){
            mThread = null;
            return;
        }
        //
        mListener.thread_start();
        //
        mGLContext.createGLContext();
//        nativeInitRenderFramework();
        //开启主循环
        while (!mIsStop || mThread.isInterrupted()) {
            mGLContext.render();
        }
        //
        mListener.thread_stop();
        //渲染环境析够
        if (mGLContext != null) {
            mGLContext.destroyGLContext();
            mGLContext = null;
        }
        mThread = null;
    }

    @Override
    public void thread_start() {
//        nativeInitRenderFramework();
    }

    @Override
    public void thread_stop() {

    }

    @Override
    public void thread_update() {

    }

    @Override
    public void thread_render() {
//        Log.e("shiyang", "shiyang thread_render");
        nativeInitRenderFramework();
        ByteBuffer buffer = ByteBuffer.allocateDirect(1);
        nativeSetData(buffer, 1);

    }

    public static native void nativeInitRenderFramework();
    public static native void nativeSetData(ByteBuffer buffer, int len);
}
