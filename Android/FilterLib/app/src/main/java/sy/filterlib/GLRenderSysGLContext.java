package sy.filterlib;

import android.graphics.SurfaceTexture;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

import static android.opengl.EGL14.EGL_CONTEXT_CLIENT_VERSION;
import static android.opengl.EGL14.EGL_OPENGL_ES2_BIT;

/**
 * Created by admin on 2017/9/8.
 */

public class GLRenderSysGLContext {
    private EGL10 mEGL10 = null;
    private EGLDisplay mEGLDisplay = null;
    private EGLConfig mEGLConfig = null;
    private EGLContext mEGLContext = null;
    private EGLContext mEGLOutContext = null;
    private boolean createSelf = false;
    private GLRenderSysListener mListener = null;
    private EGLSurface mEGLSurface = null;


    //初始化JAVA层的渲染环境
    void initContext(EGLContext context) {
        if (context != null) {
            mEGLOutContext = context;
        }
    }

    public void setGLRenderSysListener(GLRenderSysListener listener) {
        this.mListener = listener;
    }

    void destroyContext() {
        //
        mEGL10.eglMakeCurrent(mEGLDisplay, mEGL10.EGL_NO_SURFACE, mEGL10.EGL_NO_SURFACE, mEGL10.EGL_NO_CONTEXT);
        //
        destroyGLScene();
        destroyGLContext();
        //
        mEGL10.eglTerminate(mEGLDisplay);

        mEGLOutContext = null;
        mEGLConfig = null;
        mEGLDisplay = null;
        mEGL10 = null;
    }

    //
    void createGLContext() {
        createSelf = true;
        //自己创建context
        mEGL10 = (EGL10) EGLContext.getEGL();
        mEGLDisplay = mEGL10.eglGetDisplay(EGL10.EGL_DEFAULT_DISPLAY);
        int[] version = new int[2];
        mEGL10.eglInitialize(mEGLDisplay, version);
        int[] configsCount = new int[1];
        EGLConfig[] configs = new EGLConfig[1];
        int[] configSpec = {
                EGL10.EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
                EGL10.EGL_RED_SIZE, 8,
                EGL10.EGL_GREEN_SIZE, 8,
                EGL10.EGL_BLUE_SIZE, 8,
                EGL10.EGL_ALPHA_SIZE, 8,
                EGL10.EGL_DEPTH_SIZE, 8,
                EGL10.EGL_STENCIL_SIZE, 0,
                EGL10.EGL_NONE
        };
        if (!mEGL10.eglChooseConfig(mEGLDisplay, configSpec, configs, 1, configsCount)) {
        } else if (configsCount[0] > 0) {
            mEGLConfig = configs[0];
        }
        if (mEGLConfig == null) {
            throw new RuntimeException("eglConfig not initialized");
        }
        int[] attrib_list = {EGL_CONTEXT_CLIENT_VERSION, 2, EGL10.EGL_NONE};
        if (mEGLOutContext == null) {
            mEGLContext = mEGL10.eglCreateContext(mEGLDisplay, mEGLConfig, mEGL10.EGL_NO_CONTEXT, attrib_list);
        } else {
            mEGLContext = mEGL10.eglCreateContext(mEGLDisplay, mEGLConfig, mEGLOutContext, attrib_list);
        }

        int[] qvalue = new int[1];
        mEGL10.eglQueryContext(mEGLDisplay, mEGLContext, EGL_CONTEXT_CLIENT_VERSION, qvalue);
    }

    //常见一个GL场景
    public void createGLScene(SurfaceTexture surfacetexture) {
        //扔到循环队列中
        mEGLSurface = mEGL10.eglCreateWindowSurface(mEGLDisplay, mEGLConfig, surfacetexture, null);
        if (mEGLSurface == null || mEGLSurface == EGL10.EGL_NO_SURFACE) {
            int error = mEGL10.eglGetError();
        } else {
            mEGL10.eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext);
        }
    }

    //离线的GL场景
    public void createGLSceneOff(int width, int height) {
        //扔到循环队列中
        int[] attrib_list = {EGL10.EGL_NONE};
        EGLSurface mEGLSurface = mEGL10.eglCreatePbufferSurface(mEGLDisplay, mEGLConfig, attrib_list);
        if (mEGLSurface == null || mEGLSurface == EGL10.EGL_NO_SURFACE) {
            int error = mEGL10.eglGetError();
        }
        mEGL10.eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext);
    }

    //析够场景
    private void destroyGLScene() {
        mEGL10.eglDestroySurface(mEGLDisplay, mEGLSurface);
    }

    //
    public void destroyGLContext() {
        if (createSelf) {
            createSelf = false;
            mEGL10.eglDestroyContext(mEGLDisplay, mEGLContext);
        }
        mEGLContext = null;
    }

    //激活场景
    private boolean active() {
        if (mEGLDisplay == null || mEGLSurface == null || mEGLContext == null) {
//            Log.e("shiyang", "shiyang jave activeScene failed, mEGLDisplay == null || mEGLSurface == null || mEGLContext == null");
            return false;
        }
        if (!mEGL10.eglMakeCurrent(mEGLDisplay, mEGLSurface, mEGLSurface, mEGLContext))
        {
//            Log.e("shiyang", "shiyang jave activeScene failed, eglMakeCurrent has problem");
//            return false;
        }

        return true;

    }

    //交换场景
    private void swap() {
        if (null != mEGLDisplay && null != mEGLSurface) {
            mEGL10.eglSwapBuffers(mEGLDisplay, mEGLSurface);
        }
    }

    void render() {
        if (mListener == null) {
            return;
        }

        mListener.thread_update();
        if (active()) {
            mListener.thread_render();//渲染某一个场景
        }
        swap();

    }
}
